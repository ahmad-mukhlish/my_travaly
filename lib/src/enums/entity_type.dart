enum EntityType {
  any(label: 'All', backendValue: 'Any'),
  hotel(label: 'Hotels', backendValue: 'hotel'),
  resort(label: 'Resorts', backendValue: 'resort'),
  homestay(label: 'Homestays', backendValue: 'Home Stay'),
  campsite(label: 'Campsites', backendValue: 'Camp_sites/tent');

  const EntityType({required this.label, required this.backendValue});

  final String label;
  final String backendValue;
}
