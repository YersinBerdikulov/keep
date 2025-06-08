import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/expense/domain/controllers/category_controller.dart';
import 'package:dongi/modules/expense/domain/di/category_controller_di.dart';
import 'package:dongi/modules/export/domain/di/export_service_di.dart';
import 'package:dongi/modules/home/domain/controllers/home_transactions_controller.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/card/card.dart';
import 'package:dongi/shared/widgets/dialog/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AllTransactionsPage extends ConsumerStatefulWidget {
  const AllTransactionsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AllTransactionsPage> createState() =>
      _AllTransactionsPageState();
}

class _AllTransactionsPageState extends ConsumerState<AllTransactionsPage> {
  @override
  void initState() {
    super.initState();
    // Refresh data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(homeTransactionsProvider);
    });
  }

  // Show export options dialog
  void _showExportOptions(
      List<RecentTransactionModel> transactions, List<Category> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Transactions',
              style: FontConfig.h5().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.baseGrey,
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: ColorConfig.midnight,
                  size: 20,
                ),
              ),
              title: Text(
                'Export as PDF',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                _exportTransactions(transactions, categories, 'pdf');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.baseGrey,
                ),
                child: Icon(
                  Icons.table_chart,
                  color: ColorConfig.midnight,
                  size: 20,
                ),
              ),
              title: Text(
                'Export as CSV',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                _exportTransactions(transactions, categories, 'csv');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.baseGrey,
                ),
                child: Icon(
                  Icons.insert_drive_file,
                  color: ColorConfig.midnight,
                  size: 20,
                ),
              ),
              title: Text(
                'Export as Excel',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                _exportTransactions(transactions, categories, 'excel');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Export transactions based on the selected format
  Future<void> _exportTransactions(List<RecentTransactionModel> transactions,
      List<Category> categories, String format) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final exportService = ref.read(exportServiceProvider);

      // Skip the permission check and directly create and share the file
      // Generate file based on selected format
      final file = format == 'pdf'
          ? await exportService.exportToPdf(transactions, categories)
          : format == 'csv'
              ? await exportService.exportToCsv(transactions, categories)
              : await exportService.exportToExcel(transactions, categories);

      if (mounted) Navigator.pop(context); // Dismiss loading indicator

      if (file != null && mounted) {
        // Share the file
        await exportService.shareFile(file);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create export file.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting file: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the full transactions list directly from the provider
    final transactionsProvider = ref.watch(homeTransactionsProvider);
    final categoriesProvider = ref.watch(categoryNotifierProvider);

    return Scaffold(
      backgroundColor: ColorConfig.baseGrey,
      appBar: AppBarWidget(
        title: 'Transaction History',
        automaticallyImplyLeading: true,
        showDrawer: false,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConfig.baseGrey,
              ),
              child: Icon(
                Icons.file_download,
                color: ColorConfig.midnight,
                size: 20,
              ),
            ),
            onPressed: () {
              transactionsProvider.when(
                data: (transactions) {
                  categoriesProvider.when(
                    data: (categories) {
                      if (transactions.isNotEmpty) {
                        _showExportOptions(transactions, categories);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No transactions to export.'),
                          ),
                        );
                      }
                    },
                    loading: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Loading categories...'),
                      ),
                    ),
                    error: (_, __) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error loading categories.'),
                      ),
                    ),
                  );
                },
                loading: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Loading transactions...'),
                  ),
                ),
                error: (_, __) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error loading transactions.'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: transactionsProvider.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading transactions: $error'),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text('No transactions found'),
            );
          }

          return categoriesProvider.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Error loading categories: $error'),
            ),
            data: (categories) {
              // Group transactions by date
              final groupedTransactions =
                  <String, List<RecentTransactionModel>>{};

              for (var transaction in transactions) {
                final date = transaction.createdAt.isNotEmpty
                    ? DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(transaction.createdAt))
                    : 'Unknown Date';

                if (!groupedTransactions.containsKey(date)) {
                  groupedTransactions[date] = [];
                }

                groupedTransactions[date]!.add(transaction);
              }

              // Sort dates newest first
              final sortedDates = groupedTransactions.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return RefreshIndicator(
                onRefresh: () async {
                  // Refresh transactions data
                  await ref.refresh(homeTransactionsProvider.future);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final dateTransactions = groupedTransactions[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _formatDate(date),
                            style: FontConfig.h6().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...dateTransactions.map((transaction) {
                          final category = categories.firstWhere(
                            (c) => c.id == transaction.categoryId,
                            orElse: () => Category(
                              name: 'Other',
                              icon: 'others',
                            ),
                          );

                          return TransactionCard(
                            transaction: transaction,
                            category: category,
                            currentUserId:
                                ref.read(currentUserProvider)?.id ?? '',
                            onTap: () {
                              context.push(
                                RouteName.expenseDetail,
                                extra: {'expenseId': transaction.id},
                              );
                            },
                          );
                        }).toList(),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr == 'Unknown Date') return dateStr;

    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      if (DateFormat('yyyy-MM-dd').format(date) ==
          DateFormat('yyyy-MM-dd').format(now)) {
        return 'Today';
      } else if (DateFormat('yyyy-MM-dd').format(date) ==
          DateFormat('yyyy-MM-dd').format(yesterday)) {
        return 'Yesterday';
      } else {
        return DateFormat('MMMM d, yyyy').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }
}

class TransactionCard extends StatelessWidget {
  final RecentTransactionModel transaction;
  final Category category;
  final String currentUserId;
  final VoidCallback onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.category,
    required this.currentUserId,
    required this.onTap,
  }) : super(key: key);

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'food':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_cart;
      case 'bills':
        return Icons.receipt;
      case 'health':
        return Icons.medical_services;
      case 'travel':
        return Icons.flight;
      case 'education':
        return Icons.school;
      default:
        return Icons.account_balance_wallet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreator = transaction.creatorId == currentUserId;

    return CardWidget(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ColorConfig.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(category.icon),
                color: ColorConfig.secondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: FontConfig.body1().copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCreator ? 'You paid' : 'You owe',
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.midnight.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${transaction.cost.toStringAsFixed(2)}',
                  style: FontConfig.body1().copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isCreator ? ColorConfig.error : ColorConfig.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                if (transaction.createdAt.isNotEmpty)
                  Text(
                    DateFormat('h:mm a')
                        .format(DateTime.parse(transaction.createdAt)),
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.midnight.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
