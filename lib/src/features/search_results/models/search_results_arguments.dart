import 'package:my_travaly/src/features/home/model/property_search_type.dart';

class SearchResultsArguments {
  const SearchResultsArguments({
    required this.query,
    required this.searchType,
    this.customSearchType,
  });

  final String query;
  final PropertySearchType searchType;
  final String? customSearchType;
}
