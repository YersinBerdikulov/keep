import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';

class ManageGroupMembersPage extends HookConsumerWidget {
  final GroupModel groupModel;

  const ManageGroupMembersPage({super.key, required this.groupModel});

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorConfig.primarySwatch.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 32,
              color: ColorConfig.primarySwatch,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Members',
            style: FontConfig.h6().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This group has no members yet',
            textAlign: TextAlign.center,
            style: FontConfig.body2().copyWith(
              color: ColorConfig.primarySwatch50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.read(currentUserProvider)!.id;
    final groupMembers = ref.watch(groupMembersProvider(groupModel.groupUsers));

    void _removeUserFromGroup(String userId) async {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Remove user from group
        await ref.read(groupNotifierProvider.notifier).deleteMember(
              groupModel: groupModel,
              memberIdToDelete: userId,
            );

        // Refresh data in home and group screens
        ref.invalidate(homeNotifierProvider);
        ref.invalidate(groupMembersProvider(groupModel.groupUsers));

        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        // Show success message
        if (context.mounted) {
          showSnackBar(context, content: 'Member removed successfully');
        }
      } catch (e) {
        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        // Show error message
        if (context.mounted) {
          showSnackBar(context,
              content: 'Failed to remove member: ${e.toString()}');
        }
      }
    }

    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            // Data updated successfully
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    return Scaffold(
      appBar: AppBarWidget(
        title: "Manage Members",
        showDrawer: false,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Members',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: SizeConfig.width(context),
                  decoration: BoxDecoration(
                    color: ColorConfig.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: groupMembers.when(
                    data: (members) {
                      if (members.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          final isCreator = member.id == groupModel.creatorId;
                          final isCurrentUser = member.id == currentUserId;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: ColorConfig.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    ColorConfig.primarySwatch.withOpacity(0.1),
                                backgroundImage: member.profileImage != null
                                    ? NetworkImage(member.profileImage!)
                                    : null,
                                child: member.profileImage == null
                                    ? Text(
                                        member.userName?[0].toUpperCase() ?? '',
                                        style: FontConfig.body1().copyWith(
                                          color: ColorConfig.primarySwatch,
                                        ),
                                      )
                                    : null,
                              ),
                              title: Text(
                                member.userName ?? 'Unknown User',
                                style: FontConfig.body2().copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                isCreator ? 'Creator' : 'Member',
                                style: FontConfig.caption().copyWith(
                                  color: ColorConfig.primarySwatch50,
                                ),
                              ),
                              trailing: !isCreator && !isCurrentUser
                                  ? IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      color: ColorConfig.error,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Remove Member',
                                              style: FontConfig.h6(),
                                            ),
                                            content: Text(
                                              'Are you sure you want to remove ${member.userName ?? 'this member'} from the group?',
                                              style: FontConfig.body2(),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => context.pop(),
                                                child: Text(
                                                  'Cancel',
                                                  style: FontConfig.body2()
                                                      .copyWith(
                                                    color: ColorConfig
                                                        .primarySwatch50,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context.pop();
                                                  _removeUserFromGroup(
                                                      member.id!);
                                                },
                                                child: Text(
                                                  'Remove',
                                                  style: FontConfig.body2()
                                                      .copyWith(
                                                    color: ColorConfig.error,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const LoadingWidget(),
                    error: (error, _) => Center(
                      child: Text(
                        error.toString(),
                        style: FontConfig.body2().copyWith(
                          color: ColorConfig.error,
                        ),
                      ),
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
}
