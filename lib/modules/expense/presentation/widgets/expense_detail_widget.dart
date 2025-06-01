import 'package:dongi/shared/utilities/extensions/date_extension.dart';
import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:dongi/shared/widgets/card/grey_card.dart';
import 'package:dongi/shared/widgets/list_tile/list_tile.dart';
import 'package:dongi/shared/widgets/list_tile/list_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/box/domain/controllers/box_controller.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/expense/domain/models/expense_user_model.dart';
import 'package:appwrite/models.dart';
import 'package:dongi/modules/expense/data/di/expense_di.dart';
import 'package:dongi/modules/user/data/di/user_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/loading/loading.dart';

class UserInfoExpenseDetail extends ConsumerWidget {
  final String creatorId;
  const UserInfoExpenseDetail({super.key, required this.creatorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creator = ref.watch(getUserDataForExpenseProvider(creatorId));

    return creator.when(
      loading: () => const LoadingWidget(),
      error: (error, _) => ErrorTextWidget(error),
      data: (user) => Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorConfig.primarySwatch.withOpacity(0.1),
            backgroundImage: user?.profileImage != null
                ? NetworkImage(user!.profileImage!)
                : null,
            child: user?.profileImage == null
                ? Text(
                    user?.userName?.isNotEmpty == true
                        ? user!.userName![0].toUpperCase()
                        : '?',
                    style: FontConfig.body1().copyWith(
                      color: ColorConfig.primarySwatch,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Created By',
                style: FontConfig.caption().copyWith(
                  color: ColorConfig.primarySwatch50,
                ),
              ),
              Text(
                user?.userName ?? user?.email ?? 'Unknown',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//class BoxReviewExpenseDetail extends ConsumerWidget {
//  final List<Widget> children;
//  const BoxReviewExpenseDetail(this.children, {super.key});
//  @override
//  Widget build(BuildContext context, WidgetRef ref) {
//    return Expanded(
//      flex: 3,
//      child: Container(
//        decoration: BoxDecoration(
//          color: ColorConfig.white,
//          borderRadius: const BorderRadius.only(
//            topLeft: Radius.circular(15),
//            topRight: Radius.circular(15),
//          ),
//        ),
//        child: ListView(
//          children: [
//            Column(children: children),
//          ],
//        ),
//      ),
//    );
//  }
//}

class InfoExpenseDetail extends ConsumerWidget {
  final ExpenseModel expenseModel;

  const InfoExpenseDetail({super.key, required this.expenseModel});

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      final month = _getMonthName(date.month).toLowerCase();
      return '${date.day} $month ${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget infoCard(String title, String content,
      {required IconData icon, Color? iconColor, bool isDate = false}) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? ColorConfig.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      content,
                      style: FontConfig.h6().copyWith(
                        color: ColorConfig.midnight,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfoCard(BuildContext context, String userId, String title, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConfig.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConfig.primarySwatch25,
          width: 1,
        ),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final userAsync = ref.watch(getUserDataForExpenseProvider(userId));
          
          return Padding(
            padding: const EdgeInsets.all(12),
            child: userAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (user) => Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: ColorConfig.primarySwatch.withOpacity(0.1),
                    backgroundImage: user?.profileImage != null
                        ? NetworkImage(user!.profileImage!)
                        : null,
                    child: user?.profileImage == null
                        ? Text(
                            user?.userName?.isNotEmpty == true
                                ? user!.userName![0].toUpperCase()
                                : '?',
                            style: FontConfig.body1().copyWith(
                              color: ColorConfig.primarySwatch,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              icon,
                              color: iconColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              title,
                              style: FontConfig.caption().copyWith(
                                color: iconColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.userName ?? user?.email ?? 'Unknown',
                          style: FontConfig.body1().copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConfig.midnight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              infoCard(
                "Amount",
                _formatCurrency(expenseModel.cost),
                icon: Icons.account_balance_wallet,
                iconColor: ColorConfig.secondary,
              ),
              const SizedBox(width: 10),
              infoCard(
                "Date",
                _formatDate(expenseModel.createdAt),
                icon: Icons.calendar_today,
                iconColor: ColorConfig.primarySwatch,
                isDate: true,
              ),
              const SizedBox(width: 10),
              infoCard(
                "Split By",
                "${expenseModel.expenseUsers.length} people",
                icon: Icons.group,
                iconColor: ColorConfig.error,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              userInfoCard(
                context,
                expenseModel.creatorId,
                "Created by",
                Icons.person_outline,
                ColorConfig.secondary,
              ),
              const SizedBox(height: 10),
              userInfoCard(
                context,
                expenseModel.payerId,
                "Made by",
                Icons.account_balance_wallet_outlined,
                ColorConfig.primarySwatch,
              ),
            ],
          ),
        ),
        if (expenseModel.categoryId != null) ...[
          const SizedBox(height: 16),
          CategoryInfoCard(categoryId: expenseModel.categoryId!),
        ],
      ],
    );
  }

  String _formatCurrency(num amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}

class SplitDetailsCard extends ConsumerStatefulWidget {
  final ExpenseModel expenseModel;

  const SplitDetailsCard({super.key, required this.expenseModel});

  @override
  ConsumerState<SplitDetailsCard> createState() => _SplitDetailsCardState();
}

class _SplitDetailsCardState extends ConsumerState<SplitDetailsCard> {
  // Change to use nullable String keys
  final Map<String?, bool> _userLoadingStates = {};
  final Map<String?, bool> _userSettlementStates = {};

  @override
  void initState() {
    super.initState();
    // Initialize states on widget creation
    _refreshExpenseData();
  }

  Future<void> _refreshExpenseData() async {
    if (!mounted) return;
    
    // Safety check for expense ID
    final expenseId = widget.expenseModel.id;
    if (expenseId == null) {
      print('Cannot refresh: expense ID is null');
      return;
    }
    
    try {
      // Use the expenseNotifier to get data instead of direct repository access
      final expenseNotifier = ref.read(expenseNotifierProvider.notifier);
      final expenseModel = await expenseNotifier.getExpenseDetail(expenseId);
      
      if (expenseModel == null || !mounted) return;
      
      // Use the expenseDetailsProvider to get the expense users safely
      final expenseUsersProvider = getExpenseUsersForExpenseProvider(expenseModel.id!);
      final expenseUsersAsyncValue = await ref.read(expenseUsersProvider.future);
      
      if (!mounted) return;
      
      setState(() {
        for (var expenseUser in expenseUsersAsyncValue) {
          if (expenseUser.data == null) continue;
          
          try {
            final expenseUserModel = ExpenseUserModel.fromJson(expenseUser.data);
            final userId = expenseUserModel.userId;
            
            // userId can be null, which is fine for our Map with nullable keys
            _userSettlementStates[userId] = expenseUserModel.isSettled;
            _userLoadingStates[userId] = false;
          } catch (e) {
            print('Error processing expense user: $e');
            // Continue with next expense user if there's an error
          }
        }
      });
    } catch (e) {
      print('Error loading expense data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load expense data: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Safety check for null ID
    final expenseId = widget.expenseModel.id;
    if (expenseId == null) {
      return const Center(child: Text('Invalid expense ID'));
    }
    
    // Watch the expense details to get real-time updates
    final expenseDetailsAsync = ref.watch(expenseDetailsProvider(expenseId));
    
    // Listen for changes in expense details
    ref.listen(expenseDetailsProvider(expenseId), (previous, next) {
      // Only proceed if both values are not null and are of the right type
      if (previous != null && next != null && 
          previous is AsyncData<ExpenseModel> && next is AsyncData<ExpenseModel>) {
        // Only refresh if the data actually changed
        if (previous.value?.id != next.value?.id || 
            previous.value?.updatedAt != next.value?.updatedAt) {
          print('Expense details changed, refreshing data');
          _refreshExpenseData();
        }
      }
    });
    
    // Handle the result of the watch
    return expenseDetailsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error.toString().split('\n')[0]}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Invalidate providers and retry
                ref.invalidate(expenseDetailsProvider(expenseId));
                ref.invalidate(getExpenseUsersForExpenseProvider(expenseId));
                _refreshExpenseData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (expenseDetails) {
        // Use the provider to fetch expense users
        final splitUsersAsync = ref.watch(getExpenseUsersProvider(expenseDetails.expenseUsers));
        
        return splitUsersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error fetching users: ${error.toString().split('\n')[0]}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(getExpenseUsersProvider(expenseDetails.expenseUsers));
                    _refreshExpenseData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (users) {
            // Debug print to check user IDs
            print('Split users: ${users.map((u) => u.id).toList()}');
            print('Expected users: ${expenseDetails.expenseUsers}');
            
            if (users.isEmpty && expenseDetails.expenseUsers.isNotEmpty) {
              // Use the user repository directly as a fallback
              return FutureBuilder<List<UserModel>>(
                future: ref.read(userRepositoryProvider).getUsersByIds(expenseDetails.expenseUsers),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  
                  final fetchedUsers = snapshot.data ?? [];
                  if (fetchedUsers.isEmpty) {
                    // One more fallback - try to get any users from the system
                    return FutureBuilder<List<UserModel>>(
                      future: _fetchAnyUsers(ref),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final anyUsers = snapshot.data ?? [];
                        if (anyUsers.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline, size: 48, color: ColorConfig.error),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No users found. The expense might have invalid user references.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Try refreshing or contact support if this issue persists.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        // If we found any users in the system, show them
                        // This is better than showing nothing
                        print('Using ${anyUsers.length} system users as fallback');
                        final expenseUsersAsync = ref.watch(getExpenseUsersForExpenseProvider(expenseDetails.id!));
                        return _buildExpenseUsersList(expenseDetails, anyUsers, expenseUsersAsync);
                      },
                    );
                  }
                  
                  // Continue with the fetched users
                  users = fetchedUsers;
                  
                  // Fetch expense users once for all users
                  final expenseUsersAsync = ref.watch(getExpenseUsersForExpenseProvider(expenseDetails.id!));
                  
                  // Same logic as below but with fetched users
                  return _buildExpenseUsersList(expenseDetails, fetchedUsers, expenseUsersAsync);
                },
              );
            }
            
            if (users.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            // Fetch expense users once for all users
            final expenseUsersAsync = ref.watch(getExpenseUsersForExpenseProvider(expenseDetails.id!));
            
            return _buildExpenseUsersList(expenseDetails, users, expenseUsersAsync);
          },
        );
      },
    );
  }

  Widget _buildExpenseUsersList(ExpenseModel expenseDetails, List<UserModel> users, AsyncValue<List<Document>> expenseUsersAsync) {
    // Listen for changes in expense users
    ref.listen(getExpenseUsersForExpenseProvider(expenseDetails.id!), (previous, next) {
      if (previous != null && next != null && 
          previous is AsyncData<List<Document>> && next is AsyncData<List<Document>>) {
        // Only refresh if the data actually changed
        final prevList = previous.value;
        final nextList = next.value;
        
        if (prevList != null && nextList != null) {
          if (prevList.length != nextList.length || 
              prevList.any((prevDoc) {
                // Find matching document in next list
                final matchingDocs = nextList.where((nextDoc) => nextDoc.$id == prevDoc.$id).toList();
                if (matchingDocs.isEmpty) return true;
                
                // Compare data
                return !_mapsEqual(prevDoc.data, matchingDocs.first.data);
              })) {
            print('Expense users changed, refreshing data');
            _refreshExpenseData();
          }
        }
      }
    });
    
    return expenseUsersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (expenseUserDocs) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            decoration: BoxDecoration(
              color: ColorConfig.grey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorConfig.primarySwatch25,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expenseDetails.isSettled
                        ? 'Expense settled'
                        : 'Split equally between ${users.length} people',
                    style: FontConfig.body2().copyWith(
                      color: expenseDetails.isSettled ? ColorConfig.success : ColorConfig.midnight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  // Add refresh button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          // Show loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Refreshing data...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          
                          try {
                            // Call the refresh method
                            final expenseController = ref.read(expenseNotifierProvider.notifier);
                            await expenseController.refreshExpenseData(
                              expenseDetails.id!,
                              expenseDetails.boxId!,
                            );
                            
                            // Invalidate providers to force UI refresh
                            ref.invalidate(expenseDetailsProvider(expenseDetails.id!));
                            ref.invalidate(getExpenseUsersForExpenseProvider(expenseDetails.id!));
                            
                            // Refresh local state
                            await _refreshExpenseData();
                            
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data refreshed successfully'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error refreshing data: $e');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error refreshing data: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Refresh'),
                        style: TextButton.styleFrom(
                          foregroundColor: ColorConfig.primarySwatch,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  ...users.map((user) {
                    if (user.id == null) {
                      return const SizedBox.shrink();
                    }
                    
                    // Try to find the matching expense user
                    Document? matchingExpenseUser;
                    ExpenseUserModel? expenseUserModel;
                    
                    try {
                      // First try exact match
                      try {
                        matchingExpenseUser = expenseUserDocs.firstWhere(
                          (eu) {
                            final model = ExpenseUserModel.fromJson(eu.data);
                            return model.userId == user.id;
                          },
                        );
                      } catch (e) {
                        // If exact match fails, try prefix match (handling truncated IDs)
                        print('Exact match failed for user ${user.id}, trying prefix match');
                        matchingExpenseUser = expenseUserDocs.firstWhere(
                          (eu) {
                            final model = ExpenseUserModel.fromJson(eu.data);
                            // Check if either ID starts with the other (handles truncation in either direction)
                            final userId = model.userId;
                            if (userId == null || user.id == null) return false;
                            
                            return userId.startsWith(user.id!) || user.id!.startsWith(userId);
                          },
                          orElse: () => throw Exception('No matching expense user found with prefix match'),
                        );
                      }
                      
                      expenseUserModel = ExpenseUserModel.fromJson(matchingExpenseUser.data);
                    } catch (e) {
                      print('Error finding expense user for ${user.id}: $e');
                      // If we can't find a matching expense user, just skip this user
                      return const SizedBox.shrink();
                    }
                    
                    // Update local state on first load
                    if (!_userSettlementStates.containsKey(user.id)) {
                      _userSettlementStates[user.id] = expenseUserModel.isSettled;
                    }
                    
                    // Find the payer user
                    UserModel payerUser;
                    try {
                      payerUser = users.firstWhere(
                        (u) => u.id == expenseDetails.payerId,
                        orElse: () => throw Exception('Payer user not found'),
                      );
                    } catch (e) {
                      print('Error finding payer user: $e');
                      payerUser = user; // Fallback to current user if payer not found
                    }
                    
                    final payerName = payerUser.userName ?? payerUser.email ?? 'Unknown';
                    
                    // Use our local state
                    final isLoading = _userLoadingStates[user.id] ?? false;
                    final isSettled = _userSettlementStates[user.id] ?? expenseUserModel.isSettled;
                    
                    String subtitle;
                    if (isSettled) {
                      subtitle = "Settled";
                    } else if (user.id == expenseDetails.payerId) {
                      subtitle = "Paid \$${expenseDetails.cost.toStringAsFixed(2)}";
                    } else {
                      subtitle = "Owes \$${expenseUserModel.cost.toStringAsFixed(2)} to $payerName";
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ListTileCard(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: ColorConfig.primarySwatch.withOpacity(0.1),
                          backgroundImage: user.profileImage != null
                              ? NetworkImage(user.profileImage!)
                              : null,
                          child: user.profileImage == null
                              ? Text(
                                  (user.userName ?? user.email ?? "?")[0].toUpperCase(),
                                  style: FontConfig.body1().copyWith(
                                    color: ColorConfig.primarySwatch,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : null,
                        ),
                        titleString: user.userName ?? user.email ?? "Unknown",
                        subtitleString: isLoading ? "Updating status..." : subtitle,
                        subtitleStyle: TextStyle(
                          color: isSettled
                              ? ColorConfig.success
                              : user.id == expenseDetails.payerId
                                  ? ColorConfig.primarySwatch
                                  : ColorConfig.error,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: user.id != expenseDetails.payerId
                            ? isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : isSettled
                                    ? TextButton.icon(
                                        onPressed: () async {
                                          // Ensure we have a valid user ID
                                          if (user.id == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Invalid user ID')),
                                            );
                                            return;
                                          }

                                          // Show confirmation dialog
                                          final shouldCancel = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Cancel Settlement'),
                                              content: const Text('Are you sure you want to cancel this settlement?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (shouldCancel == true) {
                                            // Update local state first
                                            setState(() {
                                              _userLoadingStates[user.id] = true;
                                            });
                                            
                                            try {
                                              final expenseController = ref.read(expenseNotifierProvider.notifier);
                                              await expenseController.cancelSettleUpExpenseUser(expenseDetails.id!, user.id!);
                                              
                                              // Update local state
                                              if (mounted) {
                                                setState(() {
                                                  _userSettlementStates[user.id] = false;
                                                  _userLoadingStates[user.id] = false;
                                                });
                                              }
                                              
                                              // Invalidate all relevant providers
                                              ref.invalidate(expenseNotifierProvider);
                                              ref.invalidate(expenseDetailsProvider(expenseDetails.id!));
                                              ref.invalidate(getExpenseUsersForExpenseProvider(expenseDetails.id!));
                                            } catch (e) {
                                              print('Error canceling settlement: $e');
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Failed to cancel settlement: $e')),
                                                );
                                                setState(() {
                                                  _userLoadingStates[user.id] = false;
                                                });
                                              }
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.undo, size: 16),
                                        label: const Text('Cancel Settlement'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: ColorConfig.error,
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          // Ensure we have a valid user ID
                                          if (user.id == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Invalid user ID')),
                                            );
                                            return;
                                          }

                                          // Update local state first
                                          setState(() {
                                            _userLoadingStates[user.id] = true;
                                          });
                                          
                                          try {
                                            final expenseController = ref.read(expenseNotifierProvider.notifier);
                                            await expenseController.settleUpExpenseUser(expenseDetails.id!, user.id!);
                                            
                                            // Update local state
                                            if (mounted) {
                                              setState(() {
                                                _userSettlementStates[user.id] = true;
                                                _userLoadingStates[user.id] = false;
                                              });
                                            }
                                            
                                            // Invalidate all relevant providers
                                            ref.invalidate(expenseNotifierProvider);
                                            ref.invalidate(expenseDetailsProvider(expenseDetails.id!));
                                            ref.invalidate(getExpenseUsersForExpenseProvider(expenseDetails.id!));
                                          } catch (e) {
                                            print('Error settling up: $e');
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Failed to settle: $e')),
                                              );
                                              setState(() {
                                                _userLoadingStates[user.id] = false;
                                              });
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorConfig.midnight,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Settle'),
                                      )
                            : null,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to compare maps
  bool _mapsEqual(Map<String, dynamic>? map1, Map<String, dynamic>? map2) {
    if (map1 == null && map2 == null) return true;
    if (map1 == null || map2 == null) return false;
    if (map1.length != map2.length) return false;
    
    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      if (map1[key] != map2[key]) return false;
    }
    
    return true;
  }

  // Helper method to fetch any users from the system as a last resort
  Future<List<UserModel>> _fetchAnyUsers(WidgetRef ref) async {
    try {
      print('Attempting to fetch any users from the system as fallback');
      // Try to get the current user first
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        print('Using current user as fallback');
        // Convert AuthUserModel to UserModel by fetching it from the repository
        try {
          final userController = ref.read(userNotifierProvider.notifier);
          final userModel = await userController.getUserData(currentUser.id);
          if (userModel != null) {
            print('Successfully converted AuthUserModel to UserModel');
            return [userModel];
          }
        } catch (e) {
          print('Error converting current user to UserModel: $e');
        }
      }
      
      // If that fails, try to get users from the box
      try {
        final boxUsers = ref.read(userInBoxStoreProvider);
        if (boxUsers.isNotEmpty) {
          print('Using ${boxUsers.length} users from current box');
          return boxUsers;
        }
      } catch (e) {
        print('Error getting box users: $e');
      }
      
      // Last resort - try to get any users via the repository
      try {
        final userRepository = ref.read(userRepositoryProvider);
        final users = await userRepository.getUsersByIds([]);
        if (users.isNotEmpty) {
          print('Found ${users.length} users in system');
          return users.take(3).toList(); // Limit to 3 users
        }
      } catch (e) {
        print('Error fetching any users: $e');
      }
      
      return [];
    } catch (e) {
      print('Error in _fetchAnyUsers: $e');
      return [];
    }
  }
}

class CategoryInfoCard extends ConsumerWidget {
  final String categoryId;

  const CategoryInfoCard({super.key, required this.categoryId});

  Map<String, IconData> getCategoryIcon() {
    return {
      'food': Icons.restaurant,
      'transportation': Icons.directions_car,
      'entertainment': Icons.movie,
      'shopping': Icons.shopping_bag,
      'bills': Icons.receipt,
      'health': Icons.medical_services,
      'travel': Icons.flight,
      'education': Icons.school,
      'others': Icons.category_outlined,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorConfig.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.category,
                  color: ColorConfig.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: FontConfig.overline().copyWith(
                        color: ColorConfig.primarySwatch50,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoryId,
                      style: FontConfig.body1().copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorConfig.midnight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberListExpenseDetail extends ConsumerWidget {
  final List<String> members;
  const MemberListExpenseDetail({super.key, required this.members});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle empty members list
    if (members.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 25, 16, 25),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group_off_outlined,
                size: 32,
                color: ColorConfig.primarySwatch,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Members Yet",
              style: FontConfig.h6().copyWith(
                color: ColorConfig.midnight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "This expense hasn't been split with anyone",
              textAlign: TextAlign.center,
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch50,
              ),
            ),
          ],
        ),
      );
    }

    final expenseMember = ref.watch(getUsersListData(members));

    return expenseMember.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTileCard(
                  titleString: data[index].userName ?? data[index].email,
                  trailing: const Text("\$53"),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConfig.primarySwatch,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
