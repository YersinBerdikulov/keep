import 'dart:async';
import 'dart:io';
import 'package:appwrite/models.dart' show Document;
import 'package:dongi/core/di/storage_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_usecase_di.dart';
import 'package:dongi/modules/box/domain/usecases/delete_all_boxes_usecase.dart';
import 'package:dongi/modules/group/data/di/group_di.dart';
import 'package:dongi/modules/group/domain/models/group_user_model.dart';
import 'package:dongi/modules/group/domain/repository/group_repository.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/group_model.dart';
import '../../../user/domain/models/user_model.dart';
import '../../../../core/data/storage/storage_service.dart';

class GroupNotifier extends AsyncNotifier<List<GroupModel>> {
  late final GroupRepository _groupRepository;
  late final StorageService _storageService;
  late final DeleteAllBoxesUseCase _deleteAllBoxesUseCase;
  bool _isInitialized = false;

  @override
  Future<List<GroupModel>> build() async {
    if (!_isInitialized) {
      _groupRepository = ref.read(groupRepositoryProvider);
      _storageService = ref.read(storageProvider);
      _deleteAllBoxesUseCase = ref.read(deleteAllBoxesUseCaseProvider);
      _isInitialized = true;
    }
    return _fetchGroups();
  }

  Future<List<GroupModel>> _fetchGroups() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return [];

    final groupList = await _groupRepository.getGroups(user.id!);
    return groupList.map((group) => GroupModel.fromJson(group.data)).toList();
  }

  Future<void> addGroup({
    required ValueNotifier<File?> image,
    required TextEditingController groupTitle,
    required TextEditingController groupDescription,
    required ValueNotifier<Set<String>> selectedFriends,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      if (currentUser.id == null) throw Exception('User ID not found');

      List<String> imageLinks = [];

      if (image.value != null) {
        final imageUploadRes =
            await _storageService.uploadImage([image.value!]);
        imageUploadRes.fold(
          (l) => throw Exception(l.message),
          (r) => imageLinks = r,
        );
      }

      final groupModel = GroupModel(
        title: groupTitle.text,
        description: groupDescription.text,
        creatorId: currentUser!.id!,
        image: imageLinks.isNotEmpty ? imageLinks[0] : null,
        groupUsers: [currentUser.id!, ...selectedFriends.value],
        boxIds: [],
        totalBalance: 0,
      );

      final result = await _groupRepository.addGroup(groupModel);
      state = await result.fold(
        (l) => AsyncValue.error(l.message, StackTrace.current),
        (document) async {
          final createdGroup = GroupModel.fromJson(document.data);
          
          // Create group user records - creator as admin, others as members
          await _groupRepository.addGroupUser(GroupUserModel(
            userId: currentUser.id!,
            groupId: createdGroup.id!,
            status: "accepted",
            role: "admin",
          ));

          // Add other members as regular members
          for (final friendId in selectedFriends.value) {
            await _groupRepository.addGroupUser(GroupUserModel(
              userId: friendId,
              groupId: createdGroup.id!,
              status: "pending",
              role: "member",
            ));
          }
          
          final currentGroups = state.value ?? [];
          // Invalidate homeNotifierProvider to refresh homepage
          ref.invalidate(homeNotifierProvider);
          return AsyncValue.data([...currentGroups, createdGroup]);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateGroup({
    required GroupModel groupModel,
    ValueNotifier<File?>? image,
    TextEditingController? groupTitle,
    TextEditingController? groupDescription,
    List<String>? boxIds,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      // Check if user is creator or admin
      final isCreator = groupModel.creatorId == currentUser.id;
      final isAdmin = await _isUserAdmin(currentUser.id!, groupModel.id!);
      
      if (!isCreator && !isAdmin) {
        throw Exception('Only the group creator or admin can update the group');
      }
      
      // Start with the complete existing group data
      Map<String, dynamic> updateData = groupModel.toJson();

      if (image != null && image.value != null) {
        final imageUploadRes =
            await _storageService.uploadImage([image.value!]);
        imageUploadRes.fold(
          (l) => throw Exception(l.message),
          (r) => updateData["image"] = r.first,
        );
      }

      if (groupTitle != null && groupTitle.text.isNotEmpty) {
        updateData['title'] = groupTitle.text;
      }
      if (groupDescription != null && groupDescription.text.isNotEmpty) {
        updateData['description'] = groupDescription.text;
      }
      if (boxIds != null) {
        updateData['boxIds'] = boxIds;
      }

      final updateGroup = GroupModel.fromJson(updateData);
      await _groupRepository.updateGroup(updateGroup);

      // Fetch the latest group data to ensure we have the most up-to-date state
      final updatedGroup = await getGroupDetail(groupModel.id!);

      // Update the state by replacing the old group with the updated one
      final currentGroups = state.value ?? [];
      final updatedGroups = currentGroups.map((group) {
        if (group.id == groupModel.id) {
          return updatedGroup;
        }
        return group;
      }).toList();

      // Invalidate homeNotifierProvider to refresh homepage
      ref.invalidate(homeNotifierProvider);
      state = AsyncValue.data(updatedGroups);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteGroup(GroupModel groupModel) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      // Check if user is creator or admin
      final isCreator = groupModel.creatorId == currentUser.id;
      final isAdmin = await _isUserAdmin(currentUser.id!, groupModel.id!);
      
      if (!isCreator && !isAdmin) {
        throw Exception('Only the group creator or admin can delete the group');
      }
      
      // Delete all group users first
      final groupUsers = await _groupRepository.getGroupUsers(groupModel.id!);
      for (final user in groupUsers) {
        await _groupRepository.deleteGroupUser(user.$id);
      }
      
      await _groupRepository.deleteGroup(groupModel.id!);

      if (groupModel.image != null && groupModel.image!.isNotEmpty) {
        await _storageService.deleteImage(groupModel.image!);
      }

      await _deleteAllBoxesUseCase.execute(groupModel.boxIds);

      // Invalidate homeNotifierProvider to refresh homepage
      ref.invalidate(homeNotifierProvider);
      state = AsyncValue.data(
        (state.value ?? [])
            .where((group) => group.id != groupModel.id)
            .toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<UserModel>> getUsersInGroup(List<String> userIds) async {
    try {
      final users = await _groupRepository.getUsersInGroup(userIds);
      return users.map((user) => UserModel.fromJson(user.data)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupModel> getGroupDetail(String groupId) async {
    try {
      final user = ref.read(currentUserProvider);
      final group = await _groupRepository.getGroupDetail(user!.id!, groupId);
      return GroupModel.fromJson(group.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMembers({
    required GroupModel groupModel,
    required List<String> newMemberIds,
  }) async {
    state = const AsyncLoading();
    try {
      final updatedGroupModel = groupModel.copyWith(
        groupUsers: [...groupModel.groupUsers, ...newMemberIds],
      );

      final result = await _groupRepository.updateGroup(updatedGroupModel);
      state = await result.fold(
        (l) => AsyncValue.error(l.message, StackTrace.current),
        (document) async {
          final updatedGroup = GroupModel.fromJson(document.data);
          
          // Create group user records for new members
          for (final memberId in newMemberIds) {
            await _groupRepository.addGroupUser(GroupUserModel(
              userId: memberId,
              groupId: updatedGroup.id!,
              status: "pending",
              role: "member",
            ));
          }
          
          final currentGroups = state.value ?? [];
          final updatedGroups = currentGroups.map((group) {
            if (group.id == updatedGroup.id) {
              return updatedGroup;
            }
            return group;
          }).toList();
          // Invalidate homeNotifierProvider to refresh homepage
          ref.invalidate(homeNotifierProvider);
          return AsyncValue.data(updatedGroups);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMember({
    required GroupModel groupModel,
    required String memberIdToDelete,
  }) async {
    state = const AsyncLoading();
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      // Check if user is creator, admin, or deleting themselves
      final isCreator = groupModel.creatorId == currentUser.id;
      final isAdmin = await _isUserAdmin(currentUser.id!, groupModel.id!);
      final isDeletingSelf = currentUser.id == memberIdToDelete;
      
      // Check if member to delete is the creator
      if (memberIdToDelete == groupModel.creatorId && !isDeletingSelf) {
        throw Exception('Cannot remove the group creator');
      }
      
      // Only allow if user is creator, admin, or deleting themselves
      if (!isCreator && !isAdmin && !isDeletingSelf) {
        throw Exception('Only the group creator, admin, or the user themselves can remove a member');
      }
      
      // Find and delete the group user record
      final groupUsers = await _groupRepository.getGroupUsers(groupModel.id!);
      for (final user in groupUsers) {
        final userData = GroupUserModel.fromJson(user.data);
        if (userData.userId == memberIdToDelete) {
          await _groupRepository.deleteGroupUser(user.$id);
          break;
        }
      }

      // Remove the member from the group
      final updatedGroupModel = groupModel.copyWith(
        groupUsers: groupModel.groupUsers.where((id) => id != memberIdToDelete).toList(),
      );

      final result = await _groupRepository.updateGroup(updatedGroupModel);
      state = await result.fold(
        (l) => AsyncValue.error(l.message, StackTrace.current),
        (document) async {
          final updatedGroup = GroupModel.fromJson(document.data);
          final currentGroups = state.value ?? [];
          final updatedGroups = currentGroups.map((group) {
            if (group.id == updatedGroup.id) {
              return updatedGroup;
            }
            return group;
          }).toList();
          // Invalidate homeNotifierProvider to refresh homepage
          ref.invalidate(homeNotifierProvider);
          return AsyncValue.data(updatedGroups);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> promoteToAdmin({
    required GroupModel groupModel,
    required String memberIdToPromote,
  }) async {
    state = const AsyncLoading();
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      // Check if current user is creator or admin
      final isCreator = groupModel.creatorId == currentUser.id;
      final isAdmin = await _isUserAdmin(currentUser.id!, groupModel.id!);
      
      if (!isCreator && !isAdmin) {
        throw Exception('Only the group creator or admin can promote members');
      }
      
      // Find and update the group user record
      final groupUsers = await _groupRepository.getGroupUsers(groupModel.id!);
      for (final user in groupUsers) {
        final userData = GroupUserModel.fromJson(user.data);
        if (userData.userId == memberIdToPromote) {
          final updatedUser = userData.copyWith(role: "admin");
          await _groupRepository.updateGroupUser(updatedUser);
          break;
        }
      }
      
      // No need to update the group model itself
      // Refresh the state to reflect changes
      final updatedGroups = await _fetchGroups();
      state = AsyncValue.data(updatedGroups);
      
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> demoteToMember({
    required GroupModel groupModel,
    required String memberIdToDemote,
  }) async {
    state = const AsyncLoading();
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      // Check if current user is creator
      final isCreator = groupModel.creatorId == currentUser.id;
      
      // Only allow creator to demote admins
      if (!isCreator) {
        throw Exception('Only the group creator can demote admins');
      }
      
      // Check if trying to demote creator (which is not allowed)
      if (memberIdToDemote == groupModel.creatorId) {
        throw Exception('Cannot demote the group creator');
      }
      
      // Find and update the group user record
      final groupUsers = await _groupRepository.getGroupUsers(groupModel.id!);
      for (final user in groupUsers) {
        final userData = GroupUserModel.fromJson(user.data);
        if (userData.userId == memberIdToDemote) {
          final updatedUser = userData.copyWith(role: "member");
          await _groupRepository.updateGroupUser(updatedUser);
          break;
        }
      }
      
      // No need to update the group model itself
      // Refresh the state to reflect changes
      final updatedGroups = await _fetchGroups();
      state = AsyncValue.data(updatedGroups);
      
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<bool> _isUserAdmin(String userId, String groupId) async {
    try {
      final groupUsers = await _groupRepository.getGroupUsers(groupId);
      for (final user in groupUsers) {
        final userData = GroupUserModel.fromJson(user.data);
        if (userData.userId == userId && userData.role == "admin") {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<String> getUserRole(String userId, String groupId) async {
    try {
      // Get all group users
      final groupUsers = await _groupRepository.getGroupUsers(groupId);
      
      // Find the user record for this specific group using manual search
      for (final doc in groupUsers) {
        if (doc.data['userId'] == userId && doc.data['groupId'] == groupId) {
          return doc.data['role'] as String;
        }
      }
      
      throw Exception('User is not a member of this group');
    } catch (e) {
      // Default to "member" if not found or error
      return "member";
    }
  }
  
  Future<bool> canUserDeleteItem(String userId, String groupId, String creatorId) async {
    try {
      // Creator can always delete their own items
      if (userId == creatorId) return true;
      
      // Admin can delete any item
      final role = await getUserRole(userId, groupId);
      return role == "admin";
    } catch (e) {
      return false;
    }
  }

  // Method to update a user's role in a group
  Future<void> updateUserRole({
    required String groupId, 
    required String memberId, 
    required String newRole,
  }) async {
    state = const AsyncLoading();
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      // Get all group users for this group
      final groupUsers = await _groupRepository.getGroupUsers(groupId);
      print('DEBUG: Found ${groupUsers.length} group user records for group $groupId');
      
      // Get the group details to check if current user is creator or admin
      final group = await getGroupDetail(groupId);
      print('DEBUG: Group details - creatorId: ${group.creatorId}, current user: ${currentUser.id}');
      print('DEBUG: Group members: ${group.groupUsers}');
      
      // Only creator can change roles (optionally allow admins too)
      final isCreator = group.creatorId == currentUser.id;
      if (!isCreator) {
        throw Exception('Only the group creator can change user roles');
      }
      
      // Verify the member is in the group
      if (!group.groupUsers.contains(memberId)) {
        throw Exception('User is not a member of this group');
      }
      
      // Find the specific user record - fix the filtering logic
      Document? userRecordToUpdate;
      print('DEBUG: Looking for user record with userId=$memberId and groupId=$groupId');
      
      for (final doc in groupUsers) {
        print('DEBUG: Checking record - userId: ${doc.data['userId']}, groupId: ${doc.data['groupId']}');
        if (doc.data['userId'] == memberId && doc.data['groupId'] == groupId) {
          userRecordToUpdate = doc;
          break;
        }
      }
      
      // If user doesn't have a group_user record yet, create one
      if (userRecordToUpdate == null) {
        print('DEBUG: No matching user record found, creating a new one');
        
        // Create a new group user record
        final newGroupUserModel = GroupUserModel(
          userId: memberId,
          groupId: groupId,
          status: "accepted", // Assume they're already accepted since they're in the group
          role: newRole,
        );
        
        // Add some debug output to see what fields are being sent
        print('DEBUG: Creating group user with fields: ${newGroupUserModel.toJson()}');
        
        final result = await _groupRepository.addGroupUser(newGroupUserModel);
        result.fold(
          (l) => throw Exception('Failed to create user record: ${l.message}'),
          (r) => print('DEBUG: Successfully created new group user record'),
        );
      } else {
        // Update the role
        print('DEBUG: Found user record, updating role to $newRole');
        final groupUserModel = GroupUserModel.fromJson(userRecordToUpdate.data).copyWith(
          id: userRecordToUpdate.$id,
          role: newRole,
        );
        
        await _groupRepository.updateGroupUser(groupUserModel);
      }
      
      // Refresh state (no need to modify group list as the role change doesn't affect it)
      ref.invalidate(homeNotifierProvider);
      
      // Force refresh the current state
      state = AsyncValue.data(await _fetchGroups());
    } catch (e, st) {
      print('DEBUG: Error in updateUserRole: $e');
      state = AsyncValue.error(e, st);
    }
  }
}
