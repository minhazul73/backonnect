import 'package:backonnect/core/storage/token_storage_service.dart';
import 'package:backonnect/core/utils/logger/app_logger.dart';
import 'package:backonnect/features/auth/domain/entities/user_entity.dart';
import 'package:backonnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final TokenStorageService _tokenStorageService;

  AuthController({
    required AuthRepository authRepository,
    required TokenStorageService tokenStorageService,
  })  : _authRepository = authRepository,
        _tokenStorageService = tokenStorageService;

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxBool isFetchingUser = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-fetch user if a token is already stored (app relaunch / smart auth)
    if (_tokenStorageService.hasToken) {
      _fetchCurrentUser();
    }
    ever(isLoggedIn, (bool loggedIn) {
      if (loggedIn) _fetchCurrentUser();
    });
  }

  Future<void> fetchCurrentUser() async {
    await _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      isFetchingUser.value = true;
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;
      isLoggedIn.value = true;
    } catch (e) {
      AppLogger.warning('Could not fetch current user', error: e);
    } finally {
      isFetchingUser.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      AppLogger.error('Error during logout', error: e);
    } finally {
      currentUser.value = null;
      isLoggedIn.value = false;
    }
  }

  @override
  void onClose() {
    currentUser.close();
    isLoggedIn.close();
    isFetchingUser.close();
    super.onClose();
  }
}
