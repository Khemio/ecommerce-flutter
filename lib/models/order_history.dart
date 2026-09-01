import '../core/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  // final String selectedSize;

  CartItem({
    required this.product, 
    required this.quantity, 
    // required this.selectedSize,
  });

  // Convert model directly to a Map format for disk storage conversion
  Map<String, dynamic> toJson() => {
    'product': product.toJson(), // Assumes your Product model has a toJson() method
    'quantity': quantity,
    // 'selectedSize': selectedSize,
  };

  // Restore model parameters securely out of data strings
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      // selectedSize: json['selectedSize'] ?? 'M',
    );
  }
}

class OrderHistoryItem {
  final String orderId;
  final String timestamp;
  final String totalAmount;
  final List<CartItem> items;

  OrderHistoryItem({
    required this.orderId,
    required this.timestamp,
    required this.totalAmount,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'timestamp': timestamp,
    'totalAmount': totalAmount,
    'items': items.map((item) => item.toJson()).toList(),
  };

  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];
    List<CartItem> orderItemsList = list.map((i) => CartItem.fromJson(i)).toList();

    return OrderHistoryItem(
      orderId: json['orderId'] ?? '',
      timestamp: json['timestamp'] ?? '',
      totalAmount: json['totalAmount'] ?? '0.00',
      items: orderItemsList,
    );
  }
}
