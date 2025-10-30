import 'package:my_travaly/src/features/login/data/datasources/login_remote_data_source.dart';
import 'package:my_travaly/src/features/login/data/models/register_device_response.dart';
import 'package:my_travaly/src/features/login/model/device_register.dart';

class LoginRepository {
  const LoginRepository({required LoginRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  final LoginRemoteDataSource _remoteDataSource;

  Future<RegisterDeviceResponse> registerDevice(
    DeviceRegister deviceRegister,
  ) {
    return _remoteDataSource.registerDevice(deviceRegister);
  }
}
