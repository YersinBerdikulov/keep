import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/appbar/sliver_appbar.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/floating_action_button/floating_action_button.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../../domain/di/group_controller_di.dart';
import '../widgets/group_detail_widget.dart';

class GroupDetailPage extends ConsumerWidget {
  final String groupId;
  const GroupDetailPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupDetail = ref.watch(groupDetailProvider(groupId));

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<void>>(
      groupNotifierProvider,
      (previous, next) {
        next.when(
          data: (_) {
            // Trigger refresh for related providers
            // ref.invalidate(getGroupsProvider);
            // ref.invalidate(getGroupDetailProvider(groupId));
            showSnackBar(context, content: "Successfully Updated!");
          },
          error: (error, stackTrace) {
            showSnackBar(context, content: error.toString());
          },
          loading: () {
            // Optional: Handle loading state if needed
          },
        );
      },
    );

    return groupDetail.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (data) {
        return Scaffold(
          //backgroundColor: ColorConfig.primarySwatch,
          //appBar: AppBar(elevation: 0),
          body: SliverAppBarWidget(
            height: 200,
            appbarTitle: GroupDetailTitle(groupName: data.title),
            image: data.image,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                GroupDetailInfo(groupModel: data),
                GroupDetailFriendList(
                  userIds: data.groupUsers,
                  groupModel: data,
                ),
                GroupDetailBoxGrid(groupModel: data),
                const SizedBox(height: 80),
              ],
            ),
          ),
          floatingActionButton: FABWidget(
            title: "Box",
            onPressed: () => context.push(
              RouteName.createBox,
              extra: {"groupModel": data},
            ),
          ),
        );
      },
    );
  }
}
