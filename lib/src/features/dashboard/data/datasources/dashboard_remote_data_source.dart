import 'package:dio/dio.dart';

import '../../../../config/environment_config.dart';
import '../../../../services/network/api_service.dart';
import '../models/popular_stay_model.dart';

class DashboardRemoteDataSource {
  DashboardRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService.to;

  final ApiService _apiService;

  static const String _popularStayPath = '';

  Future<List<PopularStay>> fetchPopularStays({
    required String visitorToken,
    required String searchType,
    required Map<String, dynamic> searchTypeInfo,
    String entityType = 'Any',
    int limit = 10,
    String currency = 'INR',
  }) async {
    final payload = <String, dynamic>{
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
      headers: <String, dynamic>{
        if (EnvironmentConfig.authToken.isNotEmpty)
          'authtoken': EnvironmentConfig.authToken,
        'visitortoken': visitorToken,
      },
    );

    final response = await _apiService.post<Map<String, dynamic>>(
      _popularStayPath,
      data: payload,
      options: options,
    );

    final body = response.data;
    if (body == null) {
      return const <PopularStay>[];
    }

    final list = body['data'];
    if (list is! List) {
      return const <PopularStay>[];
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map(PopularStay.fromJson)
        .toList();
  }
}
