// ignore_for_file: invalid_annotation_target
import 'package:appwrite/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
class AuthUserModel with _$AuthUserModel {
  const factory AuthUserModel({
    @JsonKey(name: '\$id') required String id,
    required String name,
    required String email,
    required String phone,
    @JsonKey(name: 'emailVerification') required bool emailVerified,
    @JsonKey(name: 'phoneVerification') required bool phoneVerified,
    required bool status,
    required String registration,
    @JsonKey(name: 'passwordUpdate') required String passwordUpdatedAt,
    @Default([]) List<String> labels,
    @Default([]) List<String> tokens,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}

extension AuthUserConversion on User {
  AuthUserModel toAuthUserModel() {
    return AuthUserModel(
      id: $id,
      name: name,
      email: email,
      phone: phone,
      emailVerified: emailVerification,
      phoneVerified: phoneVerification,
      status: status,
      registration: registration,
      passwordUpdatedAt: passwordUpdate,
      labels: List<String>.from(labels),
      tokens: [], // Tokens can be managed separately if needed
    );
  }
}
