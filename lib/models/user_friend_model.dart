// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_friend_model.freezed.dart';
part 'user_friend_model.g.dart';

@Freezed()
class UserFriendModel with _$UserFriendModel {
  const factory UserFriendModel({
    @JsonKey(name: '\$id') String? id,
    @JsonKey(name: '\$createdAt') String? createdAt,
    @JsonKey(name: '\$updatedAt') String? updatedAt,
    required String sendRequestUserId,
    required String receiveRequestUserId,
    required String sendRequestUserName,
    required String receiveRequestUserName,
    String? sendRequestProfilePic,
    String? receiveRequestProfilePic,
    @Default(FriendRequestStatus.pending) FriendRequestStatus status,
  }) = _UserFriendModel;

  factory UserFriendModel.fromJson(Map<String, dynamic> json) =>
      _$UserFriendModelFromJson(json);
}

@JsonEnum(alwaysCreate: true)
enum FriendRequestStatus {
  @JsonValue('pending')
  pending,

  @JsonValue('accepted')
  accepted,

  @JsonValue('rejected')
  rejected,
}
