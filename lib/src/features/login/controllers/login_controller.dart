import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_routes.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  LoginController({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: const ['email']);

  final GoogleSignIn _googleSignIn;

  final RxBool isSigningIn = false.obs;
  final Rxn<LoginUser> user = Rxn<LoginUser>();

  Future<void> signInWithGoogle() async {
    try {
      isSigningIn.value = true;
      final account = await _googleSignIn.signIn();
      if (account == null) {
        Get.snackbar(
          'Sign in cancelled',
          'You cancelled the Google sign in flow.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      user.value = LoginUser.fromGoogleAccount(account);
      Get.offAllNamed(AppRoutes.dashboard);
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
      await _googleSignIn.signOut();
    } finally {
      user.value = null;
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }
}
