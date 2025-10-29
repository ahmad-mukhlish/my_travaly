import '../datasources/home_remote_data_source.dart';
import '../models/property_model.dart';
import '../models/search_auto_complete_result.dart';

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

  Future<SearchAutoCompleteResult> searchAutoComplete({
    required String visitorToken,
    required String inputText,
    required List<String> searchTypes,
    int limit = 10,
  }) {
    return _remoteDataSource.fetchSearchAutoComplete(
      visitorToken: visitorToken,
      inputText: inputText,
      searchTypes: searchTypes,
      limit: limit,
    );
  }
}
