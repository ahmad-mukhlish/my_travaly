import 'package:get/get.dart';
import 'package:my_travaly/src/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:my_travaly/src/features/dashboard/data/repositories/dashboard_repository.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DashboardRemoteDataSource>()) {
      Get.lazyPut<DashboardRemoteDataSource>(
        () => DashboardRemoteDataSource(),
      );
    }

    if (!Get.isRegistered<DashboardRepository>()) {
      Get.lazyPut<DashboardRepository>(
        () => DashboardRepository(remoteDataSource: Get.find<DashboardRemoteDataSource>()),
      );
    }

    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut<DashboardController>(
        () => DashboardController(repository: Get.find<DashboardRepository>()),
      );
    }
  }
}
