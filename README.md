# ecommerce-flutter

Flutter storefront for the **Azkomoly e-commerce prototype**, developed during an internship. It uses a Go proxy for Shopify catalog and checkout-session operations and a hosted Shopify checkout WebView.

**Companion service:** [ecommerce-proxy](https://github.com/Khemio/ecommerce-proxy).

> **Status (November 24, 2026):** The catalog/cart baseline has passed local static analysis, 11 Flutter tests, and eight user-reported runtime checks. Checkout URL creation was verified; **successful payment and the order-result lifecycle were not**. This is a portfolio prototype, not a production-ready payment integration.

## Verified storefront functionality

- Shopify-backed catalog, images, vendor and product-type filters, and price sorting.
- Product details, quantity selection, and adding products to the cart.
- Locally persisted cart, including quantity changes, removal, clearing, and app-restart recovery.
- Customer profile and address fields; English and Hungarian interface strings.
- Hosted Shopify checkout URL creation through the Go proxy, loaded in a Flutter WebView.
- A focused checkout HTTP client with validation of session responses, HTTPS checkout URLs and error handling (pending verification on this branch).
- Promotional and social carousels; a safe local banner fallback when the proxy does not serve `/config`.

**Checkout limitations:** `ShopProvider` can subscribe to `order.created` over SSE and show outcome screens, but order creation is not proof of payment. The current client also directly navigates from WebView/SSE callbacks; lifecycle resume verification and an authoritative payment-status lookup are not implemented. Do not treat the current success screen as verified payment confirmation.

## Architecture

```text
Flutter (Home / Product details / Cart / Profile)
    |
    +-- ShopProvider (catalog, cart, preferences, local order history)
    |        +-- SharedPreferences (device-local)
    |        +-- HTTP/JSON --> ecommerce-proxy (Go) --> Shopify Storefront API
    |        +-- SSE order.created <--- ecommerce-proxy <--- Shopify webhook
    |
    +-- CheckoutScreen (WebView) --> Shopify-hosted checkout
```

Shopify handles payment processing. The Flutter app and Go proxy do not process card details.

## Getting started

Prerequisites: a Flutter SDK compatible with `pubspec.yaml` (Dart `^3.12.2`), an Android/iOS development environment when testing the WebView, and the companion Go proxy configured with Shopify Storefront credentials.

Run the **proxy's `main` branch** on port 8080. Its current public API supports products, checkout creation with `sessionId`, SSE, and the Shopify webhook. It does not expose `/api/v1/config` or an authoritative checkout-status lookup.

```powershell
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=BASE_URL=http://10.0.2.2:8080
```

`10.0.2.2` reaches the host computer from the standard Android emulator. For a physical phone use a reachable local-network address; for iOS simulator, `localhost` may work. `BASE_URL` is a compile-time Dart define and defaults to `http://localhost:8080`. Android debug builds allow local HTTP for testing; release deployments should use HTTPS.

To opt into a compatible custom `/config` endpoint, pass `--dart-define=ENABLE_REMOTE_CONFIG=true`. Otherwise the client builds local promotional banners from the available products and does not request the unsupported endpoint.

## Verification

- `dart format lib test`: 0 changed files.
- `flutter analyze`: **no issues found**.
- `flutter test`: **11 tests passed** (product, remote-order, cart-provider, widget tests).
- Runtime smoke test, reported by the project owner: **8/8 passed** (catalog/images, filters, sorting, product details, cart editing, restart persistence, remove/clear persistence, and checkout URL creation).

These results were recorded **before** the portfolio-finishing changes. The new checkout API tests and CI workflow still require a local run or a successful GitHub Actions check.

These checks do **not** verify payment completion, signed webhook delivery, a bank app returning to the WebView, retries, or persistence of a pending checkout session.

## Code layout

| Location | Responsibility |
| --- | --- |
| `lib/main.dart` | Sets up the app and `ShopProvider` |
| `lib/features/main_layout.dart` | Home/cart/profile navigation |
| `lib/core/providers/shop_provider.dart` | Catalog, cart, local preferences, and current SSE hooks |
| `lib/core/models/` | Product, remote-order, profile, and UI models |
| `lib/features/home/` | Catalog, filters, promotion/social carousels |
| `lib/features/details/` | Product display and add-to-cart |
| `lib/features/cart/` | Cart, hosted checkout, request-validation client and provisional result screens |
| `lib/features/profile/` | Profile and local order history |
| `test/` | Focused Flutter tests |

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [API integration](docs/API_INTEGRATION.md)
- [Branch history](docs/BRANCHES.md)
- [Checkout state design (proposal)](docs/CHECKOUT_STATE_DESIGN.md)
- [Testing](docs/TESTING.md)
- [Roadmap](docs/ROADMAP.md)
- [Demo and screenshots](docs/DEMO.md) — a short walkthrough and capture checklist; images will be added separately once available.

## Portfolio demonstration

The fastest demonstration is: **catalog → product details → add to cart → change quantity → restart app to confirm persistence → hosted checkout page**. This demonstrates the Flutter/Go/Shopify integration without claiming an actual payment.

See [demo and screenshot instructions](docs/DEMO.md). The repository does not yet include device screenshots; they should be added after capturing them from the running app, with personal data and tokens excluded.

## Scope and data safety

This is a demonstrator, not a hardened commerce gateway. Profile, cart, and order history live in device-local `SharedPreferences`; there is no authenticated multi-device order history or recoverable verified-payment state. The remaining checkout work must distinguish confirmed payment, order creation, canceled/failed, and unknown/pending outcomes, and must never clear the cart or display paid success based solely on an SSE event or URL substring.
