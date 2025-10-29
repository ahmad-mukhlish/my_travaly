/// Provides access to compile-time environment values supplied via `--dart-define`.
class EnvironmentConfig {
  const EnvironmentConfig._();

  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  /// Authentication token supplied at build time.
  static const String authToken =
      String.fromEnvironment('AUTH_TOKEN', defaultValue: '');

  static bool get hasAuthToken => authToken.isNotEmpty;
  static bool get hasApiBaseUrl => apiBaseUrl.isNotEmpty;
}
