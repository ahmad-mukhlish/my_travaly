import 'package:dio/dio.dart';

import '../../../../config/environment_config.dart';
import '../../../../services/network/api_service.dart';
import '../models/search_result_model.dart';

class SearchResultsRemoteDataSource {
  SearchResultsRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService.to;

  final ApiService _apiService;

  static const String _searchResultsPath = '';

  Future<SearchResultsPage> fetchSearchResults({
    required String visitorToken,
    required String query,
    required String searchType,
    required int limit,
    required List<String> excludedHotelCodes,
    required int pageKey,
  }) async {
    final payload = <String, dynamic>{
      'action': 'getSearchResultListOfHotels',
      'getSearchResultListOfHotels': {
        'searchCriteria': {
          'checkIn': _defaultCheckIn,
          'checkOut': _defaultCheckOut,
          'rooms': 1,
          'adults': 2,
          'children': 0,
          'searchType': searchType,
          'searchQuery': [query],
          'accommodation': const ['all'],
          'arrayOfExcludedSearchType': const <String>[],
          'highPrice': '3000000',
          'lowPrice': '0',
          'limit': limit,
          'preloaderList': excludedHotelCodes,
          'currency': 'INR',
          'rid': pageKey,
        },
      },
    };

    final options = Options(
      headers: <String, dynamic>{
        if (EnvironmentConfig.authToken.isNotEmpty)
          'authtoken': EnvironmentConfig.authToken,
        'visitortoken': visitorToken,
      },
    );

    final response = await _apiService.post<Map<String, dynamic>>(
      _searchResultsPath,
      data: payload,
      options: options,
    );

    final body = response.data;
    if (body == null) {
      return const SearchResultsPage(results: <SearchResult>[], excludedHotelCodes: <String>[]);
    }

    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected search results response format');
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

  static String get _defaultCheckIn {
    final now = DateTime.now();
    final checkIn = now.add(const Duration(days: 7));
    return _formatDate(checkIn);
  }

  static String get _defaultCheckOut {
    final now = DateTime.now();
    final checkOut = now.add(const Duration(days: 8));
    return _formatDate(checkOut);
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
