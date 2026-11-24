import 'dart:convert';

import 'package:azkomoly_app/core/models/product.dart';
import 'package:azkomoly_app/features/cart/checkout_api.dart';
import 'package:azkomoly_app/features/profile/models/order_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final endpoint = Uri.parse('http://localhost:8080/api/v1/checkout');
  final product = Product(
    id: 'gid://shopify/Product/100',
    title: 'Example item',
    description: '',
    productType: 'Boxes',
    vendor: 'Azkomoly',
    imageUrl: '',
    variantId: 'gid://shopify/ProductVariant/200',
    price: 1500,
    sku: '',
    isAvailable: true,
  );

  final cart = [CartItem(product: product, quantity: 2)];

  test(
    'creates a hosted checkout session and sends the expected payload',
    () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url, endpoint);
        expect(request.headers['Content-Type'], 'application/json');
        expect(jsonDecode(request.body), [
          {'variantId': '200', 'quantity': 2},
        ]);

        return http.Response(
          jsonEncode({
            'sessionId': 'session-123',
            'checkoutUrl': 'https://store.myshopify.com/checkouts/123',
          }),
          200,
        );
      });

      final api = CheckoutApi(client: client, endpoint: endpoint);
      final session = await api.createCheckout(cart);
      expect(session.sessionId, 'session-123');
      expect(session.checkoutUrl, 'https://store.myshopify.com/checkouts/123');
      api.close();
      client.close();
    },
  );

  test('rejects failed checkout responses', () async {
    final client = MockClient((_) async => http.Response('unavailable', 503));
    final api = CheckoutApi(client: client, endpoint: endpoint);

    await expectLater(
      api.createCheckout(cart),
      throwsA(isA<CheckoutException>()),
    );
    api.close();
    client.close();
  });

  test('rejects malformed JSON', () async {
    final client = MockClient((_) async => http.Response('{broken', 200));
    final api = CheckoutApi(client: client, endpoint: endpoint);

    await expectLater(
      api.createCheckout(cart),
      throwsA(isA<CheckoutException>()),
    );
    api.close();
    client.close();
  });

  test('rejects a missing checkout session identifier', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({
          'checkoutUrl': 'https://store.myshopify.com/checkouts/123',
        }),
        200,
      ),
    );
    final api = CheckoutApi(client: client, endpoint: endpoint);

    await expectLater(
      api.createCheckout(cart),
      throwsA(isA<CheckoutException>()),
    );
    api.close();
    client.close();
  });

  test('rejects malformed or insecure checkout URLs', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({
          'sessionId': 'session-123',
          'checkoutUrl': 'http://store.myshopify.com/checkouts/123',
        }),
        200,
      ),
    );
    final api = CheckoutApi(client: client, endpoint: endpoint);

    await expectLater(
      api.createCheckout(cart),
      throwsA(isA<CheckoutException>()),
    );
    api.close();
    client.close();
  });

  test('rejects empty carts without sending a request', () async {
    final client = MockClient((_) async {
      fail('No request should be sent for an empty cart');
    });
    final api = CheckoutApi(client: client, endpoint: endpoint);

    await expectLater(
      api.createCheckout([]),
      throwsA(isA<CheckoutException>()),
    );
    api.close();
    client.close();
  });

  test('rejects invalid quantities without sending a request', () async {
    final client = MockClient((_) async {
      fail('No request should be sent for invalid items');
    });
    final api = CheckoutApi(client: client, endpoint: endpoint);

    await expectLater(
      api.createCheckout([CartItem(product: product, quantity: 0)]),
      throwsA(isA<CheckoutException>()),
    );
    api.close();
    client.close();
  });
}
