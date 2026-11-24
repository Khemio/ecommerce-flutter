# Architecture

Updated **November 24, 2026** for the tested storefront baseline on `dev`. The state-driven checkout system remains a **proposal**.

## Current component boundaries

```text
main.dart -> ChangeNotifierProvider<ShopProvider>
  MainLayout (IndexedStack)
    HomeScreen -> catalog / filters -> DetailScreen
    CartScreen -> POST checkout -> CheckoutScreen(WebView)
    ProfileScreen -> local profile / OrderHistoryScreen

ShopProvider
  |- GET /api/v1/products via ecommerce-proxy
  |- local banner configuration (optional remote /config behind a flag)
  |- products, filters, cart, profile, language and history
  |- SharedPreferences for cart, profile, language and history
  |- SSE order.created subscription, retry and timeout
  '- currently routes to provisional order success/timeout UI

Shopify handles hosted payment and sends order webhooks to ecommerce-proxy.
```

## Verified storefront

The repository owner reported `flutter analyze` with **no issues**, **11 passing tests**, and **8 passing manual runtime checks**: catalog/images, filters, sorting, product details, cart updates, restart persistence, remove/clear persistence and checkout URL creation. These checks do **not** verify a paid order or live webhook/SSE handling.

## Models and storage

- `Product` represents Shopify's **first** variant and first image. The parser accepts absent images, nullable SKU, and numeric/string price fields.
- `CartItem` combines a product snapshot with mutable quantity; cart map keys are variant IDs.
- `RemoteOrder` parses the `order.created` payload. Its field-validation conjunction was repaired, but this is not a verified payment record.
- `OrderHistoryItem.fromOrder` presently reconciles remote order lines against **product IDs** in the local cart. This can mishandle multiple variants, missing local cart items, price/currency truth and duplicated events. It must be redesigned with server-authoritative order lines.
- `SharedPreferences` stores `user_language_pref`, `user_cart_cache`, `user_orders_cache`, and `user_profile` locally. The profile may contain email and delivery address; avoid treating preferences as a secure server-side order ledger.

Cart edits use a one-second save debounce. Remove and clear operations cancel any pending debounced save, but order archival still performs separate preference writes without a transaction.

## Checkout lifecycle limitations

The client requests `sessionId` and `checkoutUrl` from `POST /api/v1/checkout`, opens Shopify checkout in a WebView, and listens for SSE notifications. The Go proxy `main` now exposes the session/SSE contract (earlier documentation listed it as dev-only).

**An `order.created` event is not proof of successful payment.** The current client may archive an order, clear its cart, and navigate to a success screen from this event before any authoritative payment verification. WebView delegates and provider timers also navigate independently, leading to potential duplicate or conflicting transitions. The optional `appLifecycle` branch remains unfinished and is not merged.

Do not infer production checkout correctness from the passing storefront smoke test.

## Intended minimal design

```text
WebView / lifecycle / SSE / timeout observers
                |
                v
CheckoutCoordinator (session-scoped, immutable state)
                |
       CheckoutRepository (HTTP / SSE / verified status)
                |
                v
CheckoutFlowHost (one state-to-navigation adapter)
       |           |           |
  checkout      pending     success/failure
```

Keep the existing catalog/cart/profile functionality inside `ShopProvider`; extract only checkout-specific orchestration. Each observable event updates state, while a single navigation adapter maps that state to screens. Verified confirmation must be a backend-defined status, not a URL substring or an unqualified webhook.

See [checkout design](CHECKOUT_STATE_DESIGN.md), [API integration](API_INTEGRATION.md) and [roadmap](ROADMAP.md).
