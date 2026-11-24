import 'package:azkomoly_app/core/utils/uri_extentions.dart';
import 'package:azkomoly_app/features/cart/checkout_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/app_theme.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';

import 'cart.dart'
    show CheckoutScreen, ClearCartBtn, CartItemsList, SummaryPanel;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CheckoutApi _checkoutApi = CheckoutApi();
  bool _isCheckingOut = false;

  @override
  void dispose() {
    _checkoutApi.close();
    super.dispose();
  }

  Future<void> _handleCheckout(ShopProvider provider) async {
    if (_isCheckingOut || provider.cart.isEmpty) return;
    setState(() => _isCheckingOut = true);

    try {
      final session = await _checkoutApi.createCheckout(provider.cart);
      if (!mounted) return;

      final checkoutUrl = session.checkoutUrl.prefillWithProfile(
        provider.profile,
      );

      provider.listenToSSE(context, session.sessionId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutScreen(checkoutUrl: checkoutUrl),
        ),
      );
    } catch (e) {
      debugPrint("CHECKOUT ERROR LOG: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.translate(
                'checkout_error',
                provider.appLanguage,
              ),
              style: TextStyle(color: Colors.white),
            ),
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
        title: Text(
          AppLocalizations.translate('cart_title', shopProvider.appLanguage),
        ),
        actions: [
          if (shopProvider.cart.isNotEmpty) ClearCartBtn(),
          const SizedBox(width: 8),
        ],
      ),
      body: shopProvider.cart.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.translate(
                  'cart_empty',
                  shopProvider.appLanguage,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(child: CartItemsList(totalPrice: totalPrice)),

                SummaryPanel(
                  isCheckingOut: _isCheckingOut,
                  totalPrice: totalPrice,
                  onCheckoutPressed: _handleCheckout,
                ),
              ],
            ),
    );
  }
}
