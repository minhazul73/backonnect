import 'package:backonnect/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.email,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  UserEntity toEntity() {
    return UserEntity(id: id, email: email, isActive: isActive);
  }
}
