import '../datasources/dashboard_remote_data_source.dart';
import '../models/popular_stay_model.dart';

class DashboardRepository {
  const DashboardRepository({
    required DashboardRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final DashboardRemoteDataSource _remoteDataSource;

  Future<List<PopularStay>> getPopularStays({
    required String visitorToken,
    required String searchType,
    required Map<String, dynamic> searchInfo,
    String entityType = 'Any',
    int limit = 10,
    String currency = 'INR',
  }) {
    return _remoteDataSource.fetchPopularStays(
      visitorToken: visitorToken,
      searchType: searchType,
      searchTypeInfo: searchInfo,
      entityType: entityType,
      limit: limit,
      currency: currency,
    );
  }
}
