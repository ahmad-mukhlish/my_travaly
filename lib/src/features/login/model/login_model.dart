import 'package:google_sign_in/google_sign_in.dart';

class LoginUser {
  const LoginUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;

  factory LoginUser.fromGoogleAccount(GoogleSignInAccount account) {
    return LoginUser(
      id: account.id,
      displayName: account.displayName ?? account.email,
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }
}
