class SearchResult {
  const SearchResult({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyType,
    required this.propertyStar,
    required this.city,
    required this.state,
    required this.country,
    required this.street,
    required this.imageUrl,
    required this.priceDisplayAmount,
    required this.currencySymbol,
    required this.rating,
    required this.totalReviews,
    required this.propertyUrl,
  });

  final String propertyCode;
  final String propertyName;
  final String propertyType;
  final int propertyStar;
  final String city;
  final String state;
  final String country;
  final String street;
  final String imageUrl;
  final String priceDisplayAmount;
  final String currencySymbol;
  final double rating;
  final int totalReviews;
  final String propertyUrl;

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final address = json['propertyAddress'] as Map<String, dynamic>? ?? const {};
    final markedPrice = json['markedPrice'] as Map<String, dynamic>? ?? const {};
    final googleReview = json['googleReview'] as Map<String, dynamic>? ?? const {};
    final reviewData = googleReview['data'] as Map<String, dynamic>? ?? const {};
    final image = json['propertyImage'] as Map<String, dynamic>? ?? const {};

    return SearchResult(
      propertyCode: json['propertyCode'] as String? ?? '',
      propertyName: json['propertyName'] as String? ?? 'Unknown property',
      propertyType: json['propertytype'] as String? ?? '',
      propertyStar: (json['propertyStar'] as num?)?.toInt() ?? 0,
      city: address['city'] as String? ?? '',
      state: address['state'] as String? ?? '',
      country: address['country'] as String? ?? '',
      street: address['street'] as String? ?? '',
      imageUrl: image['fullUrl'] as String? ?? '',
      priceDisplayAmount: markedPrice['displayAmount'] as String? ?? '',
      currencySymbol: markedPrice['currencySymbol'] as String? ?? '',
      rating: (reviewData['overallRating'] as num?)?.toDouble() ?? 0,
      totalReviews: (reviewData['totalUserRating'] as num?)?.toInt() ?? 0,
      propertyUrl: json['propertyUrl'] as String? ?? '',
    );
  }
}

class SearchResultsPage {
  const SearchResultsPage({
    required this.results,
    required this.excludedHotelCodes,
  });

  final List<SearchResult> results;
  final List<String> excludedHotelCodes;
}
