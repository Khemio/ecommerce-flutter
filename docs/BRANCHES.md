# Branch review and implementation status

Review date: **2026-11-14**. Branch heads below are the commits inspected, not a promise that GitHub has not moved since.

| Branch | Inspected head | Purpose / state |
| --- | --- | --- |
| `main` | `b344798` | Existing storefront and basic WebView checkout; no SSE or dedicated order-result screens |
| `dev` | `74ca5b6` | Remote order model, `sessionId` checkout, SSE + timeout, order-success/payment-failure screens, order history synchronization |
| `appLifecycle` | `129cb7a` | One commit beyond `dev`: introduces app lifecycle resume hook and attempted silent payment verification (WIP, currently references missing symbols) |

`main` and `dev` have **diverged**: comparison shows `dev` 8 commits ahead and 4 behind `main`. `appLifecycle` is 1 commit ahead and 0 behind `dev`. Against `main`, `appLifecycle` is 9 ahead and 4 behind. These counts reflect the review snapshot.

## Key feature changes

| Feature | `main` | `dev` | `appLifecycle` |
| --- | --- | --- | --- |
| Catalog, cart, profile, local history | Yes | Yes | Yes |
| Checkout response requires `sessionId` | No | Yes | Yes |
| `order.created` SSE subscription | No | Code present (startup logic defect) | Same code |
| Dedicated order success/failure/timeout screens | No | Yes | Yes |
| Local archive built from remote order payload | No | Yes | Yes |
| External payment-app URI handling | Limited | Yes | Yes |
| App resume observer | No | No | Yes, incomplete |
| Real payment-status GET endpoint | No | No | No |
| State-derived navigation coordinator | No | No | No |

## Notable findings

### Likely block: SSE startup is disabled by its own stop call

`ShopProvider.listenToSSE` in `dev` and `appLifecycle` executes:

```dart
_isExplicitlyStopped = false;
stopListeningToSSE(); // sets _isExplicitlyStopped = true
// ...
_connectToStream(context, url.toString()); // immediately returns when stopped
```

Cancel the previous subscription **before** resetting the stop flag. Add a unit test that asserts one SSE connection opens for a new checkout. This defect is visible by inspection, not inferred from a network test.

### Likely build failure in `appLifecycle`

`CheckoutScreen` has only a `checkoutUrl` constructor field, but its resume hook references `widget.checkoutId`. It also calls `ShopProvider.checkIfCheckoutIsCompleted`, a method not found in the inspected provider. The branch should remain WIP until both the session identity and a real lookup contract exist.

### Additional static-analysis candidates

- In `Product`, the constructor declares `this._id` and `this._variantId`, while its `fromJson` and `copyWith` call sites pass `id:` and `variantId:`. Reconcile the named-argument API and use `flutter analyze` to catch errors.
- `SummaryPanel`'s constructor declares named parameters `_isCheckingOut`, `_totalPrice`, `_onCheckoutPressed`, whereas `CartScreen` passes `isCheckingOut`, `totalPrice`, `onCheckoutPressed`. Align their public names.
- `RemoteOrder` declares `required this._isValid` but `RemoteOrder.fromJson` invokes the constructor with `isValid:`; align that named argument too.
- The template `test/widget_test.dart` expects a counter and is not representative of `MyApp` (which also needs a `ShopProvider` ancestor).

### Runtime correctness issues

- `RemoteOrder.fromJson` repeatedly *overwrites* its `dataIsValid` Boolean, so a valid final `line_items` array can mask missing earlier required fields. Validate with a conjunction or explicit per-field failures.
- `OrderHistoryItem.fromOrder` keys line items by product ID and only includes products that were in the local cart; multiple variants of one product can collide. Reconstruct the receipt from server-authoritative line items by variant/order-line ID.
- SSE and WebView both perform imperative navigation, allowing races. WebView 'thank you' URL is not an authoritative payment signal.
- SSE retry timers are not held and canceled on stop/dispose; provider also has no observed `dispose()` cleanup for the timers/subscription.
- A timed-out order's manual status button is a placeholder, so a user cannot recover a delayed success.
- `fetchRemoteConfiguration` calls an endpoint that neither inspected proxy branch registers. For non-200 responses it constructs a fallback from `products.sublist(0,5)` even if fewer than five items exist; the catch logs the resulting error.
- The current client logs the full prefilled Shopify checkout URL, potentially including customer PII in the query string.

## Merge strategy

1. Preserve `main` as a known historical baseline; do **not** merge `appLifecycle` unmodified.
2. Establish a clean integration branch from the intended base, resolve divergence with `main`, and repair compile-level issues.
3. Verify proxy `dev` and client API contracts together; remove the proxy's fake `order.created` test event.
4. Extract the checkout coordinator and add tests before enabling checkout-success navigation.
5. Merge to `main` only when `flutter analyze`, targeted tests, and a documented manual device checkout flow pass.

`ecommerce-proxy` has its own `docs/DEVELOPMENT_BRANCHES.md`, which should be updated if the two branches' API contracts are changed.
