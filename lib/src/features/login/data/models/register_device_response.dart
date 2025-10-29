class RegisterDeviceResponse {
  const RegisterDeviceResponse({
    required this.status,
    required this.message,
    required this.responseCode,
    required this.visitorToken,
  });

  final bool status;
  final String message;
  final int responseCode;
  final String visitorToken;

  bool get hasVisitorToken => visitorToken.isNotEmpty;

  factory RegisterDeviceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final visitorToken = data is Map<String, dynamic>
        ? data['visitorToken'] as String? ?? ''
        : '';

    return RegisterDeviceResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      responseCode: json['responseCode'] as int? ?? 0,
      visitorToken: visitorToken,
    );
  }
}
