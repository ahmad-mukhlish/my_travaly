import 'package:my_travaly/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:my_travaly/src/features/home/data/models/property_model.dart';
import 'package:my_travaly/src/features/home/data/models/search_auto_complete_result.dart';
import 'package:my_travaly/src/features/home/model/auto_complete_search_type.dart';

class HomeRepository {
  const HomeRepository({
    required HomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  Future<List<Property>> getPopularStays({
    required String visitorToken,
    String entityType = 'Any',
    int limit = 10,
    String currency = 'INR',
  }) {
    return _remoteDataSource.fetchPopularStays(
      visitorToken: visitorToken,
      searchType: AutoCompleteSearchType.random.key,
      searchTypeInfo: {},
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
