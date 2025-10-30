import 'package:my_travaly/src/features/home/model/property_search_type.dart';

class SearchResultsArguments {
  const SearchResultsArguments({
    required this.queries,
    required this.searchType,
    this.customSearchType,
    this.title,
  });

  final List<String> queries;
  final PropertySearchType searchType;
  final String? customSearchType;
  final String? title;
}
