# Portfolio demo and screenshots

This is a concise walkthrough of the verified storefront, not a successful-payment demonstration.

## Suggested screenshots (Android emulator or physical device)

Capture these screens from the running Flutter app. **Use your own screenshots; no images are currently bundled with this document.**

| Suggested filename | Screen | What it demonstrates |
| --- | --- | --- |
| `docs/images/catalog.png` | Home catalog with products | Shopify catalog integration and product images |
| `docs/images/product-details.png` | Product details and quantity selection | Mobile UI and cart workflow |
| `docs/images/cart.png` | Cart with more than one item | Stateful quantity editing and totals |
| `docs/images/checkout.png` | Shopify-hosted checkout WebView | Frontend-to-Go-to-Shopify integration; checkout *creation*, not payment completion |

Use 2–3 of the first three for the README. The fourth is optional and should not show customer details, email, addresses, payment credentials, checkout tokens, session IDs, or other personal/sensitive data.

## How to capture a clean demo

1. Run `ecommerce-proxy` with a test Shopify store and sample products, and launch Flutter with the appropriate `BASE_URL` Dart define.
2. Show catalog loading, vendor/type filtering, and price sorting.
3. Open a product, adjust the quantity, add it to the cart, change the cart quantity, and return to the catalog.
4. Restart the application to show local cart persistence.
5. Optionally open the hosted checkout page. **Do not complete a real payment solely for the demo.** Do not show the app's current provisional paid/success result as verified.

A 30–60-second silent screen recording can demonstrate this more effectively than a slideshow. A few actual device screenshots in the README are also sufficient.

## Before publishing images

- Keep screenshots from one consistent device resolution and avoid giant raw image files.
- Check the store branding/product imagery is suitable for public use and complies with the internship project's publication permissions.
- Redact or avoid customer names, addresses, tokens, order/session IDs, and payment information.
- Commit screenshot files separately after they have been captured, then add the image references to the README.

## Reported validation

The owner previously confirmed eight storefront/cart smoke checks, `flutter analyze` with no issues, and 11 Flutter tests passing. The new checkout request tests and GitHub Actions workflow should be run and verified before reporting their results.
