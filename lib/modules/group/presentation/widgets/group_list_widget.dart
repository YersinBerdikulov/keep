import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/router/router_names.dart';
import '../../../../modules/auth/domain/di/auth_controller_di.dart';
import '../../../../modules/group/domain/di/group_controller_di.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/image/image_widget.dart';
import '../../../../shared/widgets/long_press_menu/long_press_menu.dart';
import '../../../../shared/widgets/permission_widgets.dart';
import '../../domain/models/group_model.dart';

class GroupListView extends StatelessWidget {
  final List<GroupModel> groupModels;
  const GroupListView(this.groupModels, {super.key});

  @override
  Widget build(BuildContext context) {
    if (groupModels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 64,
              color: ColorConfig.primarySwatch.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No groups yet",
              style: FontConfig.h6().copyWith(
                color: ColorConfig.primarySwatch.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Create a group to start tracking expenses",
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch.withOpacity(0.3),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: groupModels.length,
          itemBuilder: (context, index) {
            final group = groupModels[index];
            return GroupListCard(group);
          },
        ),
      ),
    );
  }
}

class GroupListCard extends ConsumerWidget {
  final GroupModel groupModel;
  const GroupListCard(this.groupModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (groupModel.id == null) {
      return const SizedBox.shrink();
    }

    final GlobalKey key = GlobalKey();
    final currentUser = ref.watch(currentUserProvider);

    deleteGroup() async {
      await ref.read(groupNotifierProvider.notifier).deleteGroup(groupModel);
      if (context.mounted) {
        showSnackBar(context, content: "Group deleted successfully!");
      }
    }

    // Base menu items that all users can see
    List<PopupMenuEntry> menuItems = [
      PopupMenuItem(
        child: Row(
          children: [
            Icon(Icons.edit, color: ColorConfig.primarySwatch, size: 20),
            const SizedBox(width: 12),
            Text('Edit', style: FontConfig.body2()),
          ],
        ),
        onTap: () => context.push(
          RouteName.updateGroup,
          extra: groupModel,
        ),
      ),
      PopupMenuItem(
        child: Row(
          children: [
            Icon(Icons.person_add, color: ColorConfig.secondary, size: 20),
            const SizedBox(width: 12),
            Text('Add Members', style: FontConfig.body2()),
          ],
        ),
        onTap: () => context.push(
          RouteName.addGroupMember,
          extra: groupModel,
        ),
      ),
      PopupMenuItem(
        child: Row(
          children: [
            Icon(Icons.people, color: ColorConfig.secondary, size: 20),
            const SizedBox(width: 12),
            Text('Manage Members', style: FontConfig.body2()),
          ],
        ),
        onTap: () => context.push(
          RouteName.manageGroupMembers,
          extra: groupModel,
        ),
      ),
    ];

    // Add delete option only if user has permission
    if (currentUser != null && groupModel.id != null) {
      // Check if user is creator or admin to show delete option
      final canDelete = currentUser.id == groupModel.creatorId || 
                         ref.watch(isCurrentUserAdminProvider(groupModel.id!));
      
      if (canDelete) {
        menuItems.add(
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.delete, color: ColorConfig.error, size: 20),
                const SizedBox(width: 12),
                Text('Delete', style: FontConfig.body2()),
              ],
            ),
            onTap: deleteGroup,
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: LongPressMenuWidget(
        items: menuItems,
        child: Slidable(
          key: key,
          startActionPane: ActionPane(
            extentRatio: 0.5,
            motion: const BehindMotion(),
            children: [
              CustomSlidableAction(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                onPressed: (context) =>
                    showSnackBar(context, content: "Coming soon!"),
                backgroundColor: ColorConfig.secondary.withOpacity(0.9),
                foregroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(height: 4),
                    Text('Invite', style: FontConfig.caption()),
                  ],
                ),
              ),
              CustomSlidableAction(
                onPressed: (context) => context.push(
                  RouteName.updateGroup,
                  extra: groupModel,
                ),
                backgroundColor: ColorConfig.primarySwatch.withOpacity(0.9),
                foregroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(height: 4),
                    Text('Edit', style: FontConfig.caption()),
                  ],
                ),
              ),
            ],
          ),
          endActionPane: currentUser != null && groupModel.id != null &&
                  (currentUser.id == groupModel.creatorId ||
                      ref.watch(isCurrentUserAdminProvider(groupModel.id!)))
              ? ActionPane(
                  extentRatio: 0.25,
                  motion: const BehindMotion(),
                  dismissible: DismissiblePane(onDismissed: deleteGroup),
                  children: [
                    CustomSlidableAction(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      onPressed: (context) => deleteGroup(),
                      backgroundColor: ColorConfig.error.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete),
                          const SizedBox(height: 4),
                          Text('Delete', style: FontConfig.caption()),
                        ],
                      ),
                    ),
                  ],
                )
              : null, // No end action pane if user doesn't have permission
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => context.push(
                RouteName.groupDetail(groupModel.id),
              ),
              contentPadding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: CircleAvatar(
                backgroundImage: groupModel.image != null
                    ? NetworkImage(groupModel.image!)
                    : null,
                child: groupModel.image == null
                    ? Text(
                        groupModel.title.substring(0, 1).toUpperCase(),
                        style: FontConfig.body1().copyWith(
                          color: ColorConfig.white,
                        ),
                      )
                    : null,
              ),
              title: Text(
                groupModel.title,
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                groupModel.description ?? '',
                style: FontConfig.body2().copyWith(
                  color: ColorConfig.primarySwatch50,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${groupModel.groupUsers.length} members',
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.primarySwatch50,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GroupListLoading extends StatelessWidget {
  const GroupListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class GroupListError extends ConsumerWidget {
  final Object error;
  const GroupListError(this.error, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error.toString()),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(groupNotifierProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class GroupListEmpty extends StatelessWidget {
  const GroupListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No groups found'),
    );
  }
}
