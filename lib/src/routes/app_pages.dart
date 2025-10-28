import 'package:get/get.dart';
import 'package:my_travaly/src/features/dashboard/views/screen/dashboard_screen.dart';


import '../features/dashboard/bindings/dashboard_binding.dart';
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
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
  ];
}
