import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/views/screen/home_screen.dart';

import '../features/home/bindings/home_binding.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/views/screen/login_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
