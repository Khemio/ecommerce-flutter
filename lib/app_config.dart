class AppConfig {
  static const String apiVer = 'v1';

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8080',
  );


  // The proxy currently has no /config endpoint. Opt in only with a compatible API.
  static const bool enableRemoteConfig = bool.fromEnvironment('ENABLE_REMOTE_CONFIG');

  // Helper methods to programmatically construct your specific endpoints
  static Uri get productsEndpoint => Uri.parse("$baseUrl/api/$apiVer/products");
  static Uri get checkoutEndpoint => Uri.parse("$baseUrl/api/$apiVer/checkout");
  static Uri get configEndpoint => Uri.parse("$baseUrl/api/$apiVer/config");
  static Uri get orderEndpoint => Uri.parse("$baseUrl/api/$apiVer/events");
}
