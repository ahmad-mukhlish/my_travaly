import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, GoogleAuthProvider, FirebaseAuthException, UserCredential, OAuthCredential;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_travaly/src/routes/app_routes.dart';


import '../model/login_model.dart';

class LoginController extends GetxController {


  final GoogleSignIn _googleSignIn  = GoogleSignIn.instance;

  final RxBool isSigningIn = false.obs;
  final Rxn<LoginUser> user = Rxn<LoginUser>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isInitialize = false;
  Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(
        serverClientId:
        '888304855609-drd35dnact3jb0fhvqb018artc042on4.apps.googleusercontent.com',
      );
    }
    isInitialize = true;
  }

  signInWithGoogle() async {
    try {
      isSigningIn.value = true;
      final account = await _signInWithGoogle();
      if (account == null) {
        Get.snackbar(
          'Sign in cancelled',
          'You cancelled the Google sign in flow.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // user.value = LoginUser.fromGoogleAccount(account);
      Get.toNamed(AppRoutes.dashboard);
    } catch (error) {
      Get.snackbar(
        'Sign in failed',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _signOut();
    } finally {
      user.value = null;
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  Future<OAuthCredential?> _signInWithGoogle() async {
    try {
      initSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;

      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;
      if (accessToken == null) {
        final authorization2 = await authorizationClient.authorizationForScopes(
          ['email', 'profile'],
        );
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(code: "error", message: "error");
        }
        authorization = authorization2;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      return credential;

    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error signing in: $e \n $stacktrace');
      }
      rethrow;
    }
  }

  _signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error signing out: $e \n $stacktrace');
      }
      rethrow;
    }
  }
}
