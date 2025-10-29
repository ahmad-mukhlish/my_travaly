import 'package:dio/dio.dart';
import 'package:my_travaly/src/config/environment_config.dart';
import 'package:my_travaly/src/features/login/data/models/register_device_response.dart';
import 'package:my_travaly/src/features/login/model/device_register.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class LoginRemoteDataSource {
  LoginRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService.to;

  final ApiService _apiService;

  static const String _registerDevicePath = '';

  Future<RegisterDeviceResponse> registerDevice(
    DeviceRegister deviceRegister,
  ) async {
    final payload = <String, dynamic>{
      'action': 'deviceRegister',
      'deviceRegister': deviceRegister.toJson(),
    };

    final options = Options(
      headers: <String, dynamic>{
        if (EnvironmentConfig.authToken.isNotEmpty)
          'authtoken': EnvironmentConfig.authToken,
      },
    );

    final response = await _apiService.post<Map<String, dynamic>>(
      _registerDevicePath,
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
