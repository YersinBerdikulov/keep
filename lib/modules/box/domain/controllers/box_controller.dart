import 'dart:io';
import 'package:dongi/core/di/storage_di.dart';
import 'package:dongi/modules/box/data/di/box_di.dart';
import 'package:dongi/modules/box/domain/repository/box_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/box_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../models/user_model.dart';
import '../../../../core/data/storage/storage_service.dart';
import '../../../../app/auth/controller/auth_controller.dart';
import '../../../expense/domain/controllers/expense_controller.dart';
import '../../../group/domain/controllers/group_controller.dart';

final boxNotifierProvider = AsyncNotifierProvider<BoxNotifier, List<BoxModel>>(
  BoxNotifier.new,
);

final getBoxesProvider = FutureProvider((ref) {
  final boxesController = ref.watch(boxNotifierProvider.notifier);
  return boxesController.getBoxes();
});

final getBoxesInGroupProvider =
    FutureProvider.family.autoDispose((ref, String groupId) {
  final boxesController = ref.watch(boxNotifierProvider.notifier);
  return boxesController.getBoxesInGroup(groupId);
});

final getBoxDetailProvider =
    FutureProvider.family.autoDispose((ref, String boxId) {
  final boxesController = ref.watch(boxNotifierProvider.notifier);
  return boxesController.getBoxDetail(boxId);
});

final getUsersInBoxProvider =
    FutureProvider.family.autoDispose((ref, List<String> userIds) async {
  final boxesController = ref.watch(boxNotifierProvider.notifier);
  List<UserModel> usersInBox = await boxesController.getUsersInBox(userIds);
  ref.read(userInBoxStoreProvider.notifier).state = usersInBox;
  return usersInBox;
});

final userInBoxStoreProvider = StateProvider<List<UserModel>>((ref) {
  return [];
});

class BoxNotifier extends AsyncNotifier<List<BoxModel>> {
  late BoxRepository boxRepository;
  late StorageService storageAPI;

  bool _isInitialized = false;

  @override
  Future<List<BoxModel>> build() async {
    if (!_isInitialized) {
      // Initialize dependencies
      boxRepository = ref.watch(boxRepositoryProvider);
      storageAPI = ref.watch(storageProvider);

      _isInitialized = true;
    }

    return getBoxes();
  }

  Future<void> addBox({
    required ValueNotifier<File?> image,
    required TextEditingController boxTitle,
    required TextEditingController boxDescription,
    required GroupModel groupModel,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.watch(currentUserProvider);
      List<String> imageLinks = [];

      if (image.value != null) {
        final imageUploadRes = await storageAPI.uploadImage([image.value!]);
        imageUploadRes.fold(
          (l) => throw Exception(l.message),
          (r) => imageLinks = r,
        );
      }

      BoxModel boxModel = BoxModel(
        title: boxTitle.text,
        description: boxDescription.text,
        creatorId: currentUser!.$id,
        groupId: groupModel.id!,
        image: imageLinks.isNotEmpty ? imageLinks[0] : null,
        boxUsers: [currentUser.$id],
        total: 0,
      );

      final res = await boxRepository.addBox(boxModel);

      res.fold(
        (l) => state = AsyncValue.error(l.message, l.stackTrace),
        (r) async {
          ref.read(groupNotifierProvider.notifier).updateGroup(
            groupModel: groupModel,
            boxIds: [...groupModel.boxIds, r.$id],
          );

          final updatedBoxes = await getBoxes();
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
    num? total,
  }) async {
    state = const AsyncValue.loading();
    try {
      Map<String, dynamic> updateData = {'\$id': boxId};

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
      if (total != null) {
        updateData['total'] = total;
      }

      final res = await boxRepository.updateBox(updateData);

      res.fold(
        (l) => state = AsyncValue.error(l.message, l.stackTrace),
        (r) async {
          final updatedBoxes = await getBoxes();
          state = AsyncValue.data(updatedBoxes);
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

          final updatedBoxes = await getBoxes();
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
          final updatedBoxes = await getBoxes();
          state = AsyncValue.data(updatedBoxes);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<BoxModel>> getBoxes() async {
    final user = ref.watch(currentUserProvider);
    final boxList = await boxRepository.getBoxes(user!.$id);
    return boxList.map((box) => BoxModel.fromJson(box.data)).toList();
  }

  Future<List<BoxModel>> getBoxesInGroup(String groupId) async {
    final boxList = await boxRepository.getBoxesInGroup(groupId);
    return boxList.map((box) => BoxModel.fromJson(box.data)).toList();
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
    final boxList = await boxRepository.getBoxesInGroup(user!.$id);
    return boxList.map((box) => BoxModel.fromJson(box.data)).toList();
  }
}
