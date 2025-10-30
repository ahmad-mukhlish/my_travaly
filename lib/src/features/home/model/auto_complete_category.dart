import 'package:flutter/material.dart';
import 'auto_complete_search_type.dart';

enum AutoCompleteCategory {
  property(
    displayName: 'Properties',
    icon: Icons.hotel,
  ),
  city(
    displayName: 'Cities',
    icon: Icons.location_city,
  ),
  state(
    displayName: 'States',
    icon: Icons.map,
  ),
  country(
    displayName: 'Countries',
    icon: Icons.flag,
  ),
  street(
    displayName: 'Streets',
    icon: Icons.signpost,
  ),
  other(
    displayName: 'Suggestions',
    icon: Icons.search,
  );

  const AutoCompleteCategory({
    required this.displayName,
    required this.icon,
  });

  final String displayName;
  final IconData icon;
}

AutoCompleteCategory categoryFromKey(String key) {
  final type = AutoCompleteSearchType.fromKeyOrNull(key);
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
