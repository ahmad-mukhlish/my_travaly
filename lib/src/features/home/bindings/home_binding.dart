import 'package:get/get.dart';
import 'package:my_travaly/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:my_travaly/src/features/home/data/repositories/home_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeRemoteDataSource>()) {
      Get.lazyPut<HomeRemoteDataSource>(
        () => HomeRemoteDataSource(),
      );
    }

    if (!Get.isRegistered<HomeRepository>()) {
      Get.lazyPut<HomeRepository>(
        () => HomeRepository(remoteDataSource: Get.find<HomeRemoteDataSource>()),
      );
    }

    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(
        () => HomeController(repository: Get.find<HomeRepository>()),
      );
    }
  }
}
