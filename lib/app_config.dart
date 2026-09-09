class AppConfig {
  static const String apiVer = 'v1';

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.100.46:8080',
  );


  // Helper methods to programmatically construct your specific endpoints
  static Uri get productsEndpoint => Uri.parse("$baseUrl/api/$apiVer/products");
  static Uri get checkoutEndpoint => Uri.parse("$baseUrl/api/$apiVer/checkout");
  static Uri get configEndpoint => Uri.parse("$baseUrl/api/$apiVer/config");
}
