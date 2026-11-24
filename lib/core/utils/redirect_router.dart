import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:azkomoly_app/features/details/detail_screen.dart';

class RedirectRouter {
  /// Parses an incoming redirect path string and handles native navigation.
  static void execute(BuildContext context, String? redirectUrl) {
    if (redirectUrl == null || redirectUrl.isEmpty) return;

    debugPrint("🌐 Intercepted Banner Tap Redirect URL: $redirectUrl");

    final uri = Uri.parse(redirectUrl);
    final String scheme = uri.scheme; // e.g., 'azkomoly'
    final String host = uri.host; // e.g., 'product', 'tab', 'vendor'

    if (scheme != 'azkomoly') {
      debugPrint("⚠️ Unsupported URL scheme: $scheme");
      return;
    }

    switch (host) {
      case 'product':
        // 1. Extract the product ID from the path segment path tracking tags
        // URL Shape: azkomoly://product/gid://shopify/Product/9865871786201 -> segments[0] is 'gid:'
        if (uri.pathSegments.isNotEmpty) {
          final String targetProductId = uri.pathSegments.join('/');
          targetProductId.replaceFirst('/', '//');
          debugPrint(targetProductId);

          final shopProvider = Provider.of<ShopProvider>(
            context,
            listen: false,
          );

          // 2. Find the matching Product entity out of your active memory data state cache
          final productMatch = shopProvider.products.firstWhere(
            (p) => p.id == targetProductId,
            orElse: () => shopProvider.products.firstWhere(
              (p) => p.variantId == targetProductId,
            ),
          );

          // 3. Smoothly push the user directly onto your fluid animated detail viewing screen!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(product: productMatch),
            ),
          );
        }
        break;

      case 'tab':
        // Handle bottom navigation tab shortcuts if needed
        debugPrint("Navigating to specific tab views: ${uri.pathSegments}");
        break;

      case 'vendor':
        // PREPARED FOR THE FUTURE ROADMAP VENDOR STORES LAYER:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => VendorStoreScreen(vendorId: uri.pathSegments[0])));
        debugPrint(
          "🚀 Multi-Vendor Store View Ready to Mount for Vendor: ${uri.pathSegments[0]}",
        );
        break;

      default:
        debugPrint("❌ Unhandled routing destination target: $host");
    }
  }
}
