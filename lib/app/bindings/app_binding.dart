import 'package:backonnect/core/auth/supabase_session_service.dart';
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
    // Keep TokenStorageService registered for now to avoid breaking any
    // non-auth code paths that might still depend on it.
    Get.put<TokenStorageService>(TokenStorageService(), permanent: true);

    Get.put<SupabaseSessionService>(SupabaseSessionService(), permanent: true);
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Auth dependencies needed app-wide (profile page, token refresh, etc.)
    Get.put<AuthRemoteDatasource>(
      AuthRemoteDatasourceImpl(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
        sessionService: Get.find<SupabaseSessionService>(),
      ),
      permanent: true,
    );
    Get.put<AuthController>(
      AuthController(
        authRepository: Get.find<AuthRepository>(),
        sessionService: Get.find<SupabaseSessionService>(),
      ),
      permanent: true,
    );
  }
}
