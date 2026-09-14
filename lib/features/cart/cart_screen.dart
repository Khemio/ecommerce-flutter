import 'dart:convert';
import 'package:azkomoly_app/core/utils/uri_extentions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:azkomoly_app/app_config.dart';
import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/app_theme.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';

import 'cart.dart' show CheckoutScreen, ClearCartBtn, CartItemsList, SummaryPanel;


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
        final String sessionId = responseData['sessionId'] ?? '';
        final String rawCheckoutUrl = responseData['checkoutUrl'] ?? '';

        if (rawCheckoutUrl.isNotEmpty && sessionId.isNotEmpty && mounted) {
          // provider.sessionId = sessionId;
          final String checkoutUrl = rawCheckoutUrl.prefillWithProfile(provider.profile);

          debugPrint("SESSION ID: $sessionId");
          debugPrint("🔗 PREFILLED CHECKOUT URL: $checkoutUrl");
          
          provider.listenToOrderCompletion(sessionId);
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(checkoutUrl: checkoutUrl),
            ),
          );
          // ).then((_) async {
          //   // await provider.archiveCartToCompletedOrder();
          // });
        } else {
          throw Exception('Checkout URL was empty in response');
        }
        
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("CHECKOUT ERROR LOG: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.translate('checkout_error', provider.appLanguage), style: TextStyle(color: Colors.white),),
            backgroundColor: AppTheme.errorColor,
            
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
      final price = item.product.price;
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
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: CartItemsList(totalPrice: totalPrice),
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
