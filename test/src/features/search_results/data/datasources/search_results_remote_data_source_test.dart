import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_travaly/src/features/search_results/data/datasources/search_results_remote_data_source.dart';
import 'package:my_travaly/src/features/search_results/data/models/search_result_model.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late MockApiService apiService;
  late SearchResultsRemoteDataSource dataSource;

  setUp(() {
    apiService = MockApiService();
    dataSource = SearchResultsRemoteDataSource(apiService: apiService);
  });

  group('fetchSearchResults', () {
    test('returns mapped page when API responds with valid data', () async {
      const visitorToken = 'visitor-token';
      const queries = ['Delhi'];
      const searchType = 'city';
      final checkIn = DateTime(2024, 10, 1);
      final checkOut = DateTime(2024, 10, 3);

      final responseBody = <String, dynamic>{
        'data': {
          'arrayOfHotelList': [
            {
              'propertyCode': 'P123',
              'propertyName': 'Hotel Delhi',
              'propertytype': 'Hotel',
              'propertyStar': 4,
              'propertyAddress': {
                'city': 'Delhi',
                'state': 'Delhi',
                'country': 'India',
                'street': 'MG Road',
              },
              'propertyImage': {'fullUrl': 'https://example.com/image.jpg'},
              'markedPrice': {
                'displayAmount': '₹5000',
                'currencySymbol': '₹',
              },
              'googleReview': {
                'data': {
                  'overallRating': 4.5,
                  'totalUserRating': 120,
                },
              },
              'propertyUrl': 'https://example.com/property',
            },
          ],
          'arrayOfExcludedHotels': ['P999'],
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

      final page = await dataSource.fetchSearchResults(
        visitorToken: visitorToken,
        queries: queries,
        searchType: searchType,
        limit: 5,
        excludedHotelCodes: const ['P888'],
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: 1,
        adults: 2,
        children: 0,
        lowPrice: 1000,
        highPrice: 5000,
      );

      expect(page.results, hasLength(1));
      expect(page.excludedHotelCodes, ['P999']);

      final result = page.results.first;
      expect(result, isA<SearchResult>());
      expect(result.propertyCode, 'P123');
      expect(result.priceDisplayAmount, '₹5000');

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
          'action': 'getSearchResultListOfHotels',
          'getSearchResultListOfHotels': {
            'searchCriteria': {
              'checkIn': '2024-10-01',
              'checkOut': '2024-10-03',
              'rooms': 1,
              'adults': 2,
              'children': 0,
              'searchType': searchType,
              'searchQuery': queries,
              'accommodation': const ['all'],
              'arrayOfExcludedSearchType': [],
              'highPrice': '5000',
              'lowPrice': '1000',
              'limit': 5,
              'preloaderList': const ['P888'],
              'currency': 'INR',
              'rid': 0,
            },
          },
        }),
      );
      expect(options.headers?['visitortoken'], visitorToken);
    });

    test('returns empty page when body is null', () async {
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

      final page = await dataSource.fetchSearchResults(
        visitorToken: 'token',
        queries: const ['query'],
        searchType: 'type',
        limit: 1,
        excludedHotelCodes: const [],
        checkIn: DateTime(2024, 1, 1),
        checkOut: DateTime(2024, 1, 2),
        rooms: 1,
        adults: 1,
        children: 0,
        lowPrice: 0,
        highPrice: 0,
      );

      expect(page.results, isEmpty);
      expect(page.excludedHotelCodes, isEmpty);
    });
  });
}
