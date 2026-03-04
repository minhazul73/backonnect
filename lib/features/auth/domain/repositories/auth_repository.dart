import 'package:backonnect/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<UserEntity> getCurrentUser();

  Future<void> logout();
}
