// lib/screens/cart_screen.dart
import 'dart:convert';
import 'package:flutter_app/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_config.dart';

import '../providers/shop_provider.dart';
import 'checkout_screen.dart';
import 'widgets/quantity_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;

  Future<void> _handleCheckout(ShopProvider provider) async {
    setState(() => _isCheckingOut = true);

    try {
      final checkoutPayload = provider.cart.map((item) {
        return {
          "variantId": item.product.variantId,
          "quantity": item.quantity,
        };
      }).toList();   

      final response = await http.post(
        AppConfig.checkoutEndpoint,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(checkoutPayload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String checkoutUrl = responseData['checkoutUrl'] ?? '';

        if (checkoutUrl.isNotEmpty && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(checkoutUrl: checkoutUrl),
            ),
          ).then((_) {
            // OPTIONAL: Clear the cart ONLY after the user returns from checkout
            provider.clearCart();
            // TODO: implement this correctly.
            // await provider.archiveCartToCompletedOrder("${totalPrice.toStringAsFixed(2)} HUF");
          });

        } else {
          throw Exception('Checkout URL was empty in response');
        }
        
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("CHECKOUT ERROR LOG: $e"); // Watch your terminal/debug console for this!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout failed. Check terminal error log.'),
            backgroundColor: AppTheme.errorColor
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context); 

    double totalPrice = shopProvider.cart.fold(0, (total, item) {
      final price = double.tryParse(item.product.price) ?? 0.0;
      return total + price * item.quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart Bag'),
      ),
      body: shopProvider.cart.isEmpty
          ? Center(
              child: Text(
                'Your cart is currently empty.\nGo add some mystery boxes!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                // style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: shopProvider.cart.length,
                    itemBuilder: (context, index) {
                      final item = shopProvider.cart[index];
                      final product = item.product;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (c, u, e) => const Icon(Icons.broken_image),
                            ),
                          ),
                          title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text('${((double.tryParse(product.price) ?? 0.0) * item.quantity).toStringAsFixed(2)} HUF'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              QuantitySelector(
                                value: item.quantity,
                                min: 1,
                                max: 99,
                                compact: true,
                                onChanged: (newQty) {
                                  shopProvider.updateQuantity(product.variantId, newQty);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
                                  shopProvider.removeFromCart(product.variantId);
                                },
                              ),
                            ],
                          )
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // const Text('Total Value:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            // Text('${totalPrice.toStringAsFixed(2)} HUF', style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                            Text('Total Value:', style: Theme.of(context).textTheme.titleMedium),
                            Text('${totalPrice.toStringAsFixed(2)} HUF', style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isCheckingOut 
                            ? null 
                            : () => _handleCheckout(shopProvider),
                          child: _isCheckingOut
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5, // Thinner spinner to look clean inside a button
                                ),
                              )
                            : const Text(
                                'PROCEED TO CHECKOUT', 
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
