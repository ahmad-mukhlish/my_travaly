import 'package:dio/dio.dart';

import '../../../../config/environment_config.dart';
import '../../../../services/network/api_service.dart';
import '../models/property_model.dart';
import '../models/search_auto_complete_result.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  final ApiService _apiService;

  Future<List<Property>> fetchPopularStays({
    required String visitorToken,
    required String searchType,
    required Map<String, dynamic> searchTypeInfo,
    String entityType = 'Any',
    int limit = 10,
    String currency = 'INR',
  }) async {
    final payload = {
      'action': 'popularStay',
      'popularStay': {
        'limit': limit,
        'entityType': entityType,
        'filter': {
          'searchType': searchType,
          'searchTypeInfo': searchTypeInfo,
        },
        'currency': currency,
      },
    };

    final options = Options(
      headers: {
        if (EnvironmentConfig.authToken.isNotEmpty)'authtoken': EnvironmentConfig.authToken,
        'visitortoken': visitorToken,
      },
    );

    final response = await _apiService.post<Map<String, dynamic>>(
      data: payload,
      options: options,
    );

    final body = response.data;
    if (body == null) return [];

    final list = body['data'];
    if (list is! List) return [];

    return list
        .whereType<Map<String, dynamic>>()
        .map(Property.fromJson)
        .toList();
  }

  Future<SearchAutoCompleteResult> fetchSearchAutoComplete({
    required String visitorToken,
    required String inputText,
    required List<String> searchTypes,
    int limit = 10,
  }) async {
    final payload = {
      'action': 'searchAutoComplete',
      'searchAutoComplete': {
        'inputText': inputText,
        'searchType': searchTypes,
        'limit': limit,
      },
    };

    final options = Options(
      headers: {
        if (EnvironmentConfig.authToken.isNotEmpty)'authtoken': EnvironmentConfig.authToken,
        'visitortoken': visitorToken,
      },
    );

    final response = await _apiService.post<Map<String, dynamic>>(
      data: payload,
      options: options,
    );

    final body = response.data;
    if (body == null) {
      return SearchAutoCompleteResult.empty();
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      return SearchAutoCompleteResult.empty();
    }

    return SearchAutoCompleteResult.fromJson(data);
  }
}
