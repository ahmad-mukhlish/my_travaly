enum PropertySearchType {
  hotelName(label: 'Hotel', apiValue: 'hotelNameSearch'),
  city(label: 'City', apiValue: 'citySearch'),
  state(label: 'State', apiValue: 'stateSearch'),
  country(label: 'Country', apiValue: 'countrySearch');

  final String label;
  final String apiValue;

  const PropertySearchType({required this.label, required this.apiValue});
}
