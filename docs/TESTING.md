# Testing and verification

Updated **November 24, 2026**. Results reflect the portfolio-finishing checkout API tests and the successful GitHub Actions run on `main`.

## Verified baseline

| Check | Result |
| --- | --- |
| `dart format lib test` | 0 changed files |
| `flutter analyze` | No issues found |
| `flutter test` | **18 tests passed** locally |
| Manual smoke test | **8 of 8 passed** |
| GitHub Actions | **Passed** ([main workflow run](https://github.com/Khemio/ecommerce-flutter/actions/runs/45433169586)) |

The eight manual scenarios were: catalog loads/images display; product-type and vendor filters; price sorting both directions; product details; add/cart quantity editing; cart survives restart; remove/clear persists; and checkout URL creation. The checkout test **does not prove a paid order**, a processed webhook, or a correct result screen.

## Commands

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run --dart-define=BASE_URL=http://10.0.2.2:8080
```

Run the Go proxy with valid Shopify development credentials. `10.0.2.2` is for an Android emulator; use a reachable LAN IP for a physical device. Android debug builds allow local HTTP to the development proxy; use HTTPS in production-like environments.

## Automated tests presently included

- `test/product_test.dart`: Shopify product decoding, nullable SKU, price format, absent fields, cache roundtrip.
- `test/remote_order_test.dart`: basic remote order parsing and validation failures.
- `test/shop_provider_cart_test.dart`: add/merge/update, zero-quantity removal, remove/clear persist despite pending debounce timer.
- `test/widget_test.dart`: quantity selector behavior.
- `test/checkout_api_test.dart`: checkout request payload, HTTP failure, malformed JSON, missing session, insecure URL, empty cart and invalid quantity.

These do not exercise a real Shopify payment, native banking redirect, authenticated webhook, or live SSE connection.

## Next high-value tests

- Cart restoration after delayed asynchronous preferences load; invalid/corrupt cached values; duplicate variants and zero or negative quantities.
- Product fetching with empty or malformed payloads, timeouts, no network, and catalogs shorter than five entries.
- Additional checkout failures (missing checkout URL, network disconnect/timeout, and duplicate taps); basic HTTP errors, malformed JSON and invalid sessions are already covered with a fake HTTP client.
- WebView transition and external app return behavior on Android/iOS devices; cancellation and failed attempts without premature cart clearing.
- Fake SSE transport: reconnect/backoff, webhook before subscribe, duplicate/late events, session mismatch, disposal and app resume.
- Server-verified payment status and single archival/navigation effect **after the status API exists**.

See [the published portfolio screenshots and edited demo](DEMO.md). The video demonstrates a storefront/cart journey, not payment confirmation.

Keep payment-status correctness distinct from order creation. Until verification exists, label successful checkout/payment behavior as unfinished. See [Checkout state design](CHECKOUT_STATE_DESIGN.md).
