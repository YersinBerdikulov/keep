import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/utilities/helpers/snackbar_helper.dart';
import '../../../../widgets/appbar/sliver_appbar.dart';
import '../../../../widgets/error/error.dart';
import '../../../../widgets/loading/loading.dart';
import '../widgets/expense_detail_widget.dart';

class ExpenseDetailPage extends ConsumerWidget {
  final String expenseId;
  const ExpenseDetailPage({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseDetail = ref.watch(getExpensesDetailProvider(expenseId));

    // Using listen without rebuilding the app
    ref.listen<AsyncValue<List<ExpenseModel>>>(
      expenseNotifierProvider,
      (previous, next) {
        next.when(
          data: (_) {
            ref.refresh(getExpensesDetailProvider(expenseId));
          },
          loading: () {
            // Optionally handle loading state
          },
          error: (error, stackTrace) {
            showSnackBar(context, error.toString());
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: ColorConfig.white,
      body: expenseDetail.when(
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => ErrorTextWidget(error),
        data: (data) {
          return SliverAppBarWidget(
            appbarTitle: UserInfoExpenseDetail(creatorId: data.creatorId),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                InfoExpenseDetail(expenseModel: data),
                MemberListExpenseDetail(members: data.expenseUsers),
              ],
            ),
          );
        },
      ),
    );
  }
}
