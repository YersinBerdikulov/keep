import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:collection/collection.dart';
import 'package:dongi/core/di/storage_di.dart';
import 'package:dongi/modules/auth/domain/controllers/auth_controller.dart';
import 'package:dongi/modules/expense/domain/models/expense_user_model.dart';
import 'package:dongi/modules/expense/data/di/expense_di.dart';
import 'package:dongi/modules/expense/domain/repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../box/domain/models/box_model.dart';
import '../models/expense_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../core/data/storage/storage_service.dart';
import '../../../box/domain/controllers/box_controller.dart';

final expenseNotifierProvider =
    AsyncNotifierProvider<ExpenseNotifier, List<ExpenseModel>>(
  ExpenseNotifier.new,
);

final getExpensesInBoxProvider =
    FutureProvider.family.autoDispose((ref, String boxId) {
  final expenseController = ref.watch(expenseNotifierProvider.notifier);
  return expenseController.getExpensesInBox(boxId);
});

final getExpensesDetailProvider =
    FutureProvider.family.autoDispose((ref, String expenseId) {
  final expenseController = ref.watch(expenseNotifierProvider.notifier);
  return expenseController.getExpenseDetail(expenseId);
});

final expensePayerIdProvider = StateProvider<String?>((ref) {
  final user = ref.read(currentUserProvider);
  return user?.id;
});

final splitUserProvider =
    StateNotifierProvider<SplitUserNotifier, List<String>>((ref) {
  // Retrieve all users in the box from the provider.
  final allUsers = ref.watch(userInBoxStoreProvider);
  // Initialize SplitUserNotifier with a list of user IDs.
  return SplitUserNotifier(allUsers.map((e) => e.id!).toList());
});

class ExpenseNotifier extends AsyncNotifier<List<ExpenseModel>> {
  late ExpenseRepository expenseRepository;
  late StorageService storageAPI;
  bool _isInitialized = false;

  @override
  Future<List<ExpenseModel>> build() async {
    if (!_isInitialized) {
      // Initialize dependencies
      expenseRepository = ref.watch(expenseRepositoryProvider);
      storageAPI = ref.watch(storageProvider);

      _isInitialized = true;
    }

    return [];
  }

  Future<void> addExpense({
    required TextEditingController expenseTitle,
    required TextEditingController expenseDescription,
    required TextEditingController expenseCost,
    required BoxModel boxModel,
    required GroupModel groupModel,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider);
      final payerUserId = ref.read(expensePayerIdProvider);
      final splitUsers = ref.read(splitUserProvider);
      num convertedCost = num.parse(expenseCost.text.replaceAll(',', ''));
      String expenseId = ID.custom(const Uuid().v4().substring(0, 32));
      List<String> expenseUserIds = [];

      for (var uid in splitUsers) {
        String expenseUserId = ID.custom(const Uuid().v4().substring(0, 32));
        expenseUserIds.add(expenseUserId);
        ExpenseUserModel expenseUser = ExpenseUserModel(
          userId: uid,
          groupId: groupModel.id!,
          boxId: boxModel.id!,
          expenseId: expenseId,
          cost: convertedCost / splitUsers.length,
        );
        await addExpenseUser(expenseUser, customId: expenseUserId);
      }

      // Create the main ExpenseModel
      ExpenseModel expenseModel = ExpenseModel(
        title: expenseTitle.text,
        description: expenseDescription.text,
        boxId: boxModel.id!,
        groupId: groupModel.id!,
        creatorId: currentUser!.id!,
        payerId: payerUserId ?? currentUser.id!,
        cost: convertedCost,
        expenseUsers: expenseUserIds,
      );

      final res =
          await expenseRepository.addExpense(expenseModel, customId: expenseId);
      res.fold(
        (l) => throw Exception(l.message),
        (r) {
          // Update the associated box
          ref.read(boxNotifierProvider(groupModel.id!).notifier).updateBox(
            boxId: boxModel.id!,
            total: boxModel.total + convertedCost,
            expenseIds: [...boxModel.expenseIds, r.$id],
          );
        },
      );

      // Update the state with the new data
      final updatedExpenses = await getExpensesInBox(boxModel.id!);
      state = AsyncValue.data(updatedExpenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateExpense({
    required ExpenseModel expenseModel,
    required GroupModel groupModel,
    required BoxModel boxModel,
    TextEditingController? expenseTitle,
    TextEditingController? expenseDescription,
    TextEditingController? expenseCost,
  }) async {
    state = const AsyncValue.loading();
    try {
      Map<String, dynamic> updateData = {'\$id': expenseModel.id};
      final currentUser = ref.read(currentUserProvider);
      final splitUsers = ref.read(splitUserProvider);
      final payerUserId = ref.read(expensePayerIdProvider);

      updateData['payerId'] = payerUserId ?? currentUser!.id;

      if (expenseTitle != null && expenseTitle.text.isNotEmpty) {
        updateData['title'] = expenseTitle.text;
      }

      if (expenseDescription != null && expenseDescription.text.isNotEmpty) {
        updateData['description'] = expenseDescription.text;
      }

      num newCost = expenseModel.cost;
      if (expenseCost != null && expenseCost.text.isNotEmpty) {
        newCost = num.parse(expenseCost.text.replaceAll(',', ''));
        updateData['cost'] = newCost;
      }

// Check if the split users or cost have changed
      if (!splitUsers.equals(expenseModel.expenseUsers) ||
          newCost != expenseModel.cost) {
        // Delete the existing expense users
        for (var eUid in expenseModel.expenseUsers) {
          await deleteExpenseUser(eUid);
        }

        // Create a new list of expense users
        List<String> updatedExpenseUserIds = [];
        for (var uid in splitUsers) {
          String expenseUserId = ID.custom(const Uuid().v4().substring(0, 32));
          updatedExpenseUserIds.add(expenseUserId);

          // Create a new ExpenseUserModel with the updated cost
          ExpenseUserModel expenseUser = ExpenseUserModel(
            userId: uid,
            groupId: groupModel.id!,
            boxId: boxModel.id!,
            expenseId: expenseModel.id!,
            cost: newCost / splitUsers.length, // Distribute the cost equally
          );

          // Add the new expense user
          await addExpenseUser(expenseUser, customId: expenseUserId);
        }

        // Update the data with the new expense users
        updateData['expenseUsers'] = updatedExpenseUserIds;
      }

      final res = await expenseRepository.updateExpense(updateData);

      res.fold(
        (l) => throw Exception(l.message),
        (_) {
          ref.read(boxNotifierProvider(groupModel.id!).notifier).updateBox(
                boxId: boxModel.id!,
                total: boxModel.total - expenseModel.cost + newCost,
              );
        },
      );

      // Update the state
      final updatedExpenses = await getExpensesInBox(boxModel.id!);
      state = AsyncValue.data(updatedExpenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpense({
    required ExpenseModel expenseModel,
    required BoxModel boxModel,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await expenseRepository.deleteExpense(expenseModel.id!);
      for (var eUid in expenseModel.expenseUsers) {
        await deleteExpenseUser(eUid);
      }

      res.fold(
        (l) => throw Exception(l.message),
        (_) {
          ref.read(boxNotifierProvider(boxModel.groupId).notifier).updateBox(
                boxId: boxModel.id!,
                total: boxModel.total - expenseModel.cost,
                expenseIds: boxModel.expenseIds
                    .where((id) => id != expenseModel.id)
                    .toList(),
              );
        },
      );

      // Update the state
      final updatedExpenses = await getExpensesInBox(boxModel.id!);
      state = AsyncValue.data(updatedExpenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAllExpense(List<String> ids) async {
    state = const AsyncValue.loading();
    try {
      final res = await expenseRepository.deleteAllExpense(ids);

      res.fold(
        (l) => throw Exception(l.message),
        (_) => state = const AsyncValue.data([]),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addExpenseUser(
    ExpenseUserModel expenseUser, {
    required String customId,
  }) async {
    try {
      final res = await expenseRepository.addExpenseUser(
        expenseUser,
        customId: customId,
      );

      res.fold(
        (l) => throw Exception(l.message),
        (_) => {}, // No state update; handled elsewhere
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpenseUser(String id) async {
    try {
      final res = await expenseRepository.deleteExpenseUser(id);

      res.fold(
        (l) => throw Exception(l.message),
        (_) => {}, // No state update; handled elsewhere
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<ExpenseModel>> getExpensesInBox(String boxId) async {
    try {
      final expenseList = await expenseRepository.getExpensesInBox(boxId);
      return expenseList.map((box) => ExpenseModel.fromJson(box.data)).toList();
    } catch (e, st) {
      throw AsyncValue.error(e, st);
    }
  }

  Future<ExpenseModel> getExpenseDetail(String expenseId) async {
    try {
      final expense = await expenseRepository.getExpenseDetail(expenseId);
      return ExpenseModel.fromJson(expense.data);
    } catch (e, st) {
      throw AsyncValue.error(e, st);
    }
  }
}

class SplitUserNotifier extends StateNotifier<List<String>> {
  SplitUserNotifier(super.initialState);

  /// Toggles the selection of a user by `userId`.
  void select(String userId) {
    if (state.contains(userId)) {
      // Remove the user if already selected.
      state = state.where((val) => val != userId).toList();
    } else {
      // Add the user to the list.
      state = [...state, userId];
    }
  }

  /// Toggles between selecting all users or deselecting all.
  void toggleAll(List<String> allUserIds) {
    if (state.length == allUserIds.length) {
      // Deselect all users.
      state = [];
    } else {
      // Select all users.
      state = [...allUserIds];
    }
  }

  /// Clears all selected users.
  void clear() {
    state = [];
  }

  /// Resets the state with a new set of user IDs.
  void reset(List<String> newUserIds) {
    state = [...newUserIds];
  }
}
