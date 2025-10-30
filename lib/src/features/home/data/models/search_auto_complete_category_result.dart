import 'search_auto_complete_suggestion.dart';

class AutoCompleteCategoryResult {
  const AutoCompleteCategoryResult({
    required this.present,
    required this.numberOfResult,
    required this.suggestions,
  });

  final bool present;
  final int numberOfResult;
  final List<AutoCompleteSuggestion> suggestions;

  factory AutoCompleteCategoryResult.fromJson(Map<String, dynamic> json) {
    final list = json['listOfResult'];
    final suggestions = list is List
        ? list.whereType<Map<String, dynamic>>().map(AutoCompleteSuggestion.fromJson).toList()
        : const <AutoCompleteSuggestion>[];
    return AutoCompleteCategoryResult(
      present: json['present'] as bool? ?? false,
      numberOfResult: (json['numberOfResult'] as num?)?.toInt() ?? 0,
      suggestions: suggestions,
    );
  }
}
