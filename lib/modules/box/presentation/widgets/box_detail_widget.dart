import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../domain/models/box_model.dart';
import '../../../expense/domain/models/expense_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../user/domain/models/user_model.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/card/category_card.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/list_tile/list_tile_card.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../../../../shared/widgets/long_press_menu/long_press_menu.dart';
import '../../../../shared/utilities/extensions/date_extension.dart';
import '../../../expense/domain/di/expense_controller_di.dart';
import '../../domain/controllers/box_controller.dart';

class TotalExpenseBoxDetail extends ConsumerWidget {
  final num total;
  const TotalExpenseBoxDetail(this.total, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorConfig.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConfig.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: ColorConfig.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Expense',
                      style: FontConfig.body2().copyWith(
                        color: ColorConfig.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: FontConfig.h4().copyWith(
                        color: ColorConfig.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewBodyBoxDetail extends ConsumerWidget {
  final List<Widget> children;
  const ReviewBodyBoxDetail(this.children, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class FriendListBoxDetail extends ConsumerStatefulWidget {
  final BoxModel boxModel;
  const FriendListBoxDetail(this.boxModel, {super.key});

  @override
  ConsumerState<FriendListBoxDetail> createState() =>
      _FriendListBoxDetailState();
}

class _FriendListBoxDetailState extends ConsumerState<FriendListBoxDetail> {
  List<UserModel>? _users;
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (_isInitialized) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.boxModel.boxUsers.isEmpty) {
        setState(() {
          _users = [];
          _isLoading = false;
          _isInitialized = true;
        });
        return;
      }

      // Get users directly from controller
      final boxesController =
          ref.read(boxNotifierProvider(widget.boxModel.groupId).notifier);
      final users =
          await boxesController.getUsersInBox(widget.boxModel.boxUsers);

      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _users = [];
          _isLoading = false;
          _isInitialized = true;
        });
      }
    }
  }

  Widget friendItem(UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          FriendWidget(image: user.profileImage),
          const SizedBox(height: 5),
          Text(user.userName ?? user.email, style: FontConfig.overline()),
        ],
      ),
    );
  }

  Widget addFriendCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        children: [
          FriendWidget.add(),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                "Add",
                style: FontConfig.caption(),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 10),
          child: Text(
            'Friends',
            style: FontConfig.body1(),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 11),
              if (_users != null && _users!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _users!.length,
                  itemBuilder: (context, index) => friendItem(_users![index]),
                ),
              addFriendCard(),
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

class CategoryListBoxDetail extends ConsumerWidget {
  const CategoryListBoxDetail({super.key});

  List<Map<String, dynamic>> get _temporaryCategories => [
        {
          'icon': Icons.restaurant,
          'name': 'Food',
          'color': const Color(0xFFFF6B6B),
        },
        {
          'icon': Icons.directions_car,
          'name': 'Transport',
          'color': const Color(0xFF4ECDC4),
        },
        {
          'icon': Icons.shopping_bag,
          'name': 'Shopping',
          'color': const Color(0xFFFFBE0B),
        },
        {
          'icon': Icons.movie,
          'name': 'Entertainment',
          'color': const Color(0xFF845EC2),
        },
        {
          'icon': Icons.home,
          'name': 'Bills',
          'color': const Color(0xFF00B8A9),
        },
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: FontConfig.body1(),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorConfig.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "View All",
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _temporaryCategories.length,
            itemBuilder: (context, index) {
              final category = _temporaryCategories[index];
              return Container(
                width: 80,
                margin: EdgeInsets.only(
                  right: index != _temporaryCategories.length - 1 ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: category['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: category['color'].withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: category['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category['icon'],
                        color: category['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: FontConfig.caption().copyWith(
                        color: ColorConfig.midnight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ExpenseListBoxDetail extends ConsumerStatefulWidget {
  final BoxModel boxModel;
  final GroupModel groupModel;
  const ExpenseListBoxDetail({
    super.key,
    required this.boxModel,
    required this.groupModel,
  });

  @override
  ConsumerState<ExpenseListBoxDetail> createState() =>
      _ExpenseListBoxDetailState();
}

class _ExpenseListBoxDetailState extends ConsumerState<ExpenseListBoxDetail> {
  List<ExpenseModel>? _expenses;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  @override
  void dispose() {
    // Cancel any pending operations
    _isLoading = false;
    super.dispose();
  }

  Future<void> _fetchExpenses() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final expenseController = ref.read(expenseNotifierProvider.notifier);

      if (widget.boxModel.id != null) {
        final expenses =
            await expenseController.getExpensesInBox(widget.boxModel.id!);

        if (!mounted) return;

        setState(() {
          _expenses = expenses;
          _isLoading = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          _expenses = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the expense provider to trigger refresh when it changes
    ref.listen(expenseNotifierProvider, (previous, next) {
      if (mounted) {
        _fetchExpenses();
      }
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses',
            style: FontConfig.body1(),
          ),
          const SizedBox(height: 10),
          _buildExpenseList(),
        ],
      ),
    );
  }

  Widget _buildExpenseList() {
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_error != null) {
      return ErrorTextWidget(_error!);
    }

    if (_expenses == null || _expenses!.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
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
                Icons.receipt_long_outlined,
                size: 32,
                color: ColorConfig.primarySwatch,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Expenses Yet",
              style: FontConfig.h6().copyWith(
                color: ColorConfig.midnight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Create your first expense by tapping the + button",
              textAlign: TextAlign.center,
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch50,
              ),
            ),
          ],
        ),
      );
    }

    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _expenses!.length,
        itemBuilder: (context, index) {
          return ExpenseCardItem(
            expenseModel: _expenses![index],
            boxModel: widget.boxModel,
            groupModel: widget.groupModel,
          );
        },
      ),
    );
  }
}

class ExpenseCardItem extends ConsumerStatefulWidget {
  final ExpenseModel expenseModel;
  final BoxModel boxModel;
  final GroupModel groupModel;

  const ExpenseCardItem({
    super.key,
    required this.expenseModel,
    required this.boxModel,
    required this.groupModel,
  });

  @override
  ConsumerState<ExpenseCardItem> createState() => _ExpenseCardItemState();
}

class _ExpenseCardItemState extends ConsumerState<ExpenseCardItem> {
  bool _isDeleting = false;

  Future<void> _deleteExpense() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await ref.read(expenseNotifierProvider.notifier).deleteExpense(
          expenseModel: widget.expenseModel, boxModel: widget.boxModel);

      if (mounted) {
        showSnackBar(context, content: "Expense deleted successfully!!");

        // Instead of refreshing, navigate back if this was the last expense
        if (widget.boxModel.expenseIds.length <= 1) {
          if (context.mounted) {
            context.pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context,
            content: "Failed to delete expense: ${e.toString()}");
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();

    List<PopupMenuEntry> menuItems = [
      PopupMenuItem(
        child: const Text('Edit'),
        onTap: () => context.push(
          RouteName.updateExpense,
          extra: {
            "expenseModel": widget.expenseModel,
            "boxModel": widget.boxModel,
            "groupModel": widget.groupModel,
          },
        ),
      ),
      PopupMenuItem(
        onTap: _deleteExpense,
        child: const Text('Delete'),
      ),
    ];

    return Column(
      children: [
        _isDeleting
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Slidable(
                key: key,
                startActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      onPressed: (context) => context.push(
                        RouteName.updateExpense,
                        extra: {
                          "expenseModel": widget.expenseModel,
                          "boxModel": widget.boxModel,
                          "groupModel": widget.groupModel,
                        },
                      ),
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: _deleteExpense,
                  ),
                  children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      onPressed: (context) => _deleteExpense(),
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: LongPressMenuWidget(
                  items: menuItems,
                  onTap: () => context.push(
                    RouteName.expenseDetail,
                    extra: {"expenseId": widget.expenseModel.id},
                  ),
                  child: ListTileCard(
                    titleString: widget.expenseModel.title,
                    trailing: Text("\$${widget.expenseModel.cost}"),
                    visualDensity: const VisualDensity(vertical: -2),
                    subtitleString: widget.expenseModel.createdAt!.toTimeAgo(),
                  ),
                ),
              ),
        const SizedBox(height: 10),
      ],
    );
  }
}
