import 'package:get/get.dart';
import 'package:my_travaly/src/features/login/controllers/login_controller.dart';
import 'package:my_travaly/src/features/login/data/datasources/login_remote_data_source.dart';
import 'package:my_travaly/src/features/login/data/repositories/login_repository.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LoginRemoteDataSource>()) {
      Get.lazyPut<LoginRemoteDataSource>(
        () => LoginRemoteDataSource(apiService: Get.find<ApiService>()),
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
