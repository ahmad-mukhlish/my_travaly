const int kSearchResultsMaxPrice = 100000;

class SearchResultsFilter {
  const SearchResultsFilter({
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.lowPrice,
    required this.highPrice,
  });

  final DateTime checkIn;
  final DateTime checkOut;
  final int rooms;
  final int adults;
  final int children;
  final int lowPrice;
  final int highPrice;

  factory SearchResultsFilter.defaults() {
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);
    final defaultCheckIn = normalizedNow.add(const Duration(days: 7));
    final defaultCheckOut = normalizedNow.add(const Duration(days: 8));
    return SearchResultsFilter(
      checkIn: defaultCheckIn,
      checkOut: defaultCheckOut,
      rooms: 1,
      adults: 2,
      children: 0,
      lowPrice: 0,
      highPrice: kSearchResultsMaxPrice,
    );
  }

  SearchResultsFilter copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
    int? rooms,
    int? adults,
    int? children,
    int? lowPrice,
    int? highPrice,
  }) {
    return SearchResultsFilter(
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      rooms: rooms ?? this.rooms,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      lowPrice: lowPrice ?? this.lowPrice,
      highPrice: highPrice ?? this.highPrice,
    );
  }
}
