class RemoteOrder {
  // final int orderId;
  final String orderId;
  final String orderName;
  final int orderNumber;
  final String confirmationNumber;
  final double totalPrice;
  final String currency;
  final Map<String, LineItem> lineItems;
  final bool _isValid;

  const RemoteOrder({
    required this.orderId,
    required this.orderName,
    required this.orderNumber,
    required this.confirmationNumber,
    required this.totalPrice,
    required this.currency,
    required this.lineItems,
    required bool isValid,
  }) : _isValid = isValid;

  bool get isValid => _isValid;

  factory RemoteOrder.fromJson(Map<String, dynamic> json) {
    var dataIsValid = true;

    final orderId = json['order_id']?.toString() ?? '';

    final orderName = json['order_name']?.toString() ?? '';
    dataIsValid = dataIsValid && orderId.isNotEmpty && orderName.isNotEmpty;

    final orderNumber = json['order_number'] is int
        ? json['order_number'] as int
        : int.tryParse(json['order_number']?.toString() ?? '') ?? 0;
    dataIsValid = dataIsValid && orderNumber != 0;

    final confirmationNumber = json['confirmation_number']?.toString() ?? '';
    dataIsValid = dataIsValid && confirmationNumber.isNotEmpty;

    final totalPrice = json['total_price'] is num
        ? (json['total_price'] as num).toDouble()
        : double.tryParse(json['total_price']?.toString() ?? '') ?? 0.0;
    dataIsValid = dataIsValid && totalPrice > 0;

    final currency = json['currency']?.toString() ?? '';
    dataIsValid = dataIsValid && currency.isNotEmpty;

    final lineItemsJson =
        (json['line_items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final Map<String, LineItem> lineItems = {
      for (final item in lineItemsJson)
        item['product_id']?.toString() ?? '': LineItem.fromJson(item),
    };
    dataIsValid =
        dataIsValid &&
        lineItems.isNotEmpty &&
        lineItems.keys.every((id) => id.isNotEmpty) &&
        lineItems.values.every(
          (item) =>
              item.quantity > 0 && item.price >= 0 && item.variantId.isNotEmpty,
        );

    return RemoteOrder(
      orderId: orderId,
      orderName: orderName,
      orderNumber: orderNumber,
      confirmationNumber: confirmationNumber,
      totalPrice: totalPrice,
      currency: currency,
      lineItems: lineItems,
      isValid: dataIsValid,
    );
  }

  @override
  String toString() {
    final out = StringBuffer();

    out.writeln('OrderId: $orderId');
    out.writeln('Order Name: $orderName');
    out.writeln('Order Number: $orderNumber');
    out.writeln('Confirmation Number: $confirmationNumber');
    out.writeln('Total Price: $totalPrice');
    out.writeln('Currency: $currency');
    out.writeln('Line Items: ');
    for (final itemKey in lineItems.keys) {
      out.writeln('itemKey: $itemKey');
      out.writeln(lineItems[itemKey].toString());
    }

    return out.toString().trimRight();
  }
}

class LineItem {
  final String productId;
  final String variantId;
  final String title;
  final int quantity;
  final double price;

  LineItem({
    required this.quantity,
    required this.price,
    required this.productId,
    required this.variantId,
    required this.title,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    final productId = json['product_id']?.toString() ?? '';
    final variantId = json['variant_id']?.toString() ?? '';
    final title = json['title']?.toString() ?? '';
    final quantity = json['quantity'] is int
        ? json['quantity'] as int
        : int.tryParse(json['quantity']?.toString() ?? '') ?? 0;
    final price = json['price'] is num
        ? (json['price'] as num).toDouble()
        : double.tryParse(json['price']?.toString() ?? '') ?? 0.0;

    return LineItem(
      productId: productId,
      variantId: variantId,
      title: title,
      quantity: quantity,
      price: price,
    );
  }

  @override
  String toString() {
    final out = StringBuffer();
    out.writeln('Product ID: $productId');
    out.writeln('Variant ID: $variantId');
    out.writeln('Title: $title');
    out.writeln('Item Price: $price');
    out.writeln('Item Quantity: $quantity');

    return out.toString().trimRight();
  }
}
