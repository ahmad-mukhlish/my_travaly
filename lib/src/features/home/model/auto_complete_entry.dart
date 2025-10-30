import 'package:flutter/material.dart';

import '../data/models/search_auto_complete_result.dart';
import 'auto_complete_search_type.dart';

enum AutoCompleteCategory {
  property,
  city,
  state,
  country,
  street,
  other,
}

extension AutoCompleteCategoryX on AutoCompleteCategory {
  String get displayName {
    switch (this) {
      case AutoCompleteCategory.property:
        return 'Properties';
      case AutoCompleteCategory.city:
        return 'Cities';
      case AutoCompleteCategory.state:
        return 'States';
      case AutoCompleteCategory.country:
        return 'Countries';
      case AutoCompleteCategory.street:
        return 'Streets';
      case AutoCompleteCategory.other:
        return 'Suggestions';
    }
  }

  IconData get icon {
    switch (this) {
      case AutoCompleteCategory.property:
        return Icons.hotel;
      case AutoCompleteCategory.city:
        return Icons.location_city;
      case AutoCompleteCategory.state:
        return Icons.map;
      case AutoCompleteCategory.country:
        return Icons.flag;
      case AutoCompleteCategory.street:
        return Icons.signpost;
      case AutoCompleteCategory.other:
        return Icons.search;
    }
  }
}

AutoCompleteCategory categoryFromKey(String key) {
  final type = AutoCompleteSearchType.tryFromKey(key);
  switch (type) {
    case AutoCompleteSearchType.propertyName:
      return AutoCompleteCategory.property;
    case AutoCompleteSearchType.city:
      return AutoCompleteCategory.city;
    case AutoCompleteSearchType.state:
      return AutoCompleteCategory.state;
    case AutoCompleteSearchType.country:
      return AutoCompleteCategory.country;
    case AutoCompleteSearchType.street:
      return AutoCompleteCategory.street;
    case AutoCompleteSearchType.random:
      return AutoCompleteCategory.other;
    case null:
      return AutoCompleteCategory.other;
  }
}

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
