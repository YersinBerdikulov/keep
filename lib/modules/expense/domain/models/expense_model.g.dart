// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json[r'$id'] as String?,
      createdAt: json[r'$createdAt'] as String?,
      updatedAt: json[r'$updatedAt'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      boxId: json['boxId'] as String,
      groupId: json['groupId'] as String,
      creatorId: json['creatorId'] as String,
      payerId: json['payerId'] as String,
      cost: json['cost'] as num? ?? 0,
      equal: json['equal'] as bool? ?? true,
      expenseUsers: (json['expenseUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isSettled: json['isSettled'] as bool? ?? false,
      settledAt: json['settledAt'] as String?,
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      r'$createdAt': instance.createdAt,
      r'$updatedAt': instance.updatedAt,
      'title': instance.title,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'boxId': instance.boxId,
      'groupId': instance.groupId,
      'creatorId': instance.creatorId,
      'payerId': instance.payerId,
      'cost': instance.cost,
      'equal': instance.equal,
      'expenseUsers': instance.expenseUsers,
      'isSettled': instance.isSettled,
      'settledAt': instance.settledAt,
    };
