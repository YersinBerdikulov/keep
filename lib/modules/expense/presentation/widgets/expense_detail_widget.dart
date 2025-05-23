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
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (data) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTileWidget(
              contentPadding: const EdgeInsets.fromLTRB(0, 2, 10, 2),
              headerString: "Created By",
              titleString: data!.userName ?? data.email,
              titleStringStyle: FontConfig.body1().copyWith(
                color: ColorConfig.pureWhite,
              ),
              headerStringStyle: FontConfig.overline().copyWith(
                color: ColorConfig.pureWhite..withAlpha((0.5 * 255).toInt()),
              ),
              leading: FriendWidget(
                backgroundColor: ColorConfig.grey,
                height: 40,
                width: 40,
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

  infoCard(String title, String content, {IconData? icon}) {
    return Expanded(
      child: SizedBox(
        height: 90,
        child: GreyCardWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: ColorConfig.primarySwatch,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: icon != null
                        ? Icon(icon, color: ColorConfig.white, size: 14)
                        : null,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: FontConfig.overline(),
              ),
              const SizedBox(height: 5),
              Text(
                content,
                style: FontConfig.body2(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // When adding a category section, first display the basic info cards
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              infoCard("Cost", expenseModel.cost.toString()),
              const SizedBox(width: 10),
              infoCard("Date", expenseModel.createdAt!.toHumanReadableFormat()),
              const SizedBox(width: 10),
              infoCard("Split By", expenseModel.expenseUsers.length.toString()),
            ],
          ),
        ),
        if (expenseModel.categoryId != null)
          CategoryInfoCard(categoryId: expenseModel.categoryId!),
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
    // For now, since we don't have a proper provider to get category by ID
    // Just show the category ID, in future could fetch the actual category
    print('Category ID in detail view: $categoryId');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GreyCardWidget(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                Icons.category,
                color: ColorConfig.primarySwatch,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category",
                    style: FontConfig.overline(),
                  ),
                  Text(
                    categoryId,
                    style: FontConfig.body2(),
                  ),
                ],
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
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(Icons.people_outline, size: 48, color: ColorConfig.grey),
              const SizedBox(height: 10),
              Text(
                "No members in this expense",
                style: FontConfig.body1().copyWith(color: ColorConfig.grey),
              ),
            ],
          ),
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
