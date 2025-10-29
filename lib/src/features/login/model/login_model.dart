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
}
