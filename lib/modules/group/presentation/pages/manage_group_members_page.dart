import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/core/constants/size_config.dart';
import 'package:dongi/core/widgets/app_bar.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/shared/widgets/permission_widgets.dart';
import 'package:dongi/shared/widgets/snackbar_widget.dart';
import 'package:dongi/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final isCreator = currentUserId == groupModel.creatorId;
    
    // Use hooks to manage state
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final members = useState<List<UserModel>>([]);
    final memberRoles = useState<Map<String, String>>({});
    
    // Load members when needed
    useEffect(() {
      Future<void> loadMembers() async {
        try {
          if (groupModel.groupUsers.isEmpty) {
            members.value = [];
            isLoading.value = false;
            return;
          }
          
          final result = await ref.read(groupNotifierProvider.notifier)
              .getUsersInGroup(groupModel.groupUsers);
          
          if (result.isNotEmpty) {
            members.value = result;
            
            // Load member roles for all users
            Map<String, String> roles = {};
            for (var user in result) {
              if (user.id != null) {
                try {
                  final role = await ref.read(groupNotifierProvider.notifier)
                      .getUserRole(user.id!, groupModel.id!);
                  roles[user.id!] = role;
                } catch (e) {
                  roles[user.id!] = "member";
                }
              }
            }
            memberRoles.value = roles;
          } else {
            members.value = [];
          }
        } catch (e) {
          error.value = e.toString();
        } finally {
          isLoading.value = false;
        }
      }
      
      loadMembers();
      
      return null;
    }, [groupModel.groupUsers]);

    // Update member role
    Future<void> updateMemberRole(String memberId, String newRole) async {
      try {
        await ref.read(groupNotifierProvider.notifier).updateUserRole(
          groupId: groupModel.id!,
          memberId: memberId,
          newRole: newRole,
        );
        
        // Update local state correctly
        final updatedRoles = Map<String, String>.from(memberRoles.value);
        updatedRoles[memberId] = newRole;
        memberRoles.value = updatedRoles;
        
        showSnackBar(
          context, 
          content: "Member role updated successfully!",
        );
      } catch (e) {
        showSnackBar(
          context, 
          content: "Failed to update role: ${e.toString()}",
          isError: true,
        );
      }
    }

    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            showSnackBar(context, content: "Member removed successfully!");
            // Refresh the members after removal
            isLoading.value = true;
            ref.invalidate(groupDetailProvider(groupModel.id!));
            context.pop();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              isLoading.value = true;
              ref.invalidate(groupDetailProvider(groupModel.id!));
            },
          ),
        ],
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
                  child: isLoading.value 
                    ? const LoadingWidget()
                    : error.value != null
                        ? Center(
                            child: Text(
                              error.value!,
                              style: FontConfig.body2().copyWith(
                                color: ColorConfig.error,
                              ),
                            ),
                          )
                        : members.value.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.all(15),
                                itemCount: members.value.length,
                                itemBuilder: (context, index) {
                                  final member = members.value[index];
                                  final isGroupCreator = member.id == groupModel.creatorId;
                                  final isCurrentUser = member.id == currentUserId;
                                  final memberRole = memberRoles.value[member.id] ?? "member";

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: ColorConfig.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: ColorConfig.primarySwatch.withOpacity(0.1),
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
                                          if (isGroupCreator || memberRole == "admin")
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: isGroupCreator 
                                                      ? ColorConfig.secondary 
                                                      : ColorConfig.primarySwatch,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: ColorConfig.white,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Icon(
                                                  isGroupCreator ? Icons.star : Icons.admin_panel_settings,
                                                  color: ColorConfig.white,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      title: Text(
                                        member.userName ?? 'Unknown User',
                                        style: FontConfig.body2().copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        isGroupCreator 
                                            ? 'Creator' 
                                            : memberRole == "admin" ? 'Admin' : 'Member',
                                        style: FontConfig.caption().copyWith(
                                          color: isGroupCreator 
                                              ? ColorConfig.secondary
                                              : memberRole == "admin" 
                                                  ? ColorConfig.primarySwatch
                                                  : ColorConfig.primarySwatch50,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Admin role selector - only visible to creator and not for self or group creator
                                          if (isCreator && !isGroupCreator && !isCurrentUser)
                                            Container(
                                              margin: const EdgeInsets.only(right: 8),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: ColorConfig.primarySwatch.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: ColorConfig.primarySwatch.withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  // Toggle between member and admin
                                                  final newRole = memberRole == "admin" ? "member" : "admin";
                                                  updateMemberRole(member.id!, newRole);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      memberRole == "admin" ? "Admin ✓" : "Make Admin",
                                                      style: FontConfig.caption().copyWith(
                                                        color: ColorConfig.primarySwatch,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      memberRole == "admin" 
                                                          ? Icons.check_circle 
                                                          : Icons.admin_panel_settings,
                                                      color: ColorConfig.primarySwatch,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          
                                          // Remove button - not visible for creator or self
                                          if (!isGroupCreator && !isCurrentUser)
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline),
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
                                                          style: FontConfig.body2().copyWith(
                                                            color: ColorConfig.primarySwatch50,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                          ref
                                                              .read(groupNotifierProvider.notifier)
                                                              .deleteMember(
                                                                groupModel: groupModel,
                                                                memberIdToDelete: member.id!,
                                                              );
                                                        },
                                                        child: Text(
                                                          'Remove',
                                                          style: FontConfig.body2().copyWith(
                                                            color: ColorConfig.error,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
