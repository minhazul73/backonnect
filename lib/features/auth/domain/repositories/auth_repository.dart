import 'package:backonnect/features/auth/domain/entities/token_entity.dart';
import 'package:backonnect/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<TokenEntity> login({
    required String email,
    required String password,
  });

  Future<TokenEntity> register({
    required String email,
    required String password,
  });

  Future<TokenEntity> refreshToken(String refreshToken);

  Future<UserEntity> getCurrentUser();

  Future<void> logout();
}
