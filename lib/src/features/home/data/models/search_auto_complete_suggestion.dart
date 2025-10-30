import 'search_auto_complete_address.dart';
import 'search_auto_complete_search_array.dart';

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
