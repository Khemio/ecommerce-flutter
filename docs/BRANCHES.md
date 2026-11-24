# Branch history and integration status

Updated **November 24, 2026**. The earlier November 14 source review was made before the Flutter cleanup and before the Go proxy's session/SSE features reached its `main` branch.

| Branch | Role |
| --- | --- |
| `main` | Default release/portfolio branch; the proposed integration includes the tested `dev` implementation and updated documentation |
| `dev` | Main development baseline; includes Flutter cleanup PR #1 and the initial checkout SSE / result-screen implementation |
| `cleanup/cv-ready` | Completed cleanup branch, merged into `dev` by [PR #1](https://github.com/Khemio/ecommerce-flutter/pull/1) |
| `appLifecycle` | Historical unfinished experiment with app-resume checkout verification, **not merged** |

## Verified cleanup

- Fixed named-argument compilation errors, unsafe product parsing, vendor filtering, and empty/short catalog banner fallback.
- Corrected SSE startup ordering and canceled subscriptions/reconnection timers on stop/dispose. **SSE delivery and payment-result correctness have not been tested end to end.**
- Fixed cart persistence when remove/clear races with a pending debounced save.
- Removed sensitive prefilled checkout URL logging, test-only checkout gestures, and the unimplemented manual-check button.
- Added product, remote-order, cart-provider, and widget tests; formatted Dart files and enabled HTTP in Android **debug builds only**.
- Owner-reported checks: **zero analyzer issues, eleven passing tests, eight passing runtime smoke-test scenarios**.

## Remaining unfinished checkout work

The current `dev` checkout flow requires a nonempty `sessionId` and `checkoutUrl` from `POST /api/v1/checkout`, then opens Shopify's hosted checkout and subscribes to `GET /api/v1/events?sessionId=...`. The Go proxy `main` now exposes this contract; it did not when the older branch documentation was written.

The `order.created` SSE event represents an order-creation notification, **not verified payment**. Flutter still has competing WebView/SSE navigation callbacks and archives/clears the local cart on the order-created path. This is unsafe for a production checkout. There is no payment-status read endpoint for resume/retry reconciliation.

The `appLifecycle` branch references a missing `widget.checkoutId` and unimplemented `ShopProvider.checkIfCheckoutIsCompleted()`; it must not be merged as-is. See [the state-driven checkout proposal](CHECKOUT_STATE_DESIGN.md) and [roadmap](ROADMAP.md).

## Integration policy

Bring the tested development baseline and this documentation together on a dedicated integration branch, review the pull request, and merge into `main` only after confirming the combined tree. Do not interpret the storefront smoke test as verification of payment, webhooks, or bank redirects.
