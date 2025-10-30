import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/controllers/home_controller.dart';
import 'package:my_travaly/src/features/home/controllers/home_search_bar_controller.dart';
import 'package:my_travaly/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:my_travaly/src/features/home/data/repositories/home_repository.dart';
import 'package:my_travaly/src/features/login/controllers/login_controller.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeRemoteDataSource>()) {
      Get.lazyPut<HomeRemoteDataSource>(
        () => HomeRemoteDataSource(apiService: Get.find<ApiService>()),
      );
    }

    if (!Get.isRegistered<HomeRepository>()) {
      Get.lazyPut<HomeRepository>(
        () => HomeRepository(remoteDataSource: Get.find<HomeRemoteDataSource>()),
      );
    }

    if (!Get.isRegistered<HomeSearchBarController>()) {
      Get.lazyPut<HomeSearchBarController>(
        () => HomeSearchBarController(repository: Get.find<HomeRepository>(),
            loginController: Get.find<LoginController>()),
      );
    }

    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(
        () => HomeController(repository: Get.find<HomeRepository>()),
      );
    }
  }
}
