class AutoCompleteSearchArray {
  const AutoCompleteSearchArray({
    this.type,
    required this.query,
  });

  final String? type;
  final List<String> query;

  factory AutoCompleteSearchArray.fromJson(Map<String, dynamic> json) {
    final list = json['query'];
    final queries = list is List ? list.whereType<String>().toList() : const <String>[];
    return AutoCompleteSearchArray(
      type: json['type'] as String?,
      query: queries,
    );
  }
}
