class DeviceRegister {
  const DeviceRegister({
    required this.deviceModel,
    required this.deviceFingerprint,
    required this.deviceBrand,
    required this.deviceId,
    required this.deviceName,
    required this.deviceManufacturer,
    required this.deviceProduct,
    required this.deviceSerialNumber,
  });

  final String deviceModel;
  final String deviceFingerprint;
  final String deviceBrand;
  final String deviceId;
  final String deviceName;
  final String deviceManufacturer;
  final String deviceProduct;
  final String deviceSerialNumber;

  factory DeviceRegister.fromJson(Map<String, dynamic> json) {
    return DeviceRegister(
      deviceModel: json['deviceModel'] as String? ?? '',
      deviceFingerprint: json['deviceFingerprint'] as String? ?? '',
      deviceBrand: json['deviceBrand'] as String? ?? '',
      deviceId: json['deviceId'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? '',
      deviceManufacturer: json['deviceManufacturer'] as String? ?? '',
      deviceProduct: json['deviceProduct'] as String? ?? '',
      deviceSerialNumber: json['deviceSerialNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceModel': deviceModel,
      'deviceFingerprint': deviceFingerprint,
      'deviceBrand': deviceBrand,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceManufacturer': deviceManufacturer,
      'deviceProduct': deviceProduct,
      'deviceSerialNumber': deviceSerialNumber,
    };
  }

  @override
  String toString() {
    return 'DeviceRegister('
        'deviceModel: $deviceModel, '
        'deviceFingerprint: $deviceFingerprint, '
        'deviceBrand: $deviceBrand, '
        'deviceId: $deviceId, '
        'deviceName: $deviceName, '
        'deviceManufacturer: $deviceManufacturer, '
        'deviceProduct: $deviceProduct, '
        'deviceSerialNumber: $deviceSerialNumber'
        ')';
  }
}
