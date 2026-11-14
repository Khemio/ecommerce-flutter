# ecommerce-flutter

Flutter storefront for the **Azkomoly e-commerce prototype**, developed as part of an internship project. The app presents a Shopify-backed catalog, manages a local cart and customer profile, and launches Shopify's hosted checkout through a Go API proxy.

**Companion repository:** [ecommerce-proxy](https://github.com/Khemio/ecommerce-proxy). The two repositories form one prototype, but have separate build, release, and runtime responsibilities.

> **Status (reviewed 2026-11-14):** Work-in-progress prototype, **not a production-ready payment application**. `main` is the older storefront baseline. Checkout-session tracking, webhook-driven order notifications, and result screens exist on `dev`; the `appLifecycle` branch has an additional *unfinished* checkout-resume experiment. Some inspected code is likely to fail static analysis or compilation. Documentation of non-default branches does not imply those changes are merged or working end to end.

## Features

- Product catalog loaded from a Go proxy, with product-type/vendor filters and price ordering.
- Product details, quantity selection, cart operations, and local cart persistence.
- Shopify-hosted checkout inside a Flutter WebView, including URL-based profile prefilling.
- Customer profile/address editing, English/Hungarian UI strings, and locally saved order history.
- Remotely configurable promotional/social UI widgets (client implementation; the companion proxy currently has **no** `/api/v1/config` route).
- **On `dev` only:** checkout session IDs, order SSE listener, an order-success screen, a failure screen, and a delayed-confirmation screen.
- **On `appLifecycle` only:** a work-in-progress `WidgetsBindingObserver` that attempts to re-check checkout after the app resumes from an external banking app.

## Architecture at a glance

```text
Flutter UI (Home / Cart / Profile)
       |
       v
ShopProvider (ChangeNotifier): catalog, cart, profile, history, language
       |
       +---- HTTP JSON ------> ecommerce-proxy (Go) ----> Shopify Storefront API
       |                          |                        (products, cart creation)
       |                          +---- hosted checkout URL
       |
       +---- WebView -------------------------------> Shopify-hosted checkout
       |
       +---- SSE (`dev`) ---> proxy checkout session <--- Shopify order webhook
       |
       +---- SharedPreferences (device-local data)
```

Shopify, not Flutter or the Go proxy, handles payment entry and payment processing. The Go development branch correlates webhook notifications with app sessions; it does not establish a verified **paid** state in the current event contract.

## Getting started

### Prerequisites

- Flutter SDK compatible with the Dart constraint in `pubspec.yaml` (currently `^3.12.2` on `dev`).
- An Android/iOS development environment for the WebView-based checkout flow.
- Running [ecommerce-proxy](https://github.com/Khemio/ecommerce-proxy) with Shopify Storefront credentials. Use its `dev` branch to inspect the session/SSE prototype; `main` does not implement those endpoints.

### Run

```sh
git clone https://github.com/Khemio/ecommerce-flutter.git
cd ecommerce-flutter
git checkout dev  # checkout/SSE prototype; not guaranteed to build
flutter pub get
flutter run --dart-define=BASE_URL=http://10.0.2.2:8080
```

`BASE_URL` is a **compile-time** Dart define. `10.0.2.2` reaches the host from the standard Android emulator. For an iOS simulator, `http://localhost:8080` is commonly suitable; for a physical device, use a reachable host/LAN address. The current code's default is a developer-specific `http://192.168.100.46:8080`; override it rather than assuming that address works.

```sh
flutter analyze
flutter test
```

These are verification commands, **not reported passing results**. The existing `test/widget_test.dart` is Flutter's template counter test, not a valid test of this storefront. The inspected branches have known potential compile and flow defects; see the roadmap.

Local insecure HTTP may require additional platform-specific development configuration; use HTTPS for actual deployments. Do not ship real Shopify Admin credentials or webhook secrets inside the Flutter app.

## Code layout

| Location | Responsibility |
| --- | --- |
| `lib/main.dart` | Initializes `ChangeNotifierProvider<ShopProvider>` and `MaterialApp` |
| `lib/features/main_layout.dart` | Bottom-navigation home/cart/profile shell with `IndexedStack` |
| `lib/core/providers/shop_provider.dart` | Catalog fetching, cart, filters, preferences, order history; also SSE and navigation on `dev` |
| `lib/core/models/` | Products, profile/address, banners; remote order model on `dev` |
| `lib/features/home/` | Catalog, filters, promotions, social widgets |
| `lib/features/details/` | Product detail and add-to-cart UI |
| `lib/features/cart/` | Cart creation, checkout WebView, order outcomes on `dev` |
| `lib/features/profile/` | Local profile and order history |
| `lib/app_config.dart` | Client API paths and base URL |
| `lib/app_localizations.dart` | English/Hungarian translations |
| `lib/core/utils/` | URL prefilling, banner routing, formatters |

## Documentation

- [Architecture](docs/ARCHITECTURE.md) — implemented components, data storage, navigation responsibilities.
- [API integration](docs/API_INTEGRATION.md) — current client/server JSON, SSE and webhook semantics.
- [Checkout state design](docs/CHECKOUT_STATE_DESIGN.md) — proposed state-driven routing and lifecycle recovery.
- [Branch review](docs/BRANCHES.md) — concrete branch divergence and checkout maturity.
- [Testing](docs/TESTING.md) — test strategy and scenario matrix.
- [Roadmap](docs/ROADMAP.md) — prioritized defects and realistic next steps.

## Security and scope

This is a demonstrator, not a hardened shopping app: order history and profile are stored locally in `SharedPreferences`; there is no account-based history sync, documented authentication, or verified order-status recovery API. Avoid calling an order *paid* merely because a checkout URL redirected or an `order.created` event arrived. Validate payment status on the backend and make duplicate or delayed notifications safe before using the flow for real purchases.
