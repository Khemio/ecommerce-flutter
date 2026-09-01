class Product {
  final String id;
  final String title;
  final String description;
  final String productType;
  final String imageUrl;
  final String variantId;
  final String price;
  final String sku;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.productType,
    required this.imageUrl,
    required this.variantId,
    required this.price,
    required this.sku,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'productType': productType,
      // Wrap your url back inside an array maps tree block
      'images': [
        {'url': imageUrl}
      ],
      // Re-nest your single variants values to look like Shopify GraphQL structures
      'variants': [
        {
          'id': variantId,
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
    String itemPrice = '0.00';
    String itemSku = '';

    if (variantsList.isNotEmpty) {
      final Map<String, dynamic> firstVariant = variantsList[0] ?? {};
      varId = firstVariant['id'] ?? '';
      itemSku = firstVariant['sku'] ?? '';
      
      final Map<String, dynamic> priceMap = firstVariant['price'] ?? {};
      itemPrice = priceMap['amount'] ?? '0.00';
    }

    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unnamed Product',
      description: json['description'] ?? '',
      productType: json['productType'] ?? '',
      imageUrl: firstImageUrl,
      variantId: varId,
      price: itemPrice,
      sku: itemSku,
    );
  }
}