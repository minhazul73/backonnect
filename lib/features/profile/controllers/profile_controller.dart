import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/features/auth/controllers/auth_controller.dart';
import 'package:backonnect/features/auth/domain/entities/user_entity.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late final AuthController _authController;

  late final Rx<UserEntity?> currentUser;
  late final RxBool isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    _authController = Get.find<AuthController>();
    currentUser = _authController.currentUser;
    isLoggedIn = _authController.isLoggedIn;
  }

  Future<void> logout() async {
    await _authController.logout();
    Get.offAllNamed<void>(AppRoutes.login);
  }
}
