class Property {
  const Property({
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyCode,
    required this.propertyType,
    required this.city,
    required this.state,
    required this.country,
    required this.street,
    required this.priceDisplayAmount,
    required this.currencySymbol,
    required this.rating,
    required this.totalReviews,
    required this.propertyUrl,
  });

  final String propertyName;
  final int propertyStar;
  final String propertyImage;
  final String propertyCode;
  final String propertyType;
  final String city;
  final String state;
  final String country;
  final String street;
  final String priceDisplayAmount;
  final String currencySymbol;
  final double rating;
  final int totalReviews;
  final String propertyUrl;

  factory Property.fromJson(Map<String, dynamic> json) {
    final address = json['propertyAddress'] as Map<String, dynamic>? ?? const {};
    final markedPrice = json['markedPrice'] as Map<String, dynamic>? ?? const {};
    final googleReview = json['googleReview'] as Map<String, dynamic>? ?? const {};
    final reviewData = googleReview['data'] as Map<String, dynamic>? ?? const {};

    return Property(
      propertyName: json['propertyName'] as String? ?? 'Unknown property',
      propertyStar: (json['propertyStar'] as num?)?.toInt() ?? 0,
      propertyImage: json['propertyImage'] as String? ?? '',
      propertyCode: json['propertyCode'] as String? ?? '',
      propertyType: json['propertyType'] as String? ?? '',
      city: address['city'] as String? ?? '',
      state: address['state'] as String? ?? '',
      country: address['country'] as String? ?? '',
      street: address['street'] as String? ?? '',
      priceDisplayAmount: markedPrice['displayAmount'] as String? ?? '',
      currencySymbol: markedPrice['currencySymbol'] as String? ?? '',
      rating: (reviewData['overallRating'] as num?)?.toDouble() ?? 0,
      totalReviews: (reviewData['totalUserRating'] as num?)?.toInt() ?? 0,
      propertyUrl: json['propertyUrl'] as String? ?? '',
    );
  }
}
