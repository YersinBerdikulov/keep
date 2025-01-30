// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserFriendModelImpl _$$UserFriendModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserFriendModelImpl(
      id: json[r'$id'] as String?,
      createdAt: json[r'$createdAt'] as String?,
      updatedAt: json[r'$updatedAt'] as String?,
      sendRequestUserId: json['sendRequestUserId'] as String,
      receiveRequestUserId: json['receiveRequestUserId'] as String,
      sendRequestUserName: json['sendRequestUserName'] as String?,
      receiveRequestUserName: json['receiveRequestUserName'] as String?,
      sendRequestProfilePic: json['sendRequestProfilePic'] as String?,
      receiveRequestProfilePic: json['receiveRequestProfilePic'] as String?,
      status:
          $enumDecodeNullable(_$FriendRequestStatusEnumMap, json['status']) ??
              FriendRequestStatus.pending,
    );

Map<String, dynamic> _$$UserFriendModelImplToJson(
        _$UserFriendModelImpl instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      r'$createdAt': instance.createdAt,
      r'$updatedAt': instance.updatedAt,
      'sendRequestUserId': instance.sendRequestUserId,
      'receiveRequestUserId': instance.receiveRequestUserId,
      'sendRequestUserName': instance.sendRequestUserName,
      'receiveRequestUserName': instance.receiveRequestUserName,
      'sendRequestProfilePic': instance.sendRequestProfilePic,
      'receiveRequestProfilePic': instance.receiveRequestProfilePic,
      'status': _$FriendRequestStatusEnumMap[instance.status]!,
    };

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.pending: 'pending',
  FriendRequestStatus.accepted: 'accepted',
  FriendRequestStatus.rejected: 'rejected',
};
