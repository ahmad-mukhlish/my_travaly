import 'package:google_sign_in/google_sign_in.dart';
import 'device_register.dart';

class LoginUser {
  const LoginUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.deviceRegister,
    this.photoUrl,
  });

  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;
  final DeviceRegister? deviceRegister;

  factory LoginUser.create(GoogleSignInAccount account, DeviceRegister? deviceRegister) {
    return LoginUser(
      id: account.id,
      displayName: account.displayName ?? account.email,
      email: account.email,
      photoUrl: account.photoUrl,
      deviceRegister: deviceRegister,
    );
  }

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      deviceRegister: json['deviceRegister'] == null
          ? null
          : DeviceRegister.fromJson(
              Map<String, dynamic>.from(json['deviceRegister'] as Map),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'deviceRegister': deviceRegister?.toJson(),
    };
  }
}
