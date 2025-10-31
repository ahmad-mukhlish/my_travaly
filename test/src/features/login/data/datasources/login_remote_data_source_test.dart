import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_travaly/src/features/login/data/datasources/login_remote_data_source.dart';
import 'package:my_travaly/src/features/login/data/models/register_device_response.dart';
import 'package:my_travaly/src/features/login/model/device_register.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late MockApiService apiService;
  late LoginRemoteDataSource dataSource;

  setUp(() {
    apiService = MockApiService();
    dataSource = LoginRemoteDataSource(apiService: apiService);
  });

  group('registerDevice', () {
    test('returns parsed response when visitor token exists', () async {
      final deviceRegister = DeviceRegister(
        deviceModel: 'Pixel',
        deviceFingerprint: 'fingerprint',
        deviceBrand: 'Google',
        deviceId: '12345',
        deviceName: 'Pixel 5',
        deviceManufacturer: 'Google',
        deviceProduct: 'PixelProduct',
        deviceSerialNumber: 'serial-number',
      );

      final responseBody = <String, dynamic>{
        'status': true,
        'message': 'Registered',
        'responseCode': 200,
        'data': {
          'visitorToken': 'visitor-token',
        },
      };

      when(
        () => apiService.post<Map<String, dynamic>>(
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: responseBody,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.registerDevice(deviceRegister);

      expect(result, isA<RegisterDeviceResponse>());
      expect(result.visitorToken, 'visitor-token');

      final verification = verify(
        () => apiService.post<Map<String, dynamic>>(
          data: captureAny(named: 'data'),
          options: captureAny(named: 'options'),
        ),
      );

      final captured = verification.captured;
      final payload = captured[0] as Map<String, dynamic>;
      final options = captured[1] as Options;

      expect(
        payload,
        equals({
          'action': 'deviceRegister',
          'deviceRegister': deviceRegister.toJson(),
        }),
      );
      expect(options.headers?['authtoken'], isNull);
    });

    test('throws FormatException when response body is null', () async {
      when(
        () => apiService.post<Map<String, dynamic>>(
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: null,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(
        () => dataSource.registerDevice(
          const DeviceRegister(
            deviceModel: '',
            deviceFingerprint: '',
            deviceBrand: '',
            deviceId: '',
            deviceName: '',
            deviceManufacturer: '',
            deviceProduct: '',
            deviceSerialNumber: '',
          ),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when visitor token is missing', () async {
      when(
        () => apiService.post<Map<String, dynamic>>(
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: const {
            'status': true,
            'message': 'Registered',
            'responseCode': 200,
            'data': {
              'visitorToken': '',
            },
          },
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(
        () => dataSource.registerDevice(
          const DeviceRegister(
            deviceModel: '',
            deviceFingerprint: '',
            deviceBrand: '',
            deviceId: '',
            deviceName: '',
            deviceManufacturer: '',
            deviceProduct: '',
            deviceSerialNumber: '',
          ),
        ),
        throwsA(
          isA<FormatException>().having(
            (exception) => exception.message,
            'message',
            'Missing visitor token in response',
          ),
        ),
      );
    });
  });
}
