import 'search_auto_complete_category_result.dart';

export 'search_auto_complete_address.dart';
export 'search_auto_complete_category_result.dart';
export 'search_auto_complete_search_array.dart';
export 'search_auto_complete_suggestion.dart';

class SearchAutoCompleteResult {
  const SearchAutoCompleteResult({
    required this.present,
    required this.totalNumberOfResult,
    required this.categories,
  });

  final bool present;
  final int totalNumberOfResult;
  final Map<String, AutoCompleteCategoryResult> categories;

  factory SearchAutoCompleteResult.empty() {
    return const SearchAutoCompleteResult(
      present: false,
      totalNumberOfResult: 0,
      categories: <String, AutoCompleteCategoryResult>{},
    );
  }

  factory SearchAutoCompleteResult.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    final categoriesJson = data['autoCompleteList'] as Map<String, dynamic>? ?? const {};

    final categories = <String, AutoCompleteCategoryResult>{};
    for (final entry in categoriesJson.entries) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        categories[entry.key] = AutoCompleteCategoryResult.fromJson(value);
      }
    }

    return SearchAutoCompleteResult(
      present: data['present'] as bool? ?? false,
      totalNumberOfResult: (data['totalNumberOfResult'] as num?)?.toInt() ?? 0,
      categories: categories,
    );
  }
}
