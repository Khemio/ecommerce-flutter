import 'dart:convert';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/features/cart/widgets/cart_items_list.dart';
import 'package:flutter_app/features/cart/widgets/clear_cart_btn.dart';
import 'package:flutter_app/features/cart/widgets/summary_panel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_config.dart';

import '../../app_localizations.dart';
import '../../core/providers/shop_provider.dart';
import 'checkout_screen.dart';

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

        //? Look throught this, cleanup should probably be after successful checkout with date from proxy
        if (checkoutUrl.isNotEmpty && mounted) {
          await provider.archiveCartToCompletedOrder();
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(checkoutUrl: checkoutUrl),
            ),
          ).then((_) {
            // OPTIONAL: Clear the cart ONLY after the user returns from checkout
            // provider.clearCart();
            // await provider.archiveCartToCompletedOrder();
            // await provider.archiveCartToCompletedOrder("${totalPrice.toStringAsFixed(2)} HUF");
          });

        } else {
          throw Exception('Checkout URL was empty in response');
        }
        
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("CHECKOUT ERROR LOG: $e"); // Watch your terminal/debug console for this!
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
        title: Text(AppLocalizations.translate('cart_title', shopProvider.appLanguage)),
        actions: [
          if (shopProvider.cart.isNotEmpty) ClearCartBtn(),
          const SizedBox(width: 8),
        ],
      ),
      body: shopProvider.cart.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.translate('cart_empty', shopProvider.appLanguage),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                // style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : Column(
              children: [
                CartItemsList(
                  totalPrice: totalPrice, 
                ),

                SummaryPanel(
                  isCheckingOut: _isCheckingOut, 
                  totalPrice: totalPrice, 
                  onCheckoutPressed: _handleCheckout
                ),
              ],
            ),
    );
  }
}
