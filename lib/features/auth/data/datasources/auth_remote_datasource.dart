import 'package:backonnect/core/network/api_client.dart';
import 'package:backonnect/core/network/api_endpoint.dart';
import 'package:backonnect/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoint.me);
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}
