import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/views/screen/home_screen.dart';
import 'package:my_travaly/src/features/search_results/views/screens/search_results_screen.dart';

import '../features/home/bindings/home_binding.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/views/screen/login_screen.dart';
import '../features/search_results/bindings/search_results_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.searchResults,
      page: () => const SearchResultsScreen(),
      binding: SearchResultsBinding(),
    ),
  ];
}
