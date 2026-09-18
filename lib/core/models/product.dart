class Product {
  final String _id;
  final String title;
  final String description;
  final String productType;
  final String vendor;
  final String imageUrl;
  final String _variantId;
  final double price;
  final String sku;
  final bool isAvailable;

  Product({
    required this._id,
    required this.title,
    required this.description,
    required this.productType,
    required this.vendor,
    required this.imageUrl,
    required this._variantId,
    required this.price,
    required this.sku, 
    required this.isAvailable,
  });

  String get id => Uri.parse(_id).pathSegments.last;
  String get idLink => _id;

  String get variantId => Uri.parse(_variantId).pathSegments.last;
  String get variantIdLink => _variantId;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'title': title,
      'description': description,
      'productType': productType,
      'vendor': vendor,
      'availableForSale': isAvailable,
      // Wrap your url back inside an array maps tree block
      'images': [
        {'url': imageUrl}
      ],
      // Re-nest your single variants values to look like Shopify GraphQL structures
      'variants': [
        {
          'id': _variantId,
          'sku': sku,
          'price': {
            'amount': price,
          }
        }
      ]
    };
  }

  // Map the JSON keys cleanly to flat properties your UI can read effortlessly
  factory Product.fromJson(Map<String, dynamic> json) {
    // Safely extract the first image URL or fall back to an empty placeholder string
    final List<dynamic> imagesList = json['images'] ?? [];
    final String firstImageUrl = imagesList.isNotEmpty ? imagesList[0]['url'] ?? '' : '';

    // Safely pull variables out of the first available product variant item
    final List<dynamic> variantsList = json['variants'] ?? [];
    String varId = '';
    double itemPrice = 0.0;
    String itemSku = '';
    // bool availableStatus = true;

    if (variantsList.isNotEmpty) {
      final Map<String, dynamic> firstVariant = variantsList[0] ?? {};
      varId = firstVariant['id'] ?? '';
      itemSku = firstVariant['sku'] ?? '';
      
      // availableStatus = firstVariant['availableForSale'] ?? firstVariant['isAvailable'] ?? true;
      final Map<String, dynamic> priceMap = firstVariant['price'] ?? {};
      final String itemPriceString = priceMap['amount'] ?? '0.00';
      itemPrice = double.tryParse(itemPriceString) ?? 0.0;
    }
      // availableStatus = firstVariant['availableForSale'] ?? firstVariant['isAvailable'] ?? true;

    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unnamed Product',
      description: json['description'] ?? '',
      productType: json['productType'] ?? '',
      vendor: json['vendor'] ?? '',
      imageUrl: firstImageUrl,
      variantId: varId,
      price: itemPrice,
      sku: itemSku,
      isAvailable: json['availableForSale'],
      // isAvailable: availableStatus,
    );
  }

  Product copyWith({double? price}) {
    return Product(
      id: _id,
      title: title,
      description: description,
      productType: productType,
      vendor: vendor,
      imageUrl: imageUrl,
      variantId: _variantId,
      price: price ?? this.price,
      sku: sku,
      isAvailable: isAvailable,
    );
  }
}