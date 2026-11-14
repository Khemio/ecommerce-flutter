# Architecture

> **Inspected:** `main`, `dev`, and `appLifecycle` on 2026-11-14. This document describes `dev` unless a branch is identified explicitly. It is a source review, not a successful build or runtime test.

## Component boundaries

```text
main.dart
  ChangeNotifierProvider<ShopProvider>
    MaterialApp -> MainLayout (IndexedStack)
      |-- HomeScreen -> product grid -> DetailScreen
      |-- CartScreen -> POST checkout -> CheckoutScreen(WebView)
      |-- ProfileScreen -> OrderHistoryScreen

ShopProvider
  |-- GET products; GET config (not served by proxy currently)
  |-- in-memory products, filters, cart, profile, order history, locale
  |-- SharedPreferences for cart, order history, profile, locale
  |-- `dev`: SSEClient -> RemoteOrder -> archiveCartToCompletedOrder
  `-- `dev`: direct Navigator calls for success and timeout

Shopify checkout opened in WebView; external banking-app schemes via url_launcher.
```

### UI and state

- `ShopProvider` is a single global `ChangeNotifier`. Widgets read/observe it with the `provider` package. Product fetch starts in `HomeScreen.initState` via a post-frame callback.
- `MainLayout` maintains three tab pages in an `IndexedStack`; detail, checkout and history pages use imperative `Navigator` pushes.
- The app uses a local cart keyed by the product variant ID. Product catalog data is obtained from the proxy rather than from a client-side Shopify secret.
- `CheckoutScreen` embeds a hosted checkout WebView and examines navigation URLs. Non-HTTP(S) redirects may launch external banking/payment apps using `url_launcher`.
- On `dev`, the `ShopProvider` listens for an `order.created` SSE event, parses a `RemoteOrder`, archives a copy into local history, clears the cart and pushes `OrderSuccessScreen`. A 15-minute SSE timer pushes `OrderProcessingTimeoutScreen`.
- On `appLifecycle`, `CheckoutScreen` registers `WidgetsBindingObserver` and tries to verify checkout on `AppLifecycleState.resumed`. **This work is incomplete:** it references a nonexistent `widget.checkoutId` and an unimplemented provider method.

## Persisted data

`SharedPreferences` keys currently read/written by `ShopProvider`:

| Key | Meaning | Concern |
| --- | --- | --- |
| `user_language_pref` | `en` / `hu` preference | Falls back to device locale (Hungarian, otherwise English) |
| `user_cart_cache` | Map of serialized `CartItem` entries | Device-local; serialized product prices can go stale |
| `user_orders_cache` | Map of locally archived `OrderHistoryItem` | Not a server-authoritative order ledger |
| `user_profile` | Name, email, postal/shipping address | Personally identifying information in app preferences; assess storage/privacy requirements |

Cart updates are delayed by a one-second timer before saving. Completed-order archival clears the cart and writes cart and history in **separate** preference operations; the comment claiming atomic synchronization is not enforced by that code. On app startup, loading is asynchronous and exceptions are logged, not shown to the user.

## Relevant models

- `Product` parses the first image and first variant from a Shopify-like JSON object; the UI does not support choosing arbitrary variants.
- `CartItem` contains a `Product` snapshot and quantity.
- `RemoteOrder` (development branches) parses an SSE order payload and its line items.
- `OrderHistoryItem.fromOrder` attempts to reconcile the local cart with remote line items using **product ID** keys; it formats an HUF total computed from the matched local items, rather than displaying the server's authoritative total/currency. This requires a fix for mismatched variants and prices.
- `UserProfile` and `ShippingAddress` are saved locally and used to prefill checkout URL parameters.

## Networking responsibility split

| Responsibility | Flutter | Go proxy | Shopify |
| --- | --- | --- | --- |
| Display catalog and cart | Yes | Returns simplified product JSON | Product source |
| Create checkout | POST lines to proxy | Calls `cartCreate`, returns checkout URL | Hosts checkout |
| Accept payment details | **No** (renders hosted checkout) | **No** | Yes |
| Correlate order to checkout session (`dev`) | Holds `sessionId`, subscribes to SSE | In-memory session + cart attribute | Returns webhook with order metadata |
| Verify payment succeeded | **Not implemented** | **Not implemented in current public contract** | Authoritative source |
| Show result screens | Implemented on `dev` | Emits `order.created` on `dev` | Hosted payment UX |

## Navigation design problem

Navigation decisions are currently scattered among `CartScreen`, the checkout WebView delegate, and `ShopProvider` SSE/timeout callbacks. A redirect can pop checkout while an SSE notification simultaneously pushes a different route. External-app resume adds a third competing signal. The next design should make **state transitions independent of route changes** and have one flow coordinator/host project state to screens; see [checkout state design](CHECKOUT_STATE_DESIGN.md).

## Future component boundary (proposal, not implemented)

```text
Checkout UI / WebView navigation hooks / application lifecycle hooks
            |      normalized, idempotent events
            v
CheckoutCoordinator (session + state machine, no BuildContext)
            |                     |
            |                     +-- CheckoutRepository (HTTP/SSE, reconciliation)
            v
CheckoutFlowHost (single state -> Navigator transition adapter)
            |
     pending / confirmed / failed / unknown result screens
```

Keep product/cart preferences in `ShopProvider` initially; extract the checkout workflow rather than rewriting the whole app. Treat payment confirmation as a backend-verified domain event, not a WebView URL substring.
