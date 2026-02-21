import 'package:backonnect/core/network/api_client.dart';
import 'package:backonnect/core/network/api_endpoint.dart';
import 'package:backonnect/features/auth/data/models/token_model.dart';
import 'package:backonnect/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<TokenModel> login({required String email, required String password});
  Future<TokenModel> register({required String email, required String password});
  Future<TokenModel> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<TokenModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoint.login,
      data: {'email': email, 'password': password},
    );
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return TokenModel.fromJson(data);
  }

  @override
  Future<TokenModel> register({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoint.register,
      data: {'email': email, 'password': password},
    );
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return TokenModel.fromJson(data);
  }

  @override
  Future<TokenModel> refreshToken(String token) async {
    final response = await apiClient.post(
      ApiEndpoint.refresh,
      data: {'refresh_token': token},
    );
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return TokenModel.fromJson(data);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoint.me);
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}
