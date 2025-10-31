import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_travaly/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late MockApiService apiService;
  late HomeRemoteDataSource dataSource;

  setUp(() {
    apiService = MockApiService();
    dataSource = HomeRemoteDataSource(apiService: apiService);
  });

  group('fetchPopularStays', () {
    test('returns mapped properties when API returns a valid list', () async {
      const visitorToken = 'visitor-token';
      const searchType = 'CITY';
      final searchTypeInfo = <String, dynamic>{'cityName': 'Bangalore'};
      final apiResponse = <String, dynamic>{
        'data': [
          {
            'propertyName': 'Property 1',
            'propertyStar': 4,
            'propertyImage': 'image.png',
            'propertyCode': 'P123',
            'propertyType': 'Hotel',
            'propertyAddress': {
              'city': 'Bangalore',
              'state': 'Karnataka',
              'country': 'India',
              'street': 'MG Road',
            },
            'markedPrice': {
              'displayAmount': '₹5000',
              'currencySymbol': '₹',
            },
            'googleReview': {
              'data': {
                'overallRating': 4.3,
                'totalUserRating': 120,
              },
            },
            'propertyUrl': 'https://example.com/property',
          },
        ],
      };

      when(
        () => apiService.post<Map<String, dynamic>>(
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: apiResponse,
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      final result = await dataSource.fetchPopularStays(
        visitorToken: visitorToken,
        searchType: searchType,
        searchTypeInfo: searchTypeInfo,
      );

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
          'action': 'popularStay',
          'popularStay': {
            'limit': 10,
            'entityType': 'Any',
            'filter': {
              'searchType': searchType,
              'searchTypeInfo': searchTypeInfo,
            },
            'currency': 'INR',
          },
        }),
      );
      expect(options.headers?['visitortoken'], visitorToken);
      expect(result, hasLength(1));

      final property = result.first;
      expect(property.propertyName, 'Property 1');
      expect(property.city, 'Bangalore');
      expect(property.currencySymbol, '₹');
      expect(property.totalReviews, 120);
    });

    test('returns empty list when API body is missing data list', () async {
      when(
        () => apiService.post<Map<String, dynamic>>(
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: const {'data': 'not-a-list'},
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.fetchPopularStays(
        visitorToken: 'token',
        searchType: 'CITY',
        searchTypeInfo: const <String, dynamic>{'key': 'value'},
      );

      expect(result, isEmpty);
    });
  });

  group('fetchSearchAutoComplete', () {
    test('returns parsed result when API responds with valid data', () async {
      const visitorToken = 'visitor-token';
      const inputText = 'Del';
      const searchTypes = ['property'];
      final responseData = <String, dynamic>{
        'data': {
          'present': true,
          'totalNumberOfResult': 1,
          'autoCompleteList': {
            'property': {
              'present': true,
              'numberOfResult': 1,
              'listOfResult': [
                {
                  'valueToDisplay': 'Delhi Property',
                  'propertyName': 'Hotel Delhi',
                  'address': {
                    'city': 'Delhi',
                    'country': 'India',
                  },
                  'searchArray': {
                    'type': 'city',
                    'query': ['Delhi', 'India'],
                  },
                },
              ],
            },
          },
        },
      };

      when(
        () => apiService.post<Map<String, dynamic>>(
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: responseData,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.fetchSearchAutoComplete(
        visitorToken: visitorToken,
        inputText: inputText,
        searchTypes: searchTypes,
      );

      expect(result.present, isTrue);
      expect(result.totalNumberOfResult, 1);

      final category = result.categories['property'];
      expect(category, isNotNull);
      expect(category!.suggestions, hasLength(1));
      expect(category.suggestions.first.valueToDisplay, 'Delhi Property');

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
          'action': 'searchAutoComplete',
          'searchAutoComplete': {
            'inputText': inputText,
            'searchType': searchTypes,
            'limit': 10,
          },
        }),
      );
      expect(options.headers?['visitortoken'], visitorToken);
    });

    test('returns empty result when API body is null', () async {
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

      final result = await dataSource.fetchSearchAutoComplete(
        visitorToken: 'token',
        inputText: 'text',
        searchTypes: const ['property'],
      );

      expect(result.present, isFalse);
      expect(result.totalNumberOfResult, 0);
      expect(result.categories, isEmpty);
    });
  });
}
