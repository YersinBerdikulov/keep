// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserModelImpl _$$AuthUserModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserModelImpl(
      id: json[r'$id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      emailVerified: json['emailVerification'] as bool,
      phoneVerified: json['phoneVerification'] as bool,
      status: json['status'] as bool,
      registration: json['registration'] as String,
      passwordUpdatedAt: json['passwordUpdate'] as String,
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tokens: (json['tokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AuthUserModelImplToJson(_$AuthUserModelImpl instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'emailVerification': instance.emailVerified,
      'phoneVerification': instance.phoneVerified,
      'status': instance.status,
      'registration': instance.registration,
      'passwordUpdate': instance.passwordUpdatedAt,
      'labels': instance.labels,
      'tokens': instance.tokens,
    };
