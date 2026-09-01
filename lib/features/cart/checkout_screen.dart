import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_app/app_theme.dart';

import '../../app_localizations.dart';
import '../../core/providers/shop_provider.dart';
// import '../providers/shop_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final String checkoutUrl;

  const CheckoutScreen({super.key, required this.checkoutUrl});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    final shopProvider = Provider.of<ShopProvider>(context); 
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Shopify success redirection tracking rule
            if (url.contains('thank_you') || url.contains('orders')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    // '🎉 Order Placed Successfully!'
                    AppLocalizations.translate('order_success', shopProvider.appLanguage),
                  ),
                  backgroundColor: AppTheme.successColor,
                  // behavior: SnackBarBehavior.floating, 
                ),
              );
              // Pops back to the HomeScreen and clears navigation stack
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          // 💡 THE FIX: Intercept Shopify's "Continue Shopping" button click
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            
            if (!(url.contains('/cart') || url.contains('checkouts')) && url.contains('myshopify')) {
              // Stop the webview from loading the website page
              Navigator.popUntil(context, (route) => route.isFirst); // Pop back to HomeScreen
              return NavigationDecision.prevent; 
            }
            
            return NavigationDecision.navigate; // Allow normal checkout typing/clicks
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context); 
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // 'Secure Shopify Checkout'
          AppLocalizations.translate('secure_checkout', shopProvider.appLanguage),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
