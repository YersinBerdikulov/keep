import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/appbar/sliver_appbar.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/floating_action_button/floating_action_button.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../../domain/controllers/box_controller.dart';
import '../widgets/box_detail_widget.dart';

class BoxDetailPage extends ConsumerWidget {
  final String boxId;
  final GroupModel groupModel;
  const BoxDetailPage({
    super.key,
    required this.boxId,
    required this.groupModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxDetail = ref.watch(getBoxDetailProvider(
      BoxDetailArgs(boxId: boxId, groupId: groupModel.id!),
    ));

    ref.listen<AsyncValue<List<BoxModel>>>(
      boxNotifierProvider(groupModel.id!),
      (previous, next) {
        next.when(
          data: (boxes) {
            // Refresh the group boxes provider
            // ref.read(getBoxesInGroupProvider(groupModel.id!));

            // Refresh the box details provider for the specific box
            // ref.refresh(getBoxDetailProvider(
            //   BoxDetailArgs(boxId: boxId, groupId: groupModel.id!),
            // ));
          },
          loading: () {
            // Optionally handle loading state
          },
          error: (error, stackTrace) {
            // Show error in a snackbar
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    //this section moved to ExpenseListBoxDetail
    //ref.listen<ExpenseState>(
    //  expenseNotifierProvider,
    //  (previous, next) {
    //    next.whenOrNull(
    //      loaded: () => ref.refresh(getExpensesInBoxProvider(boxId)),
    //      error: (message) => showSnackBar(context, content: message),
    //    );
    //  },
    //);

    return boxDetail.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (data) {
        //print(data.boxUser);
        return Scaffold(
          body: SliverAppBarWidget(
            image: data.image,
            //collapsedHeight: 120,
            height: 200,
            appbarTitle: TotalExpenseBoxDetail(data.total),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FriendListBoxDetail(data),
                //TODO: Think about the structure
                const CategoryListBoxDetail(),
                ExpenseListBoxDetail(
                  boxModel: data,
                  groupModel: groupModel,
                ),
              ],
            ),
          ),
          floatingActionButton: FABWidget(
            title: 'Expense',
            onPressed: () => context.push(
              RouteName.createExpense,
              extra: {"boxModel": data, "groupModel": groupModel},
            ),
          ),
        );
      },
    );
  }
}
