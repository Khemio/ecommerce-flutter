import 'package:azkomoly_app/core/models/remote_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final event = <String, dynamic>{
    'order_id': '123',
    'order_name': '#1001',
    'order_number': 1001,
    'confirmation_number': 'ABC123',
    'total_price': '5000.00',
    'currency': 'HUF',
    'line_items': [
      {
        'product_id': '100',
        'variant_id': '200',
        'title': 'Example',
        'quantity': 2,
        'price': '2500.00',
      },
    ],
  };

  test('parses a complete order event', () {
    final order = RemoteOrder.fromJson(event);
    expect(order.isValid, isTrue);
    expect(order.orderNumber, 1001);
    expect(order.lineItems['100']!.quantity, 2);
  });

  test('missing confirmation invalidates an otherwise valid event', () {
    final order = RemoteOrder.fromJson({...event, 'confirmation_number': ''});
    expect(order.isValid, isFalse);
  });

  test('missing line items invalidates an order', () {
    final order = RemoteOrder.fromJson({
      ...event,
      'line_items': <Map<String, dynamic>>[],
    });
    expect(order.isValid, isFalse);
  });
}
