class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.100.46:8080/api/v1',
  );

  // Helper methods to programmatically construct your specific endpoints
  static Uri get productsEndpoint => Uri.parse("$baseUrl/products");
  static Uri get checkoutEndpoint => Uri.parse("$baseUrl/checkout");
}
