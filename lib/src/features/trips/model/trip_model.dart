class TripPlan {
  const TripPlan({
    required this.title,
    required this.location,
    required this.dateRange,
    required this.status,
    required this.highlights,
  });

  final String title;
  final String location;
  final String dateRange;
  final String status;
  final List<String> highlights;
}
