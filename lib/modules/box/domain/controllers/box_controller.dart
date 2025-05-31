import 'dart:io';
import 'package:dongi/core/di/storage_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/box/data/di/box_di.dart';
import 'package:dongi/modules/box/domain/repository/box_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/box_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../user/domain/models/user_model.dart';
import '../../../../core/data/storage/storage_service.dart';
import '../../../expense/domain/di/expense_controller_di.dart';
import '../../../group/domain/di/group_controller_di.dart';

class BoxNotifier extends FamilyAsyncNotifier<List<BoxModel>, String> {
  late final BoxRepository boxRepository;
  late final StorageService storageAPI;
  bool _isInitialized = false;

  @override
  Future<List<BoxModel>> build(String arg) async {
    if (!_isInitialized) {
      boxRepository = ref.read(boxRepositoryProvider);
      storageAPI = ref.read(storageProvider);
      _isInitialized = true;
    }

    // Watch the current user to rebuild when user changes
    ref.watch(currentUserProvider);

    try {
      return await getBoxesInGroup(arg);
    } catch (e) {
      print('Error in build: $e');
      return [];
    }
  }

  Future<void> addBox({
    required ValueNotifier<File?> image,
    required TextEditingController boxTitle,
    required TextEditingController boxDescription,
    required GroupModel groupModel,
    required String currency,
    required List<String> selectedMembers,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentUserValue = ref.read(currentUserProvider);
      if (currentUserValue == null) throw Exception('User not logged in');

      final currentUser = currentUserValue;
      if (currentUser.id == null) throw Exception('User ID not found');

      List<String> imageLinks = [];

      if (image.value != null) {
        final imageUploadRes = await storageAPI.uploadImage([image.value!]);
        imageUploadRes.fold(
          (l) => throw Exception(l.message),
          (r) => imageLinks = r,
        );
      }

      // Make sure creator is included in members and convert to List<String>
      final Set<String> memberSet = {...selectedMembers};
      if (currentUser.id != null) {
        memberSet.add(currentUser.id);
      }
      final List<String> boxUsers = memberSet.toList();

      BoxModel boxModel = BoxModel(
        title: boxTitle.text,
        description:
            boxDescription.text.isNotEmpty ? boxDescription.text : null,
        creatorId: currentUser.id,
        groupId: groupModel.id!,
        image: imageLinks.isNotEmpty ? imageLinks[0] : null,
        boxUsers: boxUsers,
        total: 0,
        currency: currency,
      );

      final res = await boxRepository.addBox(boxModel);

      res.fold(
        (l) => state = AsyncValue.error(l.message, l.stackTrace),
        (r) async {
          await ref.read(groupNotifierProvider.notifier).updateGroup(
            groupModel: groupModel,
            boxIds: [...groupModel.boxIds, r.$id],
          );

          final updatedBoxes = await getBoxesInGroup(arg);
          state = AsyncValue.data(updatedBoxes);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBox({
    required String boxId,
    ValueNotifier<File?>? image,
    TextEditingController? boxTitle,
    TextEditingController? boxDescription,
    List<String>? expenseIds,
    List<String>? boxUsers,
    num? total,
  }) async {
    state = const AsyncValue.loading();
    try {
      // First get the current box data
      final currentBox = await boxRepository.getBoxDetail(boxId);
      final currentBoxModel = BoxModel.fromJson(currentBox.data);
      
      // Check if current user has permission to update
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      final isCreator = currentBoxModel.creatorId == currentUser.id;
      final canEdit = await ref.read(groupNotifierProvider.notifier)
          .canUserDeleteItem(currentUser.id!, currentBoxModel.groupId, currentBoxModel.creatorId);
      
      if (!isCreator && !canEdit) {
        throw Exception('Only the box creator or group admin can update this box');
      }

      // Prepare update data with all existing fields
      Map<String, dynamic> updateData = currentBoxModel.toJson();
      updateData['\$id'] = boxId; // Make sure to keep the ID

      if (image != null && image.value != null) {
        final imageUploadRes = await storageAPI.uploadImage([image.value!]);
        imageUploadRes.fold(
          (l) => throw Exception(l.message),
          (r) => updateData['image'] = r.first,
        );
      }

      if (boxTitle != null && boxTitle.text.isNotEmpty) {
        updateData['title'] = boxTitle.text;
      }
      if (boxDescription != null && boxDescription.text.isNotEmpty) {
        updateData['description'] = boxDescription.text;
      }
      if (expenseIds != null) {
        updateData['expenseIds'] = expenseIds;
      }
      if (boxUsers != null) {
        updateData['boxUsers'] = boxUsers;
      }
      if (total != null) {
        updateData['total'] = total;
      }

      final updateBoxModel = BoxModel.fromJson(updateData);
      final res = await boxRepository.updateBox(updateBoxModel);

      res.fold(
        (l) => state = AsyncValue.error(l.message, l.stackTrace),
        (r) async {
          // Fetch the updated box details
          final updatedBox = await boxRepository.getBoxDetail(boxId);
          if (updatedBox != null) {
            // Update the box in the state
            final currentBoxes = state.value ?? [];
            final updatedBoxes = currentBoxes.map((box) {
              if (box.id == boxId) {
                return BoxModel.fromJson(updatedBox.data);
              }
              return box;
            }).toList();
            state = AsyncValue.data(updatedBoxes);
          }
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteBox({
    required BoxModel boxModel,
    required GroupModel groupModel,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Check if current user has permission to delete
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not logged in');
      
      final canDelete = await ref.read(groupNotifierProvider.notifier)
          .canUserDeleteItem(currentUser.id!, boxModel.groupId, boxModel.creatorId);
      
      if (!canDelete) {
        throw Exception('Only the box creator or group admin can delete this box');
      }
      
      // Remove the box from the server
      final res = await boxRepository.deleteBox(boxModel.id!);

      // If the box has an associated image, remove it from storage
      if (boxModel.image != null && boxModel.image!.isNotEmpty) {
        await storageAPI.deleteImage(boxModel.image!);
      }

      res.fold(
        (l) => state = AsyncValue.error(l.message, l.stackTrace),
        (r) async {
          // Update the group to exclude the deleted box
          ref.read(groupNotifierProvider.notifier).updateGroup(
                groupModel: groupModel,
                boxIds:
                    groupModel.boxIds.where((id) => id != boxModel.id).toList(),
              );

          // Remove all associated expenses in the box
          ref
              .read(expenseNotifierProvider.notifier)
              .deleteAllExpense(boxModel.expenseIds);

          final updatedBoxes = await getBoxesInGroup(arg);
          state = AsyncValue.data(updatedBoxes);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAllBox(List<String> boxIds) async {
    state = const AsyncValue.loading();
    try {
      // Current user should be checked at the group level
      // Remove all boxes from the server
      final res = await boxRepository.deleteAllBox(boxIds);

      res.fold(
        (l) => state = AsyncValue.error(l.message, l.stackTrace),
        (r) async {
          // Iterate through each box ID and delete associated expenses
          for (final boxId in boxIds) {
            final boxDetail = await getBoxDetail(boxId);
            ref
                .read(expenseNotifierProvider.notifier)
                .deleteAllExpense(boxDetail.expenseIds);

            // If the box has an associated image, remove it from storage
            if (boxDetail.image != null && boxDetail.image!.isNotEmpty) {
              final imageDeleteRes =
                  await storageAPI.deleteImage(boxDetail.image!);
              imageDeleteRes.fold(
                (l) => throw Exception(l.message),
                (r) => null,
              );
            }
          }

          // Fetch the updated list of boxes
          final updatedBoxes = await getBoxesInGroup(arg);
          state = AsyncValue.data(updatedBoxes);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Future<List<BoxModel>> getBoxes() async {
  //   final user = ref.watch(currentUserProvider);
  //   final boxList = await boxRepository.getBoxes(user!.id!);
  //   return boxList.map((box) => BoxModel.fromJson(box.data)).toList();
  // }

  Future<List<BoxModel>> getBoxesInGroup(String groupId) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null || user.id == null) return [];

      final boxes = await boxRepository.getBoxesInGroup(groupId);
      return boxes.map((box) => BoxModel.fromJson(box.data)).toList();
    } catch (e) {
      print('Error in getBoxesInGroup: $e');
      return [];
    }
  }

  Future<BoxModel> getBoxDetail(String boxId) async {
    final box = await boxRepository.getBoxDetail(boxId);
    return BoxModel.fromJson(box.data);
  }

  Future<List<UserModel>> getUsersInBox(List<String> userIds) async {
    final users = await boxRepository.getUsersInBox(userIds);
    return users.map((user) => UserModel.fromJson(user.data)).toList();
  }

  Future<List<BoxModel>> getCurrentUserBoxes() async {
    final user = ref.watch(currentUserProvider);
    final boxList = await boxRepository.getBoxesInGroup(user!.id!);
    return boxList.map((box) => BoxModel.fromJson(box.data)).toList();
  }
}

class BoxDetailArgs {
  final String boxId;
  final String groupId;

  BoxDetailArgs({required this.boxId, required this.groupId});
}

class UsersInBoxArgs {
  final List<String> userIds;
  final String groupId;

  UsersInBoxArgs({required this.userIds, required this.groupId});
}
