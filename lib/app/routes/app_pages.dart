import 'package:backonnect/app/bindings/app_binding.dart';
import 'package:backonnect/app/middleware/auth_middleware.dart';
import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/features/auth/bindings/auth_binding.dart';
import 'package:backonnect/features/auth/presentation/pages/login_page.dart';
import 'package:backonnect/features/auth/presentation/pages/register_page.dart';
import 'package:backonnect/features/auth/presentation/pages/splash_screen.dart';
import 'package:backonnect/features/items/bindings/items_binding.dart';
import 'package:backonnect/features/items/presentation/pages/create_item_page.dart';
import 'package:backonnect/features/items/presentation/pages/edit_item_page.dart';
import 'package:backonnect/features/items/presentation/pages/item_detail_page.dart';
import 'package:backonnect/features/items/presentation/pages/items_list_page.dart';
import 'package:backonnect/features/profile/bindings/profile_binding.dart';
import 'package:backonnect/features/profile/presentation/pages/profile_page.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static const String initial = AppRoutes.splash;

  static final List<GetPage<dynamic>> routes = [
    GetPage<void>(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.itemsList,
      page: () => const ItemsListPage(),
      binding: ItemsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.itemDetail,
      page: () => const ItemDetailPage(),
      binding: ItemsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.createItem,
      page: () => const CreateItemPage(),
      binding: ItemsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.editItem,
      page: () => const EditItemPage(),
      binding: ItemsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
