import '../../model/auto_complete_search_type.dart';
import '../../model/property_search_type.dart';
import '../../model/search_popular_property_params.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/property_model.dart';
import '../models/search_auto_complete_result.dart';

class HomeRepository {
  const HomeRepository({
    required HomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  Future<List<Property>> getPopularStays({
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

  SearchPopularStayParams buildSearchPopularStayParams(
      PropertySearchType type,
      String query,
      ) {
    if (query.isEmpty) {
      return SearchPopularStayParams(
        searchTypeKey: AutoCompleteSearchType.random.key,
        searchInfo: {},
      );
    }

    switch (type) {
      case PropertySearchType.hotelName:
        return SearchPopularStayParams(
          searchTypeKey: AutoCompleteSearchType.random.key,
          searchInfo: {
            'keyword': query,
            'propertyName': query,
          },
        );
      case PropertySearchType.city:
        return SearchPopularStayParams(
          searchTypeKey: AutoCompleteSearchType.city.key,
          searchInfo: {
            'city': query,
          },
        );
      case PropertySearchType.state:
        return SearchPopularStayParams(
          searchTypeKey: AutoCompleteSearchType.state.key,
          searchInfo: {
            'state': query,
          },
        );
      case PropertySearchType.country:
        return SearchPopularStayParams(
          searchTypeKey: AutoCompleteSearchType.country.key,
          searchInfo: {
            'country': query,
          },
        );
    }
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
