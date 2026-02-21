import 'package:backonnect/features/auth/controllers/login_controller.dart';
import 'package:backonnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController, AuthRepository, AuthRemoteDatasource are permanent
    // singletons registered in AppBinding. Only LoginController is scoped
    // to the auth routes.
    Get.lazyPut<LoginController>(
      () => LoginController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
