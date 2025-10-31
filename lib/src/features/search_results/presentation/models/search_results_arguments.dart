import 'package:my_travaly/src/enums/property_search_type.dart';
import 'package:my_travaly/src/features/search_results/presentation/models/search_results_filter.dart';

class SearchResultsArguments {
  const SearchResultsArguments({
    required this.queries,
    required this.searchType,
    this.customSearchType,
    this.title,
    this.initialFilter,
  });

  final List<String> queries;
  final PropertySearchType searchType;
  final String? customSearchType;
  final String? title;
  final SearchResultsFilter? initialFilter;
}
