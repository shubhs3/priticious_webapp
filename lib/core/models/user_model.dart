import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { customer, admin }

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phoneNumber,
    String? displayName,
    String? email,
    @Default(UserRole.customer) UserRole role,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? fcmToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
