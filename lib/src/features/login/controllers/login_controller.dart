import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_travaly/src/features/login/model/device_register.dart';
import 'package:my_travaly/src/routes/app_routes.dart';
import 'package:my_travaly/src/services/auth/auth_storage_service.dart';

import '../model/login_model.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final RxBool isSigningIn = false.obs;
  final Rxn<LoginUser> user = Rxn<LoginUser>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isInitialize = false;

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

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

      final DeviceRegister deviceRegister = await getDeviceRegister;
      user.value = LoginUser.create(account, deviceRegister);

      if (user.value != null) {
        await AuthStorageService.to.saveUser(user.value!);
      }

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
      await AuthStorageService.to.clearUser();
      user.value = null;
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  Future<DeviceRegister> get getDeviceRegister async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return DeviceRegister(
        deviceModel: androidInfo.model,
        deviceFingerprint: androidInfo.fingerprint,
        deviceBrand: androidInfo.brand,
        deviceId: androidInfo.device,
        deviceName: androidInfo.name,
        deviceManufacturer: androidInfo.manufacturer,
        deviceProduct: androidInfo.product,
        deviceSerialNumber: androidInfo.id,
      );
    }

    if (GetPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return DeviceRegister(
        deviceModel: iosInfo.model,
        deviceFingerprint: '${iosInfo.systemName } ${iosInfo.systemVersion}'
            .trim(),
        deviceBrand: 'Apple',
        deviceId: iosInfo.identifierForVendor ?? '',
        deviceName: iosInfo.name,
        deviceManufacturer: 'Apple',
        deviceProduct: iosInfo.localizedModel,
        deviceSerialNumber: iosInfo.identifierForVendor ?? '',
      );
    }

    return DeviceRegister(
      deviceModel: '-',
      deviceFingerprint: '-',
      deviceBrand: '-',
      deviceId: '-',
      deviceName: '-',
      deviceManufacturer: '-',
      deviceProduct: '-',
      deviceSerialNumber: '-',
    );
  }

  Future<void> _restoreSession() async {
    final storedUser = AuthStorageService.to.currentUser ?? await AuthStorageService.to.loadUser();
    user.value = storedUser;
  }

  Future<GoogleSignInAccount?> _signInWithGoogle() async {
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

      _auth.signInWithCredential(credential);
      return googleUser;
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
