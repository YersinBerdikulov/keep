// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseUserModelImpl _$$ExpenseUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseUserModelImpl(
      id: json[r'$id'] as String?,
      systemCreatedAt: json[r'$createdAt'] as String?,
      systemUpdatedAt: json[r'$updatedAt'] as String?,
      userId: json['userId'] as String,
      groupId: json['groupId'] as String,
      boxId: json['boxId'] as String,
      expenseId: json['expenseId'] as String,
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
      isPaid: json['isPaid'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      dueDate: json['dueDate'] as String?,
      splitType: json['splitType'] as String,
      currency: json['currency'] as String,
      recipients: (json['recipients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      recurringId: json['recurringId'] as String?,
      notes: json['notes'] as String?,
      shares: (json['shares'] as num?)?.toDouble() ?? 0,
      sharePercentage: (json['sharePercentage'] as num?)?.toDouble() ?? 0,
      shareAmount: (json['shareAmount'] as num?)?.toDouble() ?? 0,
      isSettled: json['isSettled'] as bool? ?? false,
      settledAt: json['settledAt'] as String?,
      settlementId: json['settlementId'] as String?,
    );

Map<String, dynamic> _$$ExpenseUserModelImplToJson(
        _$ExpenseUserModelImpl instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      r'$createdAt': instance.systemCreatedAt,
      r'$updatedAt': instance.systemUpdatedAt,
      'userId': instance.userId,
      'groupId': instance.groupId,
      'boxId': instance.boxId,
      'expenseId': instance.expenseId,
      'cost': instance.cost,
      'isPaid': instance.isPaid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'dueDate': instance.dueDate,
      'splitType': instance.splitType,
      'currency': instance.currency,
      'recipients': instance.recipients,
      'status': instance.status,
      'recurringId': instance.recurringId,
      'notes': instance.notes,
      'shares': instance.shares,
      'sharePercentage': instance.sharePercentage,
      'shareAmount': instance.shareAmount,
      'isSettled': instance.isSettled,
      'settledAt': instance.settledAt,
      'settlementId': instance.settlementId,
    };
