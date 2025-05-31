import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:collection/collection.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_usecase_di.dart';
import 'package:dongi/modules/box/domain/usecases/update_box_usecase.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:dongi/modules/expense/domain/models/expense_user_model.dart';
import 'package:dongi/modules/expense/data/di/expense_di.dart';
import 'package:dongi/modules/expense/domain/repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../box/domain/models/box_model.dart';
import '../models/expense_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../box/domain/di/box_controller_di.dart';

class ExpenseNotifier extends AsyncNotifier<List<ExpenseModel>> {
  late final ExpenseRepository _expenseRepository;
  late final UpdateBoxUseCase _updateBoxUseCase;

  @override
  Future<List<ExpenseModel>> build() async {
    _expenseRepository = ref.read(expenseRepositoryProvider);
    _updateBoxUseCase = ref.read(updateBoxUseCaseProvider);

    // Watch the current user to rebuild when user changes
    ref.watch(currentUserProvider);

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
      final categoryId = ref.read(expenseCategoryIdProvider);

      // Debug prints
      print('Starting expense creation...');
      print('Current user: ${currentUser?.id}');
      print('Payer user ID: $payerUserId');
      print('Category ID: $categoryId');

      final expenseId = ID.custom(const Uuid().v4().substring(0, 32));
      final convertedCost = num.parse(expenseCost.text.replaceAll(',', ''));
      var splitUsersList = ref.read(splitUserProvider);

      // Debug prints
      print('Initial split users list: $splitUsersList');

      if (splitUsersList.isEmpty) {
        // If no split users are selected, default to all users in the box
        final boxUsers = ref.read(userInBoxStoreProvider);
        print('No split users selected, using box users: ${boxUsers.map((u) => u.id).toList()}');
        splitUsersList = boxUsers.map((user) => user.id!).toList();
      }

      print('Final split users list: $splitUsersList');

      // Create expense user records for each split user
      List<String> expenseUserIds = [];
      List<String> userIds = [];
      
      // Calculate individual cost
      final individualCost = convertedCost / splitUsersList.length;
      final now = DateTime.now().toIso8601String();
      final sharePercentage = (100.0 / splitUsersList.length);

      for (var uid in splitUsersList) {
        String expenseUserId = ID.custom(const Uuid().v4().substring(0, 32));
        expenseUserIds.add(expenseUserId);
        userIds.add(uid);

        // Create a new ExpenseUserModel
        ExpenseUserModel expenseUser = ExpenseUserModel(
          id: expenseUserId,
          userId: uid,
          groupId: groupModel.id!,
          boxId: boxModel.id!,
          expenseId: expenseId,
          cost: individualCost,
          isPaid: uid == payerUserId,
          createdAt: now,
          updatedAt: now,
          splitType: 'equal',
          currency: 'KZT',
          recipients: splitUsersList,
          status: 'pending',
          shares: 1,
          sharePercentage: sharePercentage,
          shareAmount: individualCost,
          isSettled: false,
        );

        print('Creating expense user: ${expenseUser.toJson()}');

        // Add the expense user with explicit error handling
        final result = await _expenseRepository.addExpenseUser(expenseUser, customId: expenseUserId);
        
        result.fold(
          (failure) {
            print('Failed to create expense user: ${failure.message}');
            throw Exception('Failed to create expense user: ${failure.message}');
          },
          (success) {
            print('Successfully created expense user with ID: $expenseUserId');
          }
        );
      }

      print('Created expense user IDs: $expenseUserIds');
      print('User IDs: $userIds');

      ExpenseModel expenseModel = ExpenseModel(
        id: expenseId,
        title: expenseTitle.text,
        description:
            expenseDescription.text.isNotEmpty ? expenseDescription.text : null,
        cost: convertedCost,
        creatorId: currentUser!.id,
        payerId: payerUserId ?? currentUser.id,
        categoryId: categoryId,
        groupId: groupModel.id!,
        boxId: boxModel.id!,
        expenseUsers: userIds,  // Store user IDs
      );

      print('Creating expense model: ${expenseModel.toJson()}');

      final res = await _expenseRepository.addExpense(expenseModel,
          customId: expenseId);
      
      print('Expense creation result: $res');

      res.fold(
        (l) => throw Exception(l.message),
        (r) {
          // Update the associated box
          final updateBoxModel = boxModel.copyWith(
            total: boxModel.total + convertedCost,
            expenseIds: [...boxModel.expenseIds, r.$id],
          );

          _updateBoxUseCase.execute(updateBoxModel);
        },
      );

      // Update the state with the new data
      final updatedExpenses = await getExpensesInBox(boxModel.id!);
      state = AsyncValue.data(updatedExpenses);
    } catch (e, st) {
      print('Error adding expense: $e');
      print('Stack trace: $st');
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
            id: expenseUserId,
            userId: uid,
            groupId: groupModel.id!,
            boxId: boxModel.id!,
            expenseId: expenseModel.id!,
            cost: newCost / splitUsers.length,
            isPaid: uid == payerUserId,
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
            splitType: 'equal',
            currency: 'KZT',
            recipients: splitUsers,
            status: 'pending',
            shares: 1,
            sharePercentage: 100.0 / splitUsers.length,
            shareAmount: newCost / splitUsers.length,
            isSettled: false,
          );

          // Add the new expense user
          await addExpenseUser(expenseUser, customId: expenseUserId);
        }

        // Update the data with the new expense users
        updateData['expenseUsers'] = updatedExpenseUserIds;
      }

      final res = await _expenseRepository.updateExpense(updateData);

      res.fold(
        (l) => throw Exception(l.message),
        (_) {
          // Update the associated box
          final updateBoxModel = boxModel.copyWith(
            total: boxModel.total - expenseModel.cost + newCost,
          );

          _updateBoxUseCase.execute(updateBoxModel);
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
      print('Deleting expense: ${expenseModel.id}');
      
      // First get all expense users
      final expenseUsers = await _expenseRepository.getExpenseUsers(expenseModel.id!);
      print('Found ${expenseUsers.length} expense users to delete');

      // Delete each expense user
      for (var expenseUser in expenseUsers) {
        print('Deleting expense user: ${expenseUser.$id}');
        await deleteExpenseUser(expenseUser.$id);
      }

      // Then delete the expense itself
      final res = await _expenseRepository.deleteExpense(expenseModel.id!);

      res.fold(
        (l) => throw Exception(l.message),
        (_) {
          // Update the associated box
          final updateBoxModel = boxModel.copyWith(
            total: boxModel.total - expenseModel.cost,
            expenseIds: boxModel.expenseIds
                .where((id) => id != expenseModel.id)
                .toList(),
          );

          _updateBoxUseCase.execute(updateBoxModel);
        },
      );

      // Update the state
      final updatedExpenses = await getExpensesInBox(boxModel.id!);
      state = AsyncValue.data(updatedExpenses);
    } catch (e, st) {
      print('Error deleting expense: $e');
      print('Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAllExpense(List<String> ids) async {
    state = const AsyncValue.loading();
    try {
      print('Deleting all expenses: $ids');

      // First delete all expense users for each expense
      for (var expenseId in ids) {
        print('Deleting expense users for expense: $expenseId');
        final expenseUsers = await _expenseRepository.getExpenseUsers(expenseId);
        print('Found ${expenseUsers.length} expense users to delete');

        for (var expenseUser in expenseUsers) {
          print('Deleting expense user: ${expenseUser.$id}');
          await deleteExpenseUser(expenseUser.$id);
        }
      }

      // Then delete all expenses
      final res = await _expenseRepository.deleteAllExpense(ids);

      res.fold(
        (l) => throw Exception(l.message),
        (_) => state = const AsyncValue.data([]),
      );
    } catch (e, st) {
      print('Error deleting all expenses: $e');
      print('Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addExpenseUser(
    ExpenseUserModel expenseUser, {
    required String customId,
  }) async {
    try {
      print('Adding expense user with ID: $customId');
      print('Expense user details: ${expenseUser.toString()}');
      
      final res = await _expenseRepository.addExpenseUser(
        expenseUser,
        customId: customId,
      );

      res.fold(
        (l) {
          print('Error adding expense user: ${l.message}');
          throw Exception(l.message);
        },
        (_) {
          print('Successfully added expense user with ID: $customId');
        },
      );
    } catch (e, st) {
      print('Exception adding expense user: $e');
      print('Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpenseUser(String id) async {
    try {
      final res = await _expenseRepository.deleteExpenseUser(id);

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
      final expenseList = await _expenseRepository.getExpensesInBox(boxId);
      return expenseList.map((box) => ExpenseModel.fromJson(box.data)).toList();
    } catch (e, st) {
      throw AsyncValue.error(e, st);
    }
  }

  Future<ExpenseModel> getExpenseDetail(String expenseId) async {
    try {
      final expense = await _expenseRepository.getExpenseDetail(expenseId);
      return ExpenseModel.fromJson(expense.data);
    } catch (e, st) {
      throw AsyncValue.error(e, st);
    }
  }

  Future<void> settleUpExpenseUser(String expenseId, String userId) async {
    try {
      // Get the expense details first
      final expense = await _expenseRepository.getExpenseDetail(expenseId);
      final expenseModel = ExpenseModel.fromJson(expense.data);
      
      // Get expense users
      final expenseUsers = await _expenseRepository.getExpenseUsers(expenseId);
      
      // Update the specific expense user as settled
      final expenseUser = expenseUsers.firstWhere(
        (eu) => ExpenseUserModel.fromJson(eu.data).userId == userId,
        orElse: () {
          print('Could not find expense user for userId: $userId');
          print('Available expense users: ${expenseUsers.map((eu) => ExpenseUserModel.fromJson(eu.data).userId).toList()}');
          throw Exception('Expense user not found');
        },
      );

      final now = DateTime.now().toIso8601String();
      final updateExpenseUserData = {
        '\$id': expenseUser.$id,
        'isSettled': true,
        'settledAt': now,
      };
      await _expenseRepository.updateExpenseUser(updateExpenseUserData);

      // Check if all users have settled
      final allExpenseUsers = await _expenseRepository.getExpenseUsers(expenseId);
      final allSettled = allExpenseUsers.every(
        (eu) => ExpenseUserModel.fromJson(eu.data).isSettled == true,
      );

      // If all users have settled, mark the expense as settled
      if (allSettled) {
        final updateExpenseData = {
          '\$id': expenseId,
          'isSettled': true,
          'settledAt': now,
        };
        await _expenseRepository.updateExpense(updateExpenseData);
      }

      // Update the state with the latest expenses
      final updatedExpenses = await getExpensesInBox(expenseModel.boxId);
      state = AsyncValue.data(updatedExpenses);

      // Invalidate relevant providers using ref
      ref.invalidate(expenseDetailsProvider(expenseId));
      ref.invalidate(getExpenseUsersForExpenseProvider(expenseId));
      ref.invalidate(getExpensesInBoxProvider(expenseModel.boxId));
    } catch (e, st) {
      print('Error in settleUpExpenseUser: $e');
      print('Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> settleUpExpense(ExpenseModel expenseModel) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      // Mark the expense as settled
      final updateData = {
        '\$id': expenseModel.id,
        'isSettled': true,
        'settledAt': now,
      };

      final res = await _expenseRepository.updateExpense(updateData);

      res.fold(
        (l) => throw Exception(l.message),
        (_) async {
          // Get all expense users
          final expenseUsers = await _expenseRepository.getExpenseUsers(expenseModel.id!);
          
          // Update each expense user as settled
          for (var expenseUser in expenseUsers) {
            final updateExpenseUserData = {
              '\$id': expenseUser.$id,
              'isSettled': true,
              'settledAt': now,
            };
            await _expenseRepository.updateExpenseUser(updateExpenseUserData);
          }

          // Update the state with the latest expenses
          final updatedExpenses = await getExpensesInBox(expenseModel.boxId!);
          state = AsyncValue.data(updatedExpenses);

          // Invalidate relevant providers using ref
          ref.invalidate(expenseDetailsProvider(expenseModel.id!));
          ref.invalidate(getExpenseUsersForExpenseProvider(expenseModel.id!));
          ref.invalidate(getExpensesInBoxProvider(expenseModel.boxId!));
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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

  /// Adds a user to the selection
  void add(String userId) {
    if (!state.contains(userId)) {
      state = [...state, userId];
    }
  }

  /// Removes a user from the selection
  void remove(String userId) {
    if (state.contains(userId)) {
      state = state.where((val) => val != userId).toList();
    }
  }

  /// Toggles all users
  void toggleAll(List<String> userIds) {
    if (state.length == userIds.length) {
      state = [];
    } else {
      state = List.from(userIds);
    }
  }
}
