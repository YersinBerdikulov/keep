import 'package:dongi/shared/utilities/extensions/date_extension.dart';
import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/shared/widgets/card/grey_card.dart';
import 'package:dongi/shared/widgets/list_tile/list_tile.dart';
import 'package:dongi/shared/widgets/list_tile/list_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      error: (error, stackTrace) => ListTileWidget(
        contentPadding: const EdgeInsets.fromLTRB(0, 2, 10, 2),
        headerString: "Created By",
        titleString: "Unknown User",
        titleStringStyle: FontConfig.body1().copyWith(
          color: ColorConfig.pureWhite,
        ),
        headerStringStyle: FontConfig.overline().copyWith(
          color: ColorConfig.pureWhite.withAlpha((0.5 * 255).toInt()),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorConfig.grey.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline,
            color: ColorConfig.pureWhite,
            size: 24,
          ),
        ),
      ),
      data: (data) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTileWidget(
              contentPadding: const EdgeInsets.fromLTRB(0, 2, 10, 2),
              headerString: "Created By",
              titleString: data?.userName ?? data?.email ?? "Unknown User",
              titleStringStyle: FontConfig.body1().copyWith(
                color: ColorConfig.pureWhite,
              ),
              headerStringStyle: FontConfig.overline().copyWith(
                color: ColorConfig.pureWhite.withAlpha((0.5 * 255).toInt()),
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: data == null
                      ? ColorConfig.grey.withOpacity(0.5)
                      : ColorConfig.primarySwatch.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: data?.profileImage == null
                    ? Icon(
                        Icons.person_outline,
                        color: ColorConfig.pureWhite,
                        size: 24,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          data!.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person_outline,
                            color: ColorConfig.pureWhite,
                            size: 24,
                          ),
                        ),
                      ),
              ),
              trailing: Icon(
                Icons.info_outline,
                color: ColorConfig.secondary,
              ),
            ),
          ],
        );
      },
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

  Widget infoCard(String title, String content,
      {required IconData icon, Color? iconColor}) {
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (iconColor ?? ColorConfig.primarySwatch).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? ColorConfig.primarySwatch,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: FontConfig.overline().copyWith(
                  color: ColorConfig.primarySwatch50,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConfig.midnight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(num amount) {
    return '\$${amount.toStringAsFixed(2)}';
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
                expenseModel.createdAt!.toHumanReadableFormat(),
                icon: Icons.calendar_today,
                iconColor: ColorConfig.primarySwatch,
              ),
              const SizedBox(width: 10),
              infoCard(
                "Split By",
                "1 person", // Temporarily hardcoded
                icon: Icons.group,
                iconColor: ColorConfig.error,
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
