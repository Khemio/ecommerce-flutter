# Checkout flow: state-driven navigation proposal

> **Design proposal, not implemented.** This documents the direction described by the project author: checkout/payment observers update application state, and a *separate* function chooses/pushes the appropriate screen, including `OrderSuccessScreen`. It addresses conflicting WebView, SSE, timer, and app-lifecycle navigation on `dev` and `appLifecycle`.

## The problem with today's flow

The current `CartScreen` posts a cart, starts SSE, then pushes `CheckoutScreen`. The `CheckoutScreen` WebView directly pops routes for thank-you, failure, and off-checkout redirects. Simultaneously, `ShopProvider` directly pushes `OrderSuccessScreen` on `order.created` or pushes `OrderProcessingTimeoutScreen` after 15 minutes. The `appLifecycle` experiment adds a resume hook that attempts to pop the WebView after a status check.

These callbacks are **different observations**, not mutually exclusive sources of truth. They can fire in either order, including after their widget has been removed. A WebView thank-you URL suggests a checkout step completed, but cannot prove that the server confirmed payment. Failure/cancel pages may be ambiguous, particularly when the user switched to an external bank app.

## Recommended scope

Do **not** rewrite all of `ShopProvider`. Introduce a small checkout-specific `CheckoutCoordinator` (`ChangeNotifier`) and `CheckoutRepository` (HTTP/SSE adapter). Keep catalog/cart/profile in `ShopProvider`. Make `CheckoutFlowHost` the only checkout-owned component that reacts to state by navigating; callbacks should *emit events*, not call `Navigator`.

```text
                User taps checkout
                         |
                    CartScreen
                         |
                   startCheckout()
                         v
   +-------------- CheckoutCoordinator ----------------+
   | state = CheckoutSnapshot(sessionId, phase, order) |
   | events: checkoutStarted / urlObserved /           |
   |         orderCreated / statusVerified / timeout / |
   |         appResumed / networkLost / cancelRequested |
   +----------+-------------------------------+-------+
              ^                               |
    CheckoutRepository                         v
   (HTTP, SSE, status GET)           CheckoutFlowHost listener
              ^                               |
    WebView / app lifecycle                     v
         event hooks                   syncNavigation(state)
                                         |      |      |
                                   checkout  result  pending
```

## Proposed state model

| Phase | Meaning | UI behavior |
| --- | --- | --- |
| `idle` | No active checkout | Normal cart |
| `creating` | POST `/checkout` in flight | Disable duplicate checkout and show progress |
| `awaitingPayment` | Checkout URL and session assigned | Hosted WebView / payment-in-progress UI |
| `verifying` | Redirect, resume, or order event suggests progress; backend confirmation pending | Checking / processing UI; do not declare success |
| `confirmed` | Server returned a verifiably completed result | `OrderSuccessScreen`, archive once |
| `failed` | **Authoritatively** failed or user definitely canceled | Failure/cancellation UI with safe retry |
| `unknown` | Timeout/offline/no reliable final answer | Existing `OrderProcessingTimeoutScreen` or renamed `OrderStatusPendingScreen`; manual recheck |

This is a **single active checkout** model for the prototype, not a complete account-order state machine. Keep an immutable snapshot with `sessionId`, optional checkout URL, phase, last error, last update timestamp, and optional verified order. Add a transition revision/sequence number if helpful for deduplicating effects. If a user starts a different checkout, abandon/stop listening to the previous session explicitly.

### Example domain events

- `startCheckout(items)` sets `creating`, calls the proxy, stores `sessionId`/URL, then sets `awaitingPayment` and subscribes to SSE.
- `onCheckoutUrlObserved(url)` requests reconciliation when matching an approved completion/cancellation URL, but never asserts `confirmed` solely from string matching.
- `onOrderCreated(payload, sessionId)` validates the session and order payload, then sets `verifying` and calls a server status API. **Do not convert an `order.created` webhook into `paid` without checking financial status.**
- `onAppResumed()` (from `WidgetsBindingObserver`) schedules reconciliation of the active session. This works even if the checkout WebView was backgrounded by a banking app.
- `onSseTimeout()` sets `unknown` and makes a status recheck available; a 15-minute timer is an observation threshold, **not proof of transaction failure**.
- `onStatusVerified(status)` advances to `confirmed`, `failed`, or keeps `verifying`/`unknown`, according to explicit server semantics.

## One navigation adapter

A single state listener should invoke a function akin to `syncNavigationWithCheckoutState(snapshot)`. The example below is conceptual Dart-style pseudocode, **not a drop-in patch**:

```dart
void syncNavigationWithCheckoutState(CheckoutSnapshot next) {
  if (next.sessionId != activeSessionId) return;
  final destination = switch (next.phase) {
    CheckoutPhase.awaitingPayment => CheckoutRoute.webView,
    CheckoutPhase.verifying => CheckoutRoute.processing,
    CheckoutPhase.confirmed => CheckoutRoute.success,
    CheckoutPhase.failed => CheckoutRoute.failure,
    CheckoutPhase.unknown => CheckoutRoute.pending,
    _ => null,
  };
  if (destination == null || destination == lastRenderedRoute) return;
  lastRenderedRoute = destination;
  // Schedule one navigation command after the current frame and
  // replace/push according to an explicit stack policy.
  navigateTo(destination, next);
}
```

For a practical implementation, have `CheckoutFlowHost` (or a checkout-scoped coordinator at the app shell) subscribe to state changes and use a `NavigatorState`/`GlobalKey` or a carefully owned context. Avoid `Navigator` inside network services and provider models. Route changes need an idempotency guard keyed by **session + destination or revision**, not just by `phase`, because distinct checkouts can reach the same phase. Check `mounted`/navigator availability and trigger navigation outside `build` (e.g., post-frame or a dedicated listener). Decide whether transitions replace the checkout route or retain a back stack; terminal outcomes should not leave an active payment WebView underneath.

**Alternative:** A declarative Navigator/router driven by checkout state can be cleaner long-term, but the listener-plus-one-navigation-function is a smaller refactor consistent with the current app.

## Server contract required before completion

The proxy must provide a reliable **read** endpoint for reconciliation of a session after resume/restart/timeout, and explicit status semantics (see [API integration](API_INTEGRATION.md)). Currently only `order.created` is emitted; the proxy does not prove successful payment. The current `appLifecycle` code calls a missing `checkIfCheckoutIsCompleted(widget.checkoutId)`. Replace this with a real repository method keyed by the **sessionId** the proxy actually returns; do not invent a checkout ID field.

For the demo, a test-only signal can exercise the UI, but its identity must be marked as simulated and must never archive a real-looking paid order.

## State invariants

1. Only one active `sessionId` owns the checkout flow; ignore late messages from earlier sessions.
2. `confirmed` only follows a trustworthy server result; never a URL substring, webhook name, or timer by itself.
3. Archiving/clearing the cart must be **idempotent** for an order ID, and ideally only after confirmation has been persisted.
4. `unknown` is recoverable: app relaunch and manual retry reconcile instead of creating another checkout blindly.
5. Cancelled/failed checkout does not clear the user's cart by accident.
6. Timer, SSE subscription and retry timers must be canceled when the session ends or coordinator is disposed.
7. Network failures and duplicate SSE events are safe: no double archive, double screen push, or back-stack corruption.
8. The UI should never display sensitive personal details in logs or route arguments beyond what is necessary.

## Incremental implementation order

1. Fix the compile errors and SSE start/stop ordering in the existing branch.
2. Disable the proxy's unconditional fake `order.created`; define and implement status verification semantics.
3. Extract checkout network and SSE code from `ShopProvider` into a repository/service; **do not** navigate there.
4. Add `CheckoutSnapshot`/`CheckoutPhase` and event-driven `CheckoutCoordinator` with tests for legal transitions and duplicates.
5. Add one `CheckoutFlowHost` listener and navigation mapping. Convert WebView redirects, app lifecycle resume, SSE and timeout into coordinator calls.
6. Wire real reconciliation, local recovery for pending session, and timeout manual recheck. Test across Android/iOS and external payment-app hand-offs.

## Minimum scenarios to prove

- Normal checkout + verified payment, with SSE arriving before or after WebView redirects.
- An order arrives while the app is backgrounded in a banking app, then the app resumes.
- WebView closes or redirects without a verified status: user sees **pending**, not success.
- User cancels, payment fails, network drops, or SSE times out; cart is preserved and status can be rechecked.
- Repeated `order.created`, repeated lifecycle `resumed`, and repeated HTTP status responses cause only one terminal navigation and one archive.
- User starts checkout A, exits, then starts checkout B; late events for A do not overwrite B's state.
