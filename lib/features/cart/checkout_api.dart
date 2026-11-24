import 'dart:async';
import 'dart:convert';

import 'package:azkomoly_app/app_config.dart';
import 'package:azkomoly_app/features/profile/models/order_history.dart';
import 'package:http/http.dart' as http;

/// The proxy's hosted-checkout session, not a verified paid order.
class CheckoutSession {
  final String sessionId;
  final String checkoutUrl;

  const CheckoutSession({required this.sessionId, required this.checkoutUrl});
}

class CheckoutException implements Exception {
  final String message;

  const CheckoutException(this.message);

  @override
  String toString() => 'CheckoutException: $message';
}

/// Small, testable HTTP boundary for creating a Shopify hosted checkout.
///
/// This only creates a checkout URL/session. It does not verify payment.
class CheckoutApi {
  final http.Client _client;
  final bool _ownsClient;
  final Uri endpoint;

  CheckoutApi({http.Client? client, Uri? endpoint})
    : _client = client ?? http.Client(),
      _ownsClient = client == null,
      endpoint = endpoint ?? AppConfig.checkoutEndpoint;

  Future<CheckoutSession> createCheckout(List<CartItem> items) async {
    if (items.isEmpty ||
        items.any(
          (item) => item.quantity <= 0 || item.product.variantId.trim().isEmpty,
        )) {
      throw const CheckoutException('Cart must contain valid items');
    }

    final payload = items
        .map(
          (item) => {
            'variantId': item.product.variantId,
            'quantity': item.quantity,
          },
        )
        .toList();

    try {
      final response = await _client
          .post(
            endpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw CheckoutException(
          'Checkout request failed (HTTP ${response.statusCode})',
        );
      }

      final Object? decoded;
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw const CheckoutException('Invalid checkout response JSON');
      }

      if (decoded is! Map<String, dynamic>) {
        throw const CheckoutException('Invalid checkout response object');
      }

      final sessionId = decoded['sessionId'];
      final checkoutUrl = decoded['checkoutUrl'];
      if (sessionId is! String ||
          sessionId.trim().isEmpty ||
          checkoutUrl is! String ||
          checkoutUrl.trim().isEmpty) {
        throw const CheckoutException('Checkout session or URL is missing');
      }

      final uri = Uri.tryParse(checkoutUrl);
      if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
        throw const CheckoutException('Checkout URL must use HTTPS');
      }

      return CheckoutSession(sessionId: sessionId, checkoutUrl: checkoutUrl);
    } on TimeoutException {
      throw const CheckoutException('Checkout request timed out');
    }
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}
