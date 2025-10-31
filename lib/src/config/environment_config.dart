/// Provides access to compile-time environment values supplied via `--dart-define`.
class EnvironmentConfig {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String authToken = String.fromEnvironment('AUTH_TOKEN');
  static const String googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

  static const String firebaseWebApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const String firebaseWebAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
  static const String firebaseWebMessagingSenderId = String.fromEnvironment('FIREBASE_WEB_MESSAGING_SENDER_ID');
  static const String firebaseWebProjectId = String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
  static const String firebaseWebAuthDomain = String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
  static const String firebaseWebStorageBucket = String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET');
  static const String firebaseWebMeasurementId = String.fromEnvironment('FIREBASE_WEB_MEASUREMENT_ID');

  static const String firebaseAndroidApiKey = String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
  static const String firebaseAndroidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
  static const String firebaseAndroidMessagingSenderId = String.fromEnvironment('FIREBASE_ANDROID_MESSAGING_SENDER_ID');
  static const String firebaseAndroidProjectId = String.fromEnvironment('FIREBASE_ANDROID_PROJECT_ID');
  static const String firebaseAndroidStorageBucket = String.fromEnvironment('FIREBASE_ANDROID_STORAGE_BUCKET');

  static const String firebaseIosApiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY');
  static const String firebaseIosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const String firebaseIosMessagingSenderId = String.fromEnvironment('FIREBASE_IOS_MESSAGING_SENDER_ID');
  static const String firebaseIosProjectId = String.fromEnvironment('FIREBASE_IOS_PROJECT_ID');
  static const String firebaseIosStorageBucket = String.fromEnvironment('FIREBASE_IOS_STORAGE_BUCKET');
  static const String firebaseIosAndroidClientId = String.fromEnvironment('FIREBASE_IOS_ANDROID_CLIENT_ID');
  static const String firebaseIosClientId = String.fromEnvironment('FIREBASE_IOS_CLIENT_ID');
  static const String firebaseIosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');

  static const String firebaseMacosApiKey = String.fromEnvironment('FIREBASE_MACOS_API_KEY');
  static const String firebaseMacosAppId = String.fromEnvironment('FIREBASE_MACOS_APP_ID');
  static const String firebaseMacosMessagingSenderId = String.fromEnvironment('FIREBASE_MACOS_MESSAGING_SENDER_ID');
  static const String firebaseMacosProjectId = String.fromEnvironment('FIREBASE_MACOS_PROJECT_ID');
  static const String firebaseMacosStorageBucket = String.fromEnvironment('FIREBASE_MACOS_STORAGE_BUCKET');
  static const String firebaseMacosClientId = String.fromEnvironment('FIREBASE_MACOS_CLIENT_ID');
  static const String firebaseMacosBundleId = String.fromEnvironment('FIREBASE_MACOS_BUNDLE_ID');

  static const String firebaseWindowsApiKey = String.fromEnvironment('FIREBASE_WINDOWS_API_KEY');
  static const String firebaseWindowsAppId = String.fromEnvironment('FIREBASE_WINDOWS_APP_ID');
  static const String firebaseWindowsMessagingSenderId = String.fromEnvironment('FIREBASE_WINDOWS_MESSAGING_SENDER_ID');
  static const String firebaseWindowsProjectId = String.fromEnvironment('FIREBASE_WINDOWS_PROJECT_ID');
  static const String firebaseWindowsAuthDomain = String.fromEnvironment('FIREBASE_WINDOWS_AUTH_DOMAIN');
  static const String firebaseWindowsStorageBucket = String.fromEnvironment('FIREBASE_WINDOWS_STORAGE_BUCKET');
  static const String firebaseWindowsMeasurementId = String.fromEnvironment('FIREBASE_WINDOWS_MEASUREMENT_ID');
}
