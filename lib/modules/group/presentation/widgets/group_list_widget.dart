import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../domain/models/group_model.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/image/image_widget.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/long_press_menu/long_press_menu.dart';
import '../../domain/di/group_controller_di.dart';

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

    deleteGroup() async {
      await ref.read(groupNotifierProvider.notifier).deleteGroup(groupModel);
      if (context.mounted) {
        showSnackBar(context, content: "Group deleted successfully!");
      }
    }

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
    ];

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
          endActionPane: ActionPane(
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
          ),
          child: CardWidget(
            onTap: () => context.push(
              RouteName.groupDetail(groupModel.id!),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorConfig.primarySwatch25,
                      width: 2,
                    ),
                  ),
                  child: ImageWidget(
                    imageUrl: groupModel.image,
                    borderRadius: 8,
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupModel.title,
                        style: FontConfig.body1().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.group_outlined,
                            size: 16,
                            color: ColorConfig.primarySwatch50,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${groupModel.groupUsers.length} Members",
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.primarySwatch50,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 16,
                            color: ColorConfig.primarySwatch50,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${groupModel.boxIds.length} Boxes",
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.primarySwatch50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorConfig.primarySwatch50,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
