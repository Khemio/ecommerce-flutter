import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:azkomoly_app/app_theme.dart';

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
    super.initState();
    final shopProvider = context.read<ShopProvider>(); 
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
                    AppLocalizations.translate('order_success', shopProvider.appLanguage),
                  ),
                  backgroundColor: AppTheme.successColor,
                ),
              );
              // Pops back to the HomeScreen and clears navigation stack
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          
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
          AppLocalizations.translate('secure_checkout', shopProvider.appLanguage),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
