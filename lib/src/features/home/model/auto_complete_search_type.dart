/// Represents the autocomplete search types returned by the backend.
enum AutoCompleteSearchType {
  propertyName(
    key: 'byPropertyName',
    displayOrder: 0,
    searchOrder: 5,
  ),
  city(
    key: 'byCity',
    displayOrder: 1,
    searchOrder: 0,
  ),
  state(
    key: 'byState',
    displayOrder: 2,
    searchOrder: 1,
  ),
  country(
    key: 'byCountry',
    displayOrder: 3,
    searchOrder: 2,
  ),
  street(
    key: 'byStreet',
    displayOrder: 4,
    searchOrder: 4,
  ),
  random(
    key: 'byRandom',
    searchOrder: 3,
  );

  const AutoCompleteSearchType({
    required this.key,
    this.displayOrder,
    this.searchOrder,
  });

  final String key;
  final int? displayOrder;
  final int? searchOrder;

  static List<String> get displayOrderKeys {
    final ordered = values
        .where((type) => type.displayOrder != null)
        .toList()
      ..sort(
        (a, b) => a.displayOrder!.compareTo(b.displayOrder!),
      );
    return List<String>.unmodifiable(
      ordered.map((type) => type.key),
    );
  }

  static List<String> get searchTypeKeys {
    final ordered = values
        .where((type) => type.searchOrder != null)
        .toList()
      ..sort(
        (a, b) => a.searchOrder!.compareTo(b.searchOrder!),
      );
    return List<String>.unmodifiable(
      ordered.map((type) => type.key),
    );
  }

  static AutoCompleteSearchType? tryFromKey(String key) {
    for (final type in values) {
      if (type.key == key) {
        return type;
      }
    }
    return null;
  }
}
