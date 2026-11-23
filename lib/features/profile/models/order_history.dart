import 'package:azkomoly_app/core/models/remote_order.dart';
import 'package:azkomoly_app/core/utils/num_extentions.dart';

import '../../../core/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  // Convert model directly to a Map format for disk storage conversion
  Map<String, dynamic> toJson() => {
    'product': product
        .toJson(), // Assumes your Product model has a toJson() method
    'quantity': quantity,
  };

  // Restore model parameters securely out of data strings
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  CartItem copyWith({double? price, int? quantity}) {
    return CartItem(
      product: price == null ? product : product.copyWith(price: price),
      quantity: quantity ?? this.quantity,
    );
  }
}

class OrderHistoryItem {
  final String orderId;
  final String orderName;
  final String orderNumber;
  final String confirmationNumber;
  final String currency;
  final String totalAmount;
  final List<CartItem> items;

  OrderHistoryItem({
    required this.orderId,
    required this.orderName,
    required this.orderNumber,
    required this.confirmationNumber,
    required this.currency,
    required this.totalAmount,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'orderName': orderName,
    'orderNumber': orderNumber,
    'confirmationNumber': confirmationNumber,
    'currency': currency,
    'totalAmount': totalAmount,
    'items': items.map((item) => item.toJson()).toList(),
  };

  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];
    List<CartItem> orderItemsList = list
        .map((i) => CartItem.fromJson(i))
        .toList();

    return OrderHistoryItem(
      orderId: json['orderId'] ?? '',
      orderName: json['orderName'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      confirmationNumber: json['confirmationNumber'] ?? '',
      currency: json['currency'] ?? 'HUF',
      totalAmount: json['totalAmount'] ?? '0.00',
      items: orderItemsList,
    );
  }

  factory OrderHistoryItem.fromOrder({
    required RemoteOrder order,
    required List<CartItem> cart,
  }) {
    final lineItems = order.lineItems;

    final items = cart
        .where((item) => lineItems.containsKey(item.product.id))
        .map((item) {
          final remoteVals = lineItems[item.product.id]!;

          // Check if updates are needed to avoid redundant object creation
          final priceChanged = item.product.price != remoteVals.price;
          final quantityChanged = item.quantity != remoteVals.quantity;

          if (priceChanged || quantityChanged) {
            // Use copyWith to handle final fields safely
            return item.copyWith(
              price: remoteVals.price, // Passes down to product.copyWith
              quantity: remoteVals.quantity,
            );
          }

          return item; // Return original item if nothing changed
        })
        .toList();

    double totalPrice = items.fold(0, (total, item) {
      final price = item.product.price;
      return total + price * item.quantity;
    });

    String totalAmount = totalPrice.toPrice(currency: 'HUF');
    // var list = json['items'] as List? ?? [];
    // List<CartItem> orderItemsList = list.map((i) => CartItem.fromJson(i)).toList();

    // var currency = json['currency'] ?? 'HUF';

    return OrderHistoryItem(
      orderId: order.orderId.toString(),
      orderName: order.orderName,
      orderNumber: order.orderNumber.toString(),
      confirmationNumber: order.confirmationNumber,
      currency: order.currency,
      totalAmount: totalAmount,
      items: items,
    );
  }
}
