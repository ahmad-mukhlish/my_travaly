enum PropertySearchType { hotelName, city, state, country }

extension PropertySearchTypeX on PropertySearchType {
  String get label {
    switch (this) {
      case PropertySearchType.hotelName:
        return 'Hotel';
      case PropertySearchType.city:
        return 'City';
      case PropertySearchType.state:
        return 'State';
      case PropertySearchType.country:
        return 'Country';
    }
  }

  String get placeholder {
    switch (this) {
      case PropertySearchType.hotelName:
        return 'Search by hotel name';
      case PropertySearchType.city:
        return 'Search by city';
      case PropertySearchType.state:
        return 'Search by state';
      case PropertySearchType.country:
        return 'Search by country';
    }
  }

  String get apiValue {
    switch (this) {
      case PropertySearchType.hotelName:
        return 'hotelNameSearch';
      case PropertySearchType.city:
        return 'citySearch';
      case PropertySearchType.state:
        return 'stateSearch';
      case PropertySearchType.country:
        return 'countrySearch';
    }
  }
}
