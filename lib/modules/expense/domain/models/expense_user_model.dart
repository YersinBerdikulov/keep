// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_user_model.freezed.dart';
part 'expense_user_model.g.dart';

@Freezed()
class ExpenseUserModel with _$ExpenseUserModel {
  const factory ExpenseUserModel({
    @JsonKey(name: '\$id') String? id,
    @JsonKey(name: '\$createdAt') String? systemCreatedAt,
    @JsonKey(name: '\$updatedAt') String? systemUpdatedAt,
    required String userId,
    required String groupId,
    required String boxId,
    required String expenseId,
    @Default(0) double cost,
    @Default(false) bool isPaid,
    required String createdAt,
    String? updatedAt,
    String? dueDate,
    required String splitType,
    required String currency,
    required List<String> recipients,
    required String status,
    String? recurringId,
    String? notes,
    @Default(0) double shares,
    @Default(0) double sharePercentage,
    @Default(0) double shareAmount,
    @Default(false) bool isSettled,
    String? settledAt,
    String? settlementId,
  }) = _ExpenseUserModel;

  factory ExpenseUserModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseUserModelFromJson(json);
}
