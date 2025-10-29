class SearchAutoCompleteResult {
  const SearchAutoCompleteResult({
    required this.present,
    required this.totalNumberOfResult,
    required this.categories,
  });

  final bool present;
  final int totalNumberOfResult;
  final Map<String, AutoCompleteCategory> categories;

  factory SearchAutoCompleteResult.empty() {
    return const SearchAutoCompleteResult(
      present: false,
      totalNumberOfResult: 0,
      categories: <String, AutoCompleteCategory>{},
    );
  }

  factory SearchAutoCompleteResult.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    final categoriesJson =
        data['autoCompleteList'] as Map<String, dynamic>? ?? const {};

    final categories = <String, AutoCompleteCategory>{};
    for (final entry in categoriesJson.entries) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        categories[entry.key] = AutoCompleteCategory.fromJson(value);
      }
    }

    return SearchAutoCompleteResult(
      present: data['present'] as bool? ?? false,
      totalNumberOfResult: (data['totalNumberOfResult'] as num?)?.toInt() ?? 0,
      categories: categories,
    );
  }
}

class AutoCompleteCategory {
  const AutoCompleteCategory({
    required this.present,
    required this.numberOfResult,
    required this.suggestions,
  });

  final bool present;
  final int numberOfResult;
  final List<AutoCompleteSuggestion> suggestions;

  factory AutoCompleteCategory.fromJson(Map<String, dynamic> json) {
    final list = json['listOfResult'];
    final suggestions = list is List
        ? list
            .whereType<Map<String, dynamic>>()
            .map(AutoCompleteSuggestion.fromJson)
            .toList()
        : <AutoCompleteSuggestion>[];
    return AutoCompleteCategory(
      present: json['present'] as bool? ?? false,
      numberOfResult: (json['numberOfResult'] as num?)?.toInt() ?? 0,
      suggestions: suggestions,
    );
  }
}

class AutoCompleteSuggestion {
  const AutoCompleteSuggestion({
    required this.valueToDisplay,
    this.propertyName,
    this.address,
    this.searchArray,
  });

  final String valueToDisplay;
  final String? propertyName;
  final AutoCompleteAddress? address;
  final AutoCompleteSearchArray? searchArray;

  factory AutoCompleteSuggestion.fromJson(Map<String, dynamic> json) {
    return AutoCompleteSuggestion(
      valueToDisplay: json['valueToDisplay'] as String? ?? '',
      propertyName: json['propertyName'] as String?,
      address: json['address'] is Map<String, dynamic>
          ? AutoCompleteAddress.fromJson(
              Map<String, dynamic>.from(json['address'] as Map),
            )
          : null,
      searchArray: json['searchArray'] is Map<String, dynamic>
          ? AutoCompleteSearchArray.fromJson(
              Map<String, dynamic>.from(json['searchArray'] as Map),
            )
          : null,
    );
  }
}

class AutoCompleteAddress {
  const AutoCompleteAddress({
    this.street,
    this.city,
    this.state,
    this.country,
  });

  final String? street;
  final String? city;
  final String? state;
  final String? country;

  factory AutoCompleteAddress.fromJson(Map<String, dynamic> json) {
    return AutoCompleteAddress(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }
}

class AutoCompleteSearchArray {
  const AutoCompleteSearchArray({
    this.type,
    required this.query,
  });

  final String? type;
  final List<String> query;

  factory AutoCompleteSearchArray.fromJson(Map<String, dynamic> json) {
    final list = json['query'];
    final queries = list is List
        ? list.whereType<String>().toList()
        : const <String>[];
    return AutoCompleteSearchArray(
      type: json['type'] as String?,
      query: queries,
    );
  }
}
