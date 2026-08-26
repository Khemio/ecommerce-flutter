// lib/screens/cart_screen.dart
import 'dart:convert';
import 'package:flutter_app/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_config.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../providers/shop_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;

  // Simulate calling your proxy server to get a Shopify checkout URL
  Future<void> _handleCheckout(ShopProvider provider) async {
    setState(() => _isCheckingOut = true);

    try {
      // 1. Map your internal provider cart format directly to your API's expected payload
      final List<Map<String, dynamic>> checkoutPayload = provider.cart.map((item) {
        final product = item['product'];
        return {
          "variantId": product.variantId, // Pulls the exact variant ID from your model
          "quantity": item['quantity'],
        };
      }).toList();

      // 2. Fire the live POST request down to your proxy server
      final response = await http.post(
        AppConfig.checkoutEndpoint,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(checkoutPayload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 3. Extract the real checkoutUrl from the proxy response body
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String checkoutUrl = responseData['checkoutUrl'] ?? '';

        if (checkoutUrl.isNotEmpty && mounted) {
          // 4. Wipe your app memory cart track clean on successful handoff

          // 5. Instantly route the user into your functional Webview screen frame
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CheckoutScreen(checkoutUrl: checkoutUrl),
          ),
        ).then((_) {
          // OPTIONAL: Clear the cart ONLY after the user returns from checkout
          provider.clearCart();
        });

          // provider.clearCart();
        //   final Uri url = Uri.parse(checkoutUrl);
        //   if (await canLaunchUrl(url)) {
        //     // await launchUrl(url, mode: LaunchMode.externalApplication);
        //     await launchUrl(
        //       url, 
        //       mode: LaunchMode.platformDefault, // Default behavior handles web redirection smoothly
        //       webOnlyWindowName: '_self',       // Forces Chrome to load it in the active viewport
        //     );
        //   } else {
        //     throw 'Could not open checkout page link $checkoutUrl';
        //   }
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
            // behavior: SnackBarBehavior.floating, 
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // We listen to changes here to redraw totals dynamically
    final shopProvider = Provider.of<ShopProvider>(context); 
    
    // Calculate the total basket value
    double totalPrice = 0;
    for (var item in shopProvider.cart) {
      final product = item['product'];
      final double priceParsed = double.tryParse(product.price) ?? 0.0;
      totalPrice += priceParsed * item['quantity'];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart Bag'),
      ),
      body: shopProvider.cart.isEmpty
          ? const Center(
              child: Text(
                'Your cart is currently empty.\nGo add some mystery boxes!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // 1. Dynamic Shopping Cart List View
                Expanded(
                  child: ListView.builder(
                    itemCount: shopProvider.cart.length,
                    itemBuilder: (context, index) {
                      final item = shopProvider.cart[index];
                      final product = item['product'];
                      final quantity = item['quantity'];

                      // TODO: Add quantity selector
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
                          subtitle: Text('Quantity: $quantity | ${(double.tryParse(product.price) ?? 0.0) * quantity} HUF'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              // Access provider directly without a listener to perform the deletion
                              setState(() {
                                shopProvider.cart.removeAt(index);
                              });
                            },
                          ),
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
