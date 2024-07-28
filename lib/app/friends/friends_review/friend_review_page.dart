import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/color_config.dart';
import '../../../widgets/appbar/sliver_appbar.dart';
import './friend_review_widget.dart';

class FriendReviewPage extends HookConsumerWidget {
  const FriendReviewPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorConfig.primarySwatch,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SliverAppBarWidget(
        /// * ----- total expense
        appbarTitle: const FriendNameWidget(),
        child: ListView(
          children: const [
            /// * ----- review
            ReviewSectionWidget(),

            /// * ----- expense list
            ExpensesListWidget(),
          ],
        ),
      ),
    );
  }
}
