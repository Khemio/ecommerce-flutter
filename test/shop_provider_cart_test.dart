import 'dart:convert';

import 'package:azkomoly_app/core/models/product.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ShopProvider provider;
  late Product product;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = ShopProvider();
    product = Product(
      id: 'gid://shopify/Product/123',
      title: 'Example box',
      description: '',
      productType: 'Boxes',
      vendor: 'Azkomoly',
      imageUrl: '',
      variantId: 'gid://shopify/ProductVariant/456',
      price: 100,
      sku: '',
      isAvailable: true,
    );
    // Allow the constructor's asynchronous storage load to complete.
    await SharedPreferences.getInstance();
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() {
    provider.dispose();
  });

  test('add, increment and update quantities by variant', () {
    provider.addToCart(product, 2);
    provider.addToCart(product, 3);

    expect(provider.cart.length, 1);
    expect(provider.cart.single.quantity, 5);
    expect(provider.cartCount, 5);

    provider.updateQuantity(product.variantId, 4);
    expect(provider.cart.single.quantity, 4);
    expect(provider.cartCount, 4);
  });

  test('zero quantity removes item instead of retaining a zero line', () async {
    provider.addToCart(product, 2);
    provider.updateQuantity(product.variantId, 0);

    expect(provider.cart, isEmpty);
    expect(provider.cartCount, 0);

    await Future<void>.delayed(const Duration(milliseconds: 20));
    final prefs = await SharedPreferences.getInstance();
    expect(jsonDecode(prefs.getString('user_cart_cache')!), isEmpty);
  });

  test('remove cancels pending save; persisted cart stays empty', () async {
    provider.addToCart(product, 2);
    provider.removeFromCart(product.variantId);

    // Wait past the original 1-second debounce interval.
    await Future<void>.delayed(const Duration(milliseconds: 1150));

    final prefs = await SharedPreferences.getInstance();
    expect(jsonDecode(prefs.getString('user_cart_cache')!), isEmpty);
  });

  test('clear cancels pending save; persisted cart stays empty', () async {
    provider.addToCart(product, 2);
    provider.clearCart();

    await Future<void>.delayed(const Duration(milliseconds: 1150));

    final prefs = await SharedPreferences.getInstance();
    expect(jsonDecode(prefs.getString('user_cart_cache')!), isEmpty);
  });
}
