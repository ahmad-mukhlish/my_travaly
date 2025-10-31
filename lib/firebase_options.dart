import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:my_travaly/src/config/environment_config.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: EnvironmentConfig.firebaseWebApiKey,
    appId: EnvironmentConfig.firebaseWebAppId,
    messagingSenderId: EnvironmentConfig.firebaseWebMessagingSenderId,
    projectId: EnvironmentConfig.firebaseWebProjectId,
    authDomain: EnvironmentConfig.firebaseWebAuthDomain,
    storageBucket: EnvironmentConfig.firebaseWebStorageBucket,
    measurementId: EnvironmentConfig.firebaseWebMeasurementId,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: EnvironmentConfig.firebaseAndroidApiKey,
    appId: EnvironmentConfig.firebaseAndroidAppId,
    messagingSenderId: EnvironmentConfig.firebaseAndroidMessagingSenderId,
    projectId: EnvironmentConfig.firebaseAndroidProjectId,
    storageBucket: EnvironmentConfig.firebaseAndroidStorageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: EnvironmentConfig.firebaseIosApiKey,
    appId: EnvironmentConfig.firebaseIosAppId,
    messagingSenderId: EnvironmentConfig.firebaseIosMessagingSenderId,
    projectId: EnvironmentConfig.firebaseIosProjectId,
    storageBucket: EnvironmentConfig.firebaseIosStorageBucket,
    androidClientId: EnvironmentConfig.firebaseIosAndroidClientId,
    iosClientId: EnvironmentConfig.firebaseIosClientId,
    iosBundleId: EnvironmentConfig.firebaseIosBundleId,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: EnvironmentConfig.firebaseMacosApiKey,
    appId: EnvironmentConfig.firebaseMacosAppId,
    messagingSenderId: EnvironmentConfig.firebaseMacosMessagingSenderId,
    projectId: EnvironmentConfig.firebaseMacosProjectId,
    storageBucket: EnvironmentConfig.firebaseMacosStorageBucket,
    iosClientId: EnvironmentConfig.firebaseMacosClientId,
    iosBundleId: EnvironmentConfig.firebaseMacosBundleId,
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: EnvironmentConfig.firebaseWindowsApiKey,
    appId: EnvironmentConfig.firebaseWindowsAppId,
    messagingSenderId: EnvironmentConfig.firebaseWindowsMessagingSenderId,
    projectId: EnvironmentConfig.firebaseWindowsProjectId,
    authDomain: EnvironmentConfig.firebaseWindowsAuthDomain,
    storageBucket: EnvironmentConfig.firebaseWindowsStorageBucket,
    measurementId: EnvironmentConfig.firebaseWindowsMeasurementId,
  );

}
