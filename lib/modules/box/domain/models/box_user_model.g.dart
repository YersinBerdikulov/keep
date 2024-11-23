// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoxUserModelImpl _$$BoxUserModelImplFromJson(Map<String, dynamic> json) =>
    _$BoxUserModelImpl(
      id: json[r'$id'] as String?,
      createdAt: json[r'$createdAt'] as String?,
      updatedAt: json[r'$updatedAt'] as String?,
      userId: json['userId'] as String,
      groupId: json['groupId'] as String,
      boxId: json['boxId'] as String,
      status: json['status'] as String? ?? "accept",
    );

Map<String, dynamic> _$$BoxUserModelImplToJson(_$BoxUserModelImpl instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      r'$createdAt': instance.createdAt,
      r'$updatedAt': instance.updatedAt,
      'userId': instance.userId,
      'groupId': instance.groupId,
      'boxId': instance.boxId,
      'status': instance.status,
    };
