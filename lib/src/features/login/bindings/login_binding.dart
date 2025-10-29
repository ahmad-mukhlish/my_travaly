import 'package:get/get.dart';

import 'package:my_travaly/src/features/login/data/datasources/login_remote_data_source.dart';
import 'package:my_travaly/src/features/login/data/repositories/login_repository.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LoginRemoteDataSource>()) {
      Get.lazyPut<LoginRemoteDataSource>(
        () => LoginRemoteDataSource(),
      );
    }

    if (!Get.isRegistered<LoginRepository>()) {
      Get.lazyPut<LoginRepository>(
        () => LoginRepository(remoteDataSource: Get.find<LoginRemoteDataSource>()),
      );
    }

    if (!Get.isRegistered<LoginController>()) {
      Get.put<LoginController>(
        LoginController(
          loginRepository: Get.find<LoginRepository>(),
        ),
        permanent: true,
      );
    }
  }
}
