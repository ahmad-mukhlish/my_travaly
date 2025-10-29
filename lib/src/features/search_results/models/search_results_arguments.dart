import '../../home/models/property_search_type.dart';

class SearchResultsArguments {
  const SearchResultsArguments({
    required this.query,
    required this.searchType,
  });

  final String query;
  final PropertySearchType searchType;
}
