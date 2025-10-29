import '../datasources/search_results_remote_data_source.dart';
import '../models/search_result_model.dart';

class SearchResultsRepository {
  const SearchResultsRepository({
    required SearchResultsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final SearchResultsRemoteDataSource _remoteDataSource;

  Future<SearchResultsPage> fetchSearchResults({
    required String visitorToken,
    required String query,
    required String searchType,
    required int limit,
    required List<String> excludedHotelCodes,
    required int pageKey,
  }) {
    return _remoteDataSource.fetchSearchResults(
      visitorToken: visitorToken,
      query: query,
      searchType: searchType,
      limit: limit,
      excludedHotelCodes: excludedHotelCodes,
      pageKey: pageKey,
    );
  }
}
