import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/bindings/home_binding.dart';
import 'package:my_travaly/src/features/home/presentation/views/screen/home_screen.dart';
import 'package:my_travaly/src/features/login/bindings/login_binding.dart';
import 'package:my_travaly/src/features/login/presentation/views/screen/login_screen.dart';
import 'package:my_travaly/src/features/search_results/bindings/search_results_binding.dart';
import 'package:my_travaly/src/features/search_results/presentation/views/screens/search_results_screen.dart';
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
