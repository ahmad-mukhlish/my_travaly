class SearchParams {
  const SearchParams({
    required this.searchTypeKey,
    required this.searchInfo,
  });

  final String searchTypeKey;
  final Map<String, dynamic> searchInfo;
}