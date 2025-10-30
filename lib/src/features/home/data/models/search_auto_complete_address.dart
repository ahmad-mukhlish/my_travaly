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
