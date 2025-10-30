import '../data/models/search_auto_complete_result.dart' hide AutoCompleteCategory;
import 'auto_complete_entry.dart';

sealed class HomeAutoCompleteEntry {
  const HomeAutoCompleteEntry({required this.category});

  final AutoCompleteCategory category;
}

class HomeAutoCompleteHeader extends HomeAutoCompleteEntry {
  const HomeAutoCompleteHeader({
    required super.category,
    required this.title,
    required this.count,
  });

  final String title;
  final int count;
}

class HomeAutoCompleteItem extends HomeAutoCompleteEntry {
  const HomeAutoCompleteItem({
    required super.category,
    required this.categoryKey,
    required this.suggestion,
  });

  final String categoryKey;
  final AutoCompleteSuggestion suggestion;

  String get title => suggestion.valueToDisplay;

  AutoCompleteAddress? get address => suggestion.address;
  AutoCompleteSearchArray? get searchArray => suggestion.searchArray;
}
