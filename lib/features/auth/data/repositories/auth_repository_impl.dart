import 'package:backonnect/core/storage/token_storage_service.dart';
import 'package:backonnect/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:backonnect/features/auth/domain/entities/token_entity.dart';
import 'package:backonnect/features/auth/domain/entities/user_entity.dart';
import 'package:backonnect/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final TokenStorageService tokenStorageService;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.tokenStorageService,
  });

  @override
  Future<TokenEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await remoteDatasource.login(email: email, password: password);
    await tokenStorageService.saveTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
    return model.toEntity();
  }

  @override
  Future<TokenEntity> register({
    required String email,
    required String password,
  }) async {
    final model =
        await remoteDatasource.register(email: email, password: password);
    await tokenStorageService.saveTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
    return model.toEntity();
  }

  @override
  Future<TokenEntity> refreshToken(String token) async {
    final model = await remoteDatasource.refreshToken(token);
    await tokenStorageService.saveTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
    return model.toEntity();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final model = await remoteDatasource.getCurrentUser();
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await tokenStorageService.clearTokens();
  }
}
