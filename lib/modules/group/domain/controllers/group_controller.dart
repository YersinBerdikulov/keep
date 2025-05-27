import 'dart:async';
import 'dart:io';
import 'package:dongi/core/di/storage_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_usecase_di.dart';
import 'package:dongi/modules/box/domain/usecases/delete_all_boxes_usecase.dart';
import 'package:dongi/modules/group/data/di/group_di.dart';
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
}
