import '../datasources/home_remote_data_source.dart';
import '../models/property_model.dart';

class HomeRepository {
  const HomeRepository({
    required HomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  Future<List<Property>> getProperties({
    required String visitorToken,
    required String searchType,
    required Map<String, dynamic> searchInfo,
    String entityType = 'Any',
    int limit = 10,
    String currency = 'INR',
  }) {
    return _remoteDataSource.fetchProperties(
      visitorToken: visitorToken,
      searchType: searchType,
      searchTypeInfo: searchInfo,
      entityType: entityType,
      limit: limit,
      currency: currency,
    );
  }
}
