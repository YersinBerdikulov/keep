// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoxModelImpl _$$BoxModelImplFromJson(Map<String, dynamic> json) =>
    _$BoxModelImpl(
      id: json[r'$id'] as String?,
      createdAt: json[r'$createdAt'] as String?,
      updatedAt: json[r'$updatedAt'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      groupId: json['groupId'] as String,
      boxUsers: (json['boxUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      expenseIds: (json['expenseIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      total: json['total'] as num? ?? 0,
      currency: json['currency'] as String? ?? "KZT",
      creatorId: json['creatorId'] as String,
    );

Map<String, dynamic> _$$BoxModelImplToJson(_$BoxModelImpl instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      r'$createdAt': instance.createdAt,
      r'$updatedAt': instance.updatedAt,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'groupId': instance.groupId,
      'boxUsers': instance.boxUsers,
      'expenseIds': instance.expenseIds,
      'total': instance.total,
      'currency': instance.currency,
      'creatorId': instance.creatorId,
    };
