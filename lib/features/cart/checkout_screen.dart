import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
// import 'package:azkomoly_app/app_theme.dart';

import 'payment_failed_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String checkoutUrl;

  const CheckoutScreen({super.key, required this.checkoutUrl});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final WebViewController _controller;
  late final ShopProvider _shopProvider;

  bool _isNavigatingAway = false;

  @override
  void initState() {
    super.initState();
    // Safely capture the provider reference once while context is valid
    _shopProvider = context.read<ShopProvider>();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // onPageStarted: (String url) {
          //   final urlNormilazied = url.toLowerCase();
          //   // Shopify success redirection tracking rule
          //   if (urlNormilazied.contains('thank_you') || urlNormilazied.contains('orders')) {
          //     if (mounted) Navigator.pop(context);

          //     return;
          //   }

          //   // 2. Failure Resolution (User cancelled or card was declined by gateway)
          //   if (urlNormilazied.contains('cancel') || urlNormilazied.contains('declined') || urlNormilazied.contains('fail')) {
          //     if (!mounted) return;

          //     // Simply dismiss the webview window back to checkout/cart setup configuration screen
          //     Navigator.pop(context);

          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const PaymentFailedScreen()),
          //     );
          //     return;
          //   }
          // },
          onNavigationRequest: (NavigationRequest request) async {
            if (_isNavigatingAway) return NavigationDecision.prevent;

            final url = request.url.toLowerCase();

            // Fix for Hungarian Bank Redirects (Non-HTTP/HTTPS schemes)
            if (!request.url.startsWith('http://') &&
                !request.url.startsWith('https://')) {
              final uri = Uri.parse(request.url);
              // Safely open OTP / Telekom / banking applications installed on device
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
              return NavigationDecision.prevent;
            }

            if (url.contains('/thank_you') || url.contains('/orders')) {
              if (mounted) Navigator.pop(context);

              return NavigationDecision.prevent;
            }

            // Failyre pages
            if (url.contains('/cancel') ||
                url.contains('declined=') ||
                url.contains('/payment_failed')) {
              _isNavigatingAway = true;

              if (mounted) {
                Navigator.pop(context); // Dismiss webview
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentFailedScreen(),
                  ),
                );
              }
              return NavigationDecision.prevent;
            }

            if (!(url.contains('/cart') || url.contains('/checkout')) &&
                url.contains('myshopify')) {
              _isNavigatingAway = true;

              // Stop the webview from loading the website page
              if (mounted) {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ); // Pop back to HomeScreen
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision
                .navigate; // Allow normal checkout typing/clicks
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    // final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     AppLocalizations.translate('secure_checkout', _shopProvider.appLanguage),
      //   ),
      // ),
      // Inside your CheckoutScreen Widget build method:
      appBar: AppBar(
        title: Text(
          AppLocalizations.translate(
            'secure_checkout',
            _shopProvider.appLanguage,
          ),
        ),
      ),

      body: WebViewWidget(controller: _controller),
    );
  }
}
