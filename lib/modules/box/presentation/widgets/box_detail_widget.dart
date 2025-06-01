import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
import '../../../../shared/widgets/permission_widgets.dart';
import '../../../auth/domain/di/auth_controller_di.dart';
import '../../../group/domain/di/group_controller_di.dart';

class BoxTitleHeader extends ConsumerWidget {
  final BoxModel boxModel;
  const BoxTitleHeader(this.boxModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boxModel.title,
          style: FontConfig.h5().copyWith(
            color: ColorConfig.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorConfig.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${boxModel.boxUsers.length} members",
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void didUpdateWidget(FriendListBoxDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.boxModel != widget.boxModel) {
      _fetchUsers();
    }
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.boxModel.boxUsers.isEmpty) {
        setState(() {
          _users = [];
          _isLoading = false;
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
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _users = [];
          _isLoading = false;
        });
      }
    }
  }

  Widget friendCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: ColorConfig.primarySwatch25,
                width: 2,
              ),
            ),
            child: FriendWidget(
              image: user.profileImage,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.userName ?? user.email,
            style: FontConfig.caption().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget addFriendCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteName.addBoxMember, extra: widget.boxModel),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: ColorConfig.secondary.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: FriendWidget.add(),
            ),
            const SizedBox(height: 8),
            Text(
              "Invite",
              style: FontConfig.caption().copyWith(
                color: ColorConfig.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch box updates to refresh users when needed
    ref.watch(boxNotifierProvider(widget.boxModel.groupId)).whenData((boxes) {
      final updatedBox = boxes.firstWhere(
        (box) => box.id == widget.boxModel.id,
        orElse: () => widget.boxModel,
      );
      if (updatedBox.id == widget.boxModel.id &&
          !listEquals(updatedBox.boxUsers, widget.boxModel.boxUsers)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fetchUsers();
        });
      }
    });

    if (_isLoading) {
      return const LoadingWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Members',
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
        if (_users == null || _users!.isEmpty)
          _buildEmptyMembers()
        else
          SizedBox(
            height: 90,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                ..._users!.map((user) => friendCard(user)).toList(),
                addFriendCard(context),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEmptyMembers() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
            "Invite your friends to join this box",
            textAlign: TextAlign.center,
            style: FontConfig.body2().copyWith(
              color: ColorConfig.primarySwatch50,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryListBoxDetail extends ConsumerWidget {
  const CategoryListBoxDetail({super.key});

  List<Map<String, dynamic>> get _temporaryCategories => [
        {
          'icon': Icons.restaurant,
          'name': 'Food',
          'id': 'food',
          'color': const Color(0xFFFF6B6B),
        },
        {
          'icon': Icons.directions_car,
          'name': 'Transport',
          'id': 'transportation',
          'color': const Color(0xFF4ECDC4),
        },
        {
          'icon': Icons.shopping_bag,
          'name': 'Shopping',
          'id': 'shopping',
          'color': const Color(0xFFFFBE0B),
        },
        {
          'icon': Icons.movie,
          'name': 'Entertainment',
          'id': 'entertainment',
          'color': const Color(0xFF845EC2),
        },
        {
          'icon': Icons.home,
          'name': 'Bills',
          'id': 'bills',
          'color': const Color(0xFF00B8A9),
        },
        {
          'icon': Icons.medical_services,
          'name': 'Health',
          'id': 'health',
          'color': const Color(0xFF4D8076),
        },
        {
          'icon': Icons.flight,
          'name': 'Travel',
          'id': 'travel',
          'color': const Color(0xFFFF9671),
        },
        {
          'icon': Icons.school,
          'name': 'Education',
          'id': 'education',
          'color': const Color(0xFF00C9A7),
        },
        {
          'icon': Icons.category_outlined,
          'name': 'Others',
          'id': 'others',
          'color': const Color(0xFF4B4453),
        },
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);

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
              final isSelected = selectedCategory == category['id'];

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    ref.read(selectedCategoryFilterProvider.notifier).state =
                        null;
                  } else {
                    ref.read(selectedCategoryFilterProvider.notifier).state =
                        category['id'];
                  }
                },
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(
                    right: index != _temporaryCategories.length - 1 ? 12 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category['color']
                        : category['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? category['color']
                          : category['color'].withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          color: isSelected ? Colors.white : category['color'],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white : category['color'],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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

class _ExpenseListBoxDetailState extends ConsumerState<ExpenseListBoxDetail>
    with AutomaticKeepAliveClientMixin {
  List<ExpenseModel>? _expenses;
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  @override
  void dispose() {
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
    super.build(context);

    // Watch the expense provider to trigger refresh when it changes
    ref.listen(expenseNotifierProvider, (previous, next) {
      if (mounted) {
        _fetchExpenses();
      }
    });

    // Watch the category filter
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);

    // Filter expenses by category if one is selected
    final filteredExpenses = selectedCategory != null && _expenses != null
        ? _expenses!.where((e) {
            if (e.categoryId == null) return false;
            final expenseCategoryName = e.categoryId!.contains('_')
                ? e.categoryId!.split('_').sublist(1).join('_')
                : e.categoryId!;
            final selectedCategoryName = selectedCategory.contains('_')
                ? selectedCategory.split('_').sublist(1).join('_')
                : selectedCategory;
            return expenseCategoryName.toLowerCase() ==
                selectedCategoryName.toLowerCase();
          }).toList()
        : _expenses;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expenses',
                style: FontConfig.body1(),
              ),
              if (selectedCategory != null)
                GestureDetector(
                  onTap: () {
                    ref.read(selectedCategoryFilterProvider.notifier).state =
                        null;
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ColorConfig.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Clear Filter",
                          style: FontConfig.caption().copyWith(
                            color: ColorConfig.secondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.close,
                          size: 16,
                          color: ColorConfig.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _buildExpenseList(filteredExpenses),
        ],
      ),
    );
  }

  Widget _buildExpenseList(List<ExpenseModel>? expenses) {
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_error != null) {
      return ErrorTextWidget(_error!);
    }

    if (expenses == null || expenses.isEmpty) {
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
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return ExpenseCardItem(
            expenseModel: expenses[index],
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
  Key key = UniqueKey();

  Map<String, Map<String, dynamic>> getCategoryInfo() {
    return {
      'food': {
        'icon': Icons.restaurant,
        'name': 'Food',
        'color': ColorConfig.secondary,
      },
      'transportation': {
        'icon': Icons.directions_car,
        'name': 'Transportation',
        'color': ColorConfig.secondary,
      },
      'entertainment': {
        'icon': Icons.movie,
        'name': 'Entertainment',
        'color': ColorConfig.secondary,
      },
      'shopping': {
        'icon': Icons.shopping_bag,
        'name': 'Shopping',
        'color': ColorConfig.secondary,
      },
      'bills': {
        'icon': Icons.receipt,
        'name': 'Bills',
        'color': ColorConfig.secondary,
      },
      'health': {
        'icon': Icons.medical_services,
        'name': 'Health',
        'color': ColorConfig.secondary,
      },
      'travel': {
        'icon': Icons.flight,
        'name': 'Travel',
        'color': ColorConfig.secondary,
      },
      'education': {
        'icon': Icons.school,
        'name': 'Education',
        'color': ColorConfig.secondary,
      },
      'others': {
        'icon': Icons.category_outlined,
        'name': 'Others',
        'color': ColorConfig.secondary,
      },
    };
  }

  List<PopupMenuEntry> get menuItems => [
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
        if (ref.read(currentUserProvider)?.id ==
                widget.expenseModel.creatorId ||
            ref.watch(isCurrentUserAdminProvider(widget.groupModel.id!)))
          PopupMenuItem(
            child: const Text('Delete'),
            onTap: () async {
              setState(() {
                _isDeleting = true;
              });

              try {
                await ref.read(expenseNotifierProvider.notifier).deleteExpense(
                      expenseModel: widget.expenseModel,
                      boxModel: widget.boxModel,
                    );

                if (!mounted) return;

                showSnackBar(
                  context,
                  content: 'Expense deleted successfully',
                );
              } catch (e) {
                if (!mounted) return;

                showSnackBar(
                  context,
                  content: e.toString(),
                );
              } finally {
                if (mounted) {
                  setState(() {
                    _isDeleting = false;
                  });
                }
              }
            },
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final categoryInfo = getCategoryInfo();
    final currentCategory = widget.expenseModel.categoryId?.toLowerCase();
    final categoryData =
        currentCategory != null ? categoryInfo[currentCategory] : null;

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
                  children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      onPressed: (context) async {
                        setState(() {
                          _isDeleting = true;
                        });

                        try {
                          await ref
                              .read(expenseNotifierProvider.notifier)
                              .deleteExpense(
                                expenseModel: widget.expenseModel,
                                boxModel: widget.boxModel,
                              );

                          if (!mounted) return;

                          showSnackBar(
                            context,
                            content: 'Expense deleted successfully',
                          );
                        } catch (e) {
                          if (!mounted) return;

                          showSnackBar(
                            context,
                            content: e.toString(),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isDeleting = false;
                            });
                          }
                        }
                      },
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
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("\$${widget.expenseModel.cost}"),
                        if (categoryData != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorConfig.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  categoryData['icon'],
                                  size: 12,
                                  color: ColorConfig.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  categoryData['name'],
                                  style: FontConfig.caption().copyWith(
                                    color: ColorConfig.secondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    visualDensity: const VisualDensity(vertical: -1),
                    subtitleString: widget.expenseModel.createdAt!.toTimeAgo(),
                    leading: GestureDetector(
                      onTap: () {
                        if (widget.expenseModel.categoryId != null) {
                          // Toggle category filter
                          final currentFilter =
                              ref.read(selectedCategoryFilterProvider);
                          if (currentFilter == widget.expenseModel.categoryId) {
                            // If current category is selected, clear filter
                            ref
                                .read(selectedCategoryFilterProvider.notifier)
                                .state = null;
                          } else {
                            // Otherwise set to this category
                            ref
                                .read(selectedCategoryFilterProvider.notifier)
                                .state = widget.expenseModel.categoryId;
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: categoryData != null
                              ? ColorConfig.secondary.withOpacity(0.1)
                              : (widget.expenseModel.isSettled
                                  ? ColorConfig.success.withOpacity(0.1)
                                  : const Color(0xFFFE4A49).withOpacity(0.1)),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          categoryData != null
                              ? categoryData['icon']
                              : (widget.expenseModel.isSettled
                                  ? Icons.check_circle
                                  : Icons.currency_exchange),
                          size: 16,
                          color: categoryData != null
                              ? ColorConfig.secondary
                              : (widget.expenseModel.isSettled
                                  ? ColorConfig.success
                                  : const Color(0xFFFE4A49)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 10),
      ],
    );
  }
}
