import 'package:azkomoly_app/core/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final apiProduct = <String, dynamic>{
    'id': 'gid://shopify/Product/123',
    'title': 'Example box',
    'description': 'Sample product',
    'productType': 'Boxes',
    'vendor': 'Azkomoly',
    'availableForSale': true,
    'images': [
      {'url': 'https://example.com/image.png'},
    ],
    'variants': [
      {
        'id': 'gid://shopify/ProductVariant/456',
        'sku': null,
        'price': {'amount': '12900.00'},
      },
    ],
  };

  test('decodes Shopify product fields and nullable SKU', () {
    final product = Product.fromJson(apiProduct);

    expect(product.id, '123');
    expect(product.variantId, '456');
    expect(product.vendor, 'Azkomoly');
    expect(product.sku, '');
    expect(product.price, 12900);
    expect(product.isAvailable, isTrue);
  });

  test('accepts numeric price and roundtrips local cache JSON', () {
    final product = Product.fromJson({
      ...apiProduct,
      'variants': [
        {
          'id': 'gid://shopify/ProductVariant/456',
          'sku': 'BOX-1',
          'price': {'amount': 50},
        },
      ],
    });

    final restored = Product.fromJson(product.toJson());
    expect(restored.price, 50);
    expect(restored.sku, 'BOX-1');
    expect(restored.idLink, product.idLink);
    expect(restored.isAvailable, isTrue);
  });

  test('missing images, variants and availability are safe', () {
    final product = Product.fromJson({'title': 'No stock'});

    expect(product.id, '');
    expect(product.variantId, '');
    expect(product.imageUrl, '');
    expect(product.price, 0);
    expect(product.isAvailable, isFalse);
  });
}
