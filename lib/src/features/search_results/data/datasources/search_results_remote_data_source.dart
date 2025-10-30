import 'package:dio/dio.dart';
import 'package:my_travaly/src/config/environment_config.dart';
import 'package:my_travaly/src/features/search_results/data/models/search_result_model.dart';
import 'package:my_travaly/src/services/network/api_service.dart';

class SearchResultsRemoteDataSource {
  SearchResultsRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  Future<SearchResultsPage> fetchSearchResults({
    required String visitorToken,
    required List<String> queries,
    required String searchType,
    required int limit,
    required List<String> excludedHotelCodes,
    required DateTime checkIn,
    required DateTime checkOut,
    required int rooms,
    required int adults,
    required int children,
    required int lowPrice,
    required int highPrice,
  }) async {
    final payload = {
      'action': 'getSearchResultListOfHotels',
      'getSearchResultListOfHotels': {
        'searchCriteria': {
          'checkIn': _formatDate(checkIn),
          'checkOut': _formatDate(checkOut),
          'rooms': rooms,
          'adults': adults,
          'children': children,
          'searchType': searchType,
          'searchQuery': queries,
          'accommodation': const ['all'],
          'arrayOfExcludedSearchType': [],
          'highPrice': highPrice.toString(),
          'lowPrice': lowPrice.toString(),
          'limit': limit,
          'preloaderList': excludedHotelCodes,
          'currency': 'INR',
          'rid': 0,
        },
      },
    };

    final options = Options(
      headers: {
        if (EnvironmentConfig.authToken.isNotEmpty) 'authtoken': EnvironmentConfig.authToken,
        'visitortoken': visitorToken,
      },
    );

    final response = await _apiService.post<Map<String, dynamic>>(
      data: payload,
      options: options,
    );

    final body = response.data;
    if (body == null) {
      return const SearchResultsPage(results: [], excludedHotelCodes: []);
    }

    final data = body['data'] as Map<String, dynamic>? ?? const {};
    final rawList = data['arrayOfHotelList'];
    final rawExcluded = data['arrayOfExcludedHotels'];

    final results = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map(SearchResult.fromJson)
            .toList()
        : <SearchResult>[];

    final excludedCodes = rawExcluded is List
        ? rawExcluded
            .whereType<String>()
            .toList()
        : <String>[];

    return SearchResultsPage(
      results: results,
      excludedHotelCodes: excludedCodes,
    );
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
