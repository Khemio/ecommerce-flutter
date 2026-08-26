class AppConfig {
  // static const String baseUrl = "http://192.168.100.46:8080/api/v1"; 
  // static const String baseUrl = "http://127.0.0.1:8080/api/v1"; 
  // static const String baseUrl = "http://10.0.2.2:8080/api/v1"; 

  // 1. Look for a command-line flag named 'BASE_URL'. 
  // If it's missing, fall back to a safe default production url.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.100.46:8080/api/v1',
  );

  // Helper methods to programmatically construct your specific endpoints
  static Uri get productsEndpoint => Uri.parse("$baseUrl/products");
  static Uri get checkoutEndpoint => Uri.parse("$baseUrl/checkout");
}
