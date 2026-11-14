# Testing and verification plan

> No Flutter commands were executed during this documentation review. The committed `test/widget_test.dart` is the unmodified Flutter counter template and is not an effective test of this app. Run the commands below after fixing compile blockers.

## Basic development checks

```sh
flutter pub get
flutter analyze
flutter test
```

For `dev` and `appLifecycle`, begin by resolving the `Product`, `SummaryPanel`, and `RemoteOrder` named-argument mismatches and the incomplete lifecycle hook. `main` has its own divergence and should be tested independently. Use real Android and iOS runners for embedded WebView and bank app handoffs; `flutter test` cannot reproduce every native redirect.

## Fast unit tests (highest value first)

| Component | Cases |
| --- | --- |
| Product parser | Shopify GID vs bare ID; missing/empty variants; numeric/string amount; null SKU; missing availability |
| Cart operations | Add/merge by variant; decrement to zero; remove; clear; persistence round trip; pending save during archive |
| `RemoteOrder` parser | Each missing required field separately; malformed line items; invalid number/amount; duplicate product variants; zero-price legitimate case |
| Order reconciliation | Match by variant ID; price/currency source of truth; missing local cart; server item list differs from cart; duplicate order ID |
| Checkout coordinator | All legal transitions; duplicate/out-of-order SSE; timeout then late success; two concurrent notifications; stale session event |
| Prefill URI | Existing query preserved; Unicode name; percent encoding; null profile; untrusted-host rejection; sensitive value logging off |
| Config fallback | Empty catalog, fewer than 5 products, non-200, malformed response, network failure |

## Widget tests

- `MainLayout` displays three tabs, preserves tab state, updates when `ShopProvider` notifies listeners.
- Cart totals, disabled checkout progress state, and empty cart handling.
- Order success, failed, and pending screens render from test state; navigation is a one-time effect.
- Manual status retry shows progress and returns meaningful success/failure/unknown instead of a fixed timer.
- Profile save/load, Hungarian/English switching, and address prefilling.

## Integration tests with a fake proxy

1. Stub `GET /products` with a stable product catalog; verify filters, cart, and currency formatting.
2. Stub checkout POST success, HTTP errors, malformed JSON, missing `sessionId`, and missing URL.
3. Substitute a fake SSE stream: event before subscriber, event after subscriber, disconnect, reconnect, duplicates, malformed JSON and wrong-session event.
4. Substitute a status endpoint (after adding it to proxy): pending / confirmed / failed / unavailable, plus restart recovery.
5. Assert **one** order archive and **one** terminal transition when both WebView redirect and SSE signal the same purchase.
6. Explicitly test cancellation: keep cart; do not fabricate order history.

For Go proxy integration, pair Flutter `dev` with proxy `dev`, **not proxy `main`**. Set up a test store and signed webhook. Remove/feature-gate `testSSEDelayed` before treating the result as real checkout evidence.

## Manual device matrix

| Scenario | Android emulator/device | iOS simulator/device | Expected |
| --- | --- | --- | --- |
| Browse catalog / cart | Test | Test | Data loads; cart persists |
| Hosted checkout | Test | Test | WebView loads valid Shopify URL |
| Bank app launch / return | Physical device preferred | Physical device preferred | Resume triggers status recheck, no duplicate navigation |
| Successful verified payment | Test store | Test store | One order, one success screen, cart cleared |
| Cancel / decline | Test store | Test store | No false positive; cart remains |
| Network loss during SSE | Test | Test | Pending/unknown, recheck available |
| App background > timeout / cold restart | Test | Test | Recovers or shows explicitly unknown state |

Record SDK versions, branch SHA, proxy branch SHA, and the exact test-store scenario in each result. Do not mark testing complete because a success screen appeared in response to the proxy's simulated event.
