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

class _CheckoutScreenState extends State<CheckoutScreen> with WidgetsBindingObserver {
  late WebViewController _controller;
  late ShopProvider _shopProvider;
  bool _isNavigatingAway = false;
  bool _isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    // 2. Register this widget as an observer of the app lifecycle
    WidgetsBinding.instance.addObserver(this);
    
    _shopProvider = context.read<ShopProvider>();
    _initWebView();
  }

  @override
  void dispose() {
    // 3. Unregister the observer when the widget is destroyed to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Triggered when the user switches back to your app from their banking app
    if (state == AppLifecycleState.resumed) {
      _verifyCheckoutStatusSilently();
    }
  }

  /// Polls the Shopify API via your provider to check if the payment went through
  Future<void> _verifyCheckoutStatusSilently() async {
    // Prevent duplicate background checks running simultaneously
    if (_isCheckingStatus || _isNavigatingAway) return;

    setState(() {
      _isCheckingStatus = true;
    });

    try {
      // TODO: Implement this method in your ShopProvider to fetch the latest checkout status 
      // (e.g., checking if 'completedAt' is not null or if an order ID is linked)
      final bool isPaid = await _shopProvider.checkIfCheckoutIsCompleted(widget.checkoutId);

      if (isPaid && mounted) {
        _isNavigatingAway = true;
        
        // Cleanly pop the checkout webview and let the app handle the native success flow
        Navigator.pop(context);
        return;
      }
    } catch (e) {
      debugPrint("Silent background checkout verification failed: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingStatus = false;
        });
      }
    }
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          
          onNavigationRequest: (NavigationRequest request) async {
            if (_isNavigatingAway) return NavigationDecision.prevent;

            final url = request.url.toLowerCase();

            // Fix for Hungarian Bank Redirects (Non-HTTP/HTTPS schemes)
            if (!request.url.startsWith('http://') && !request.url.startsWith('https://')) {
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
            if (url.contains('/cancel') || url.contains('declined=') || url.contains('/payment_failed')) {
              _isNavigatingAway = true;

              if (mounted) {
                Navigator.pop(context); // Dismiss webview
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentFailedScreen()),
                );
              }
              return NavigationDecision.prevent;
            }
            
            if (!(url.contains('/cart') || url.contains('/checkout')) && url.contains('myshopify')) {
              _isNavigatingAway = true;

              // Stop the webview from loading the website page
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst); // Pop back to HomeScreen
              }
              return NavigationDecision.prevent; 
            }
            
            return NavigationDecision.navigate; // Allow normal checkout typing/clicks
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Safely capture the provider reference once while context is valid
  //   _shopProvider = context.read<ShopProvider>(); 
  //   _controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
          
  //         onNavigationRequest: (NavigationRequest request) async {
  //           if (_isNavigatingAway) return NavigationDecision.prevent;

  //           final url = request.url.toLowerCase();

  //           // Fix for Hungarian Bank Redirects (Non-HTTP/HTTPS schemes)
  //           if (!request.url.startsWith('http://') && !request.url.startsWith('https://')) {
  //             final uri = Uri.parse(request.url);
  //             // Safely open OTP / Telekom / banking applications installed on device
  //             if (await canLaunchUrl(uri)) {
  //               await launchUrl(uri, mode: LaunchMode.externalApplication);
  //             }
  //             return NavigationDecision.prevent;
  //           }

  //           if (url.contains('/thank_you') || url.contains('/orders')) {
  //             if (mounted) Navigator.pop(context); 
                
  //             return NavigationDecision.prevent;
  //           }

  //           // Failyre pages
  //           if (url.contains('/cancel') || url.contains('declined=') || url.contains('/payment_failed')) {
  //             _isNavigatingAway = true;

  //             if (mounted) {
  //               Navigator.pop(context); // Dismiss webview
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (_) => const PaymentFailedScreen()),
  //               );
  //             }
  //             return NavigationDecision.prevent;
  //           }
            
  //           if (!(url.contains('/cart') || url.contains('/checkout')) && url.contains('myshopify')) {
  //             _isNavigatingAway = true;

  //             // Stop the webview from loading the website page
  //             if (mounted) {
  //               Navigator.popUntil(context, (route) => route.isFirst); // Pop back to HomeScreen
  //             }
  //             return NavigationDecision.prevent; 
  //           }
            
  //           return NavigationDecision.navigate; // Allow normal checkout typing/clicks
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(widget.checkoutUrl));
  // }

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
        title: GestureDetector(
          onLongPress: () {
            debugPrint("🛠️ Test Hook Triggered: Forcing Thank You URL Routing");
            // Explicitly load a dummy domain containing 'fail' to trip your interceptor
            _controller.loadRequest(Uri.parse("https://myshopify.com/thank_you"));
          },
          onDoubleTap: () {
            debugPrint("🛠️ Test Hook Triggered: Forcing Failure URL Routing");
            // Explicitly load a dummy domain containing 'fail' to trip your interceptor
            _controller.loadRequest(Uri.parse("https://myshopify.com/fail"));
          },
          child: Text(
            AppLocalizations.translate('secure_checkout', _shopProvider.appLanguage),
          ),
        ),
      ),

      body: WebViewWidget(controller: _controller),
    );
  }
}
