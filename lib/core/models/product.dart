/// First-variant product representation returned by ecommerce-proxy.
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
    required String id,
    required this.title,
    required this.description,
    required this.productType,
    required this.vendor,
    required this.imageUrl,
    required String variantId,
    required this.price,
    required this.sku,
    required this.isAvailable,
  }) : _id = id, _variantId = variantId;

  static String _lastPathSegment(String value) {
    final segments = Uri.tryParse(value)?.pathSegments;
    return segments == null || segments.isEmpty ? value : segments.last;
  }

  String get id => _lastPathSegment(_id);
  String get idLink => _id;
  String get variantId => _lastPathSegment(_variantId);
  String get variantIdLink => _variantId;

  Map<String, dynamic> toJson() => {
    'id': _id,
    'title': title,
    'description': description,
    'productType': productType,
    'vendor': vendor,
    'availableForSale': isAvailable,
    'images': [{'url': imageUrl}],
    'variants': [{
      'id': _variantId,
      'sku': sku,
      'price': {'amount': price.toStringAsFixed(2)},
    }],
  };

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    final variants = json['variants'];
    final Map<dynamic, dynamic> firstImage =
        images is List && images.isNotEmpty && images.first is Map
            ? images.first as Map : const {};
    final Map<dynamic, dynamic> firstVariant =
        variants is List && variants.isNotEmpty && variants.first is Map
            ? variants.first as Map : const {};
    final rawPrice = firstVariant['price'];
    final amount = rawPrice is Map ? rawPrice['amount'] : null;
    return Product(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unnamed Product',
      description: json['description']?.toString() ?? '',
      productType: json['productType']?.toString() ?? '',
      vendor: json['vendor']?.toString() ?? '',
      imageUrl: firstImage['url']?.toString() ?? '',
      variantId: firstVariant['id']?.toString() ?? '',
      price: double.tryParse(amount?.toString() ?? '') ?? 0.0,
      sku: firstVariant['sku']?.toString() ?? '',
      isAvailable: json['availableForSale'] == true,
    );
  }

  Product copyWith({double? price}) => Product(
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
