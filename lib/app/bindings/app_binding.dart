import 'package:backonnect/core/network/api_client.dart';
import 'package:backonnect/core/storage/local_storage_service.dart';
import 'package:backonnect/core/storage/token_storage_service.dart';
import 'package:backonnect/features/auth/controllers/auth_controller.dart';
import 'package:backonnect/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:backonnect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:backonnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LocalStorageService>(LocalStorageService(), permanent: true);
    Get.put<TokenStorageService>(TokenStorageService(), permanent: true);
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Auth dependencies needed app-wide (profile page, token refresh, etc.)
    Get.put<AuthRemoteDatasource>(
      AuthRemoteDatasourceImpl(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
        tokenStorageService: Get.find<TokenStorageService>(),
      ),
      permanent: true,
    );
    Get.put<AuthController>(
      AuthController(
        authRepository: Get.find<AuthRepository>(),
        tokenStorageService: Get.find<TokenStorageService>(),
      ),
      permanent: true,
    );
  }
}
