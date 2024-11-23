import 'dart:async';
import 'dart:io';
import 'package:dongi/core/di/storage_di.dart';
import 'package:dongi/modules/group/data/di/group_di.dart';
import 'package:dongi/modules/group/domain/repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/group_model.dart';
import '../../../../models/user_model.dart';
import '../../../../core/data/storage/storage_service.dart';
import '../../../../app/auth/controller/auth_controller.dart';
import '../../../../app/box/controller/box_controller.dart';

final groupNotifierProvider =
    AsyncNotifierProvider<GroupNotifier, List<GroupModel>>(
  GroupNotifier.new,
);

// Provider for getting group details
final getGroupDetailProvider =
    FutureProvider.family<GroupModel, String>((ref, groupId) async {
  final groupNotifier = ref.read(groupNotifierProvider.notifier);
  return groupNotifier.getGroupDetail(groupId);
});

// Provider for getting users in a group
final getUsersInGroupProvider =
    FutureProvider.family<List<UserModel>, List<String>>((ref, userIds) async {
  final groupNotifier = ref.read(groupNotifierProvider.notifier);
  return groupNotifier.getUsersInGroup(userIds);
});

final getGroupsProvider = FutureProvider((ref) {
  final groupsController = ref.read(groupNotifierProvider.notifier);
  return groupsController.build();
});

class GroupNotifier extends AsyncNotifier<List<GroupModel>> {
  late GroupRepository groupRepository;
  late StorageService storageAPI;

  bool _isInitialized = false;

  @override
  Future<List<GroupModel>> build() async {
    if (!_isInitialized) {
      // Initialize dependencies
      groupRepository = ref.watch(groupRepositoryProvider);
      storageAPI = ref.watch(storageProvider);

      _isInitialized = true;
    }

    return _fetchGroups();
  }

  Future<List<GroupModel>> _fetchGroups() async {
    final user = ref.read(currentUserProvider);
    final groupList = await groupRepository.getGroups(user!.$id);
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
      List<String> imageLinks = [];

      if (image.value != null) {
        final imageUploadRes = await storageAPI.uploadImage([image.value!]);
        imageUploadRes.fold(
          (l) => throw Exception(l.message),
          (r) => imageLinks = r,
        );
      }

      final groupModel = GroupModel(
        title: groupTitle.text,
        description: groupDescription.text,
        creatorId: currentUser!.$id,
        image: imageLinks.isNotEmpty ? imageLinks[0] : null,
        groupUsers: [currentUser.$id, ...selectedFriends.value],
        boxIds: [],
        totalBalance: 0,
      );

      await groupRepository.addGroup(groupModel);
      state = AsyncValue.data([...state.value ?? [], groupModel]);
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
      final Map<String, dynamic> updateData = {'\$id': groupModel.id!};

      if (image != null && image.value != null) {
        final imageUploadRes = await storageAPI.uploadImage([image.value!]);
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

      await groupRepository.updateGroup(updateData);
      state = AsyncValue.data(await _fetchGroups());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteGroup(GroupModel groupModel) async {
    state = const AsyncValue.loading();
    try {
      await groupRepository.deleteGroup(groupModel.id!);

      if (groupModel.image != null && groupModel.image!.isNotEmpty) {
        await storageAPI.deleteImage(groupModel.image!);
      }

      ref.read(boxNotifierProvider.notifier).deleteAllBox(groupModel.boxIds);
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
      final users = await groupRepository.getUsersInGroup(userIds);
      return users.map((user) => UserModel.fromJson(user.data)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupModel> getGroupDetail(String groupId) async {
    try {
      final user = ref.read(currentUserProvider);
      final group = await groupRepository.getGroupDetail(user!.$id, groupId);
      return GroupModel.fromJson(group.data);
    } catch (e) {
      rethrow;
    }
  }
}
