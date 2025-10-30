import 'package:dio/dio.dart';
import 'package:my_travaly/src/config/environment_config.dart';
import 'package:my_travaly/src/features/login/data/models/register_device_response.dart';
import 'package:my_travaly/src/features/login/model/device_register.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class LoginRemoteDataSource {
  LoginRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  Future<RegisterDeviceResponse> registerDevice(
    DeviceRegister deviceRegister,
  ) async {
    final payload = {
      'action': 'deviceRegister',
      'deviceRegister': deviceRegister.toJson(),
    };

    final options = Options(
      headers: {
        if (EnvironmentConfig.authToken.isNotEmpty)'authtoken': EnvironmentConfig.authToken,
      },
    );

    final response = await _apiService.post<Map<String, dynamic>>(
      data: payload,
      options: options,
    );

    final body = response.data;
    if (body == null) {
      throw const FormatException('Empty register device response');
    }

    final registerDeviceResponse = RegisterDeviceResponse.fromJson(body);

    if (!registerDeviceResponse.hasVisitorToken) {
      throw const FormatException('Missing visitor token in response');
    }

    return registerDeviceResponse;
  }
}
