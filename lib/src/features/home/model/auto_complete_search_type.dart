enum AutoCompleteSearchType {
  propertyName(
    key: 'byPropertyName',
  ),
  city(
    key: 'byCity',
  ),
  state(
    key: 'byState',
  ),
  country(
    key: 'byCountry',
  ),
  street(
    key: 'byStreet',
  ),
  random(
    key: 'byRandom',
  );

  const AutoCompleteSearchType({
    required this.key,
  });

  final String key;

  static const List<AutoCompleteSearchType> _displaySequence = [
    AutoCompleteSearchType.propertyName,
    AutoCompleteSearchType.city,
    AutoCompleteSearchType.state,
    AutoCompleteSearchType.country,
    AutoCompleteSearchType.street,
  ];

  static const List<AutoCompleteSearchType> _searchSequence = [
    AutoCompleteSearchType.city,
    AutoCompleteSearchType.state,
    AutoCompleteSearchType.country,
    AutoCompleteSearchType.random,
    AutoCompleteSearchType.street,
    AutoCompleteSearchType.propertyName,
  ];

  static List<String> get displayOrderKeys {
    return List<String>.unmodifiable(
      _displaySequence.map((type) => type.key),
    );
  }

  static List<String> get searchTypeKeys {
    return List<String>.unmodifiable(
      _searchSequence.map((type) => type.key),
    );
  }

  static AutoCompleteSearchType? fromKeyOrNull(String key) {
    for (final type in values) {
      if (type.key == key) {
        return type;
      }
    }
    return null;
  }
}
