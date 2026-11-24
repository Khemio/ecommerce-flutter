# Roadmap: Flutter storefront and checkout

Updated **November 24, 2026**. The near-term objective is a presentable portfolio prototype; do not expand scope into an unrelated architectural rewrite.

## Completed / verified storefront baseline

- [x] Fix `Product`, `SummaryPanel`, `RemoteOrder`, add-to-cart and retry-widget constructor mismatches.
- [x] Repair product parsing, type/vendor filtering, sorting, and safe fallback banners for empty/small catalogs.
- [x] Fix SSE listener stop/start ordering and cancel timers/subscriptions on stop/dispose. **Transport behavior not yet integration-tested.**
- [x] Fix pending cart-save timer invalidating remove/clear operations.
- [x] Remove checkout URL logging that could expose user contact/address fields, hidden checkout navigation test gestures and the fake manual status-check control.
- [x] Allow local HTTP in Android **debug** builds only.
- [x] Add model/cart/widget tests and Dart formatting.
- [x] Owner verification: `flutter analyze` clean, `flutter test` **18 passed**, **8/8 manual runtime checks passed**.
- [x] Merge the cleanup work into `dev` via [PR #1](https://github.com/Khemio/ecommerce-flutter/pull/1).
- [x] Integrate the tested baseline into `main` and add checkout HTTP error-path tests.
- [x] Add Flutter GitHub Actions for analysis and tests ([successful run](https://github.com/Khemio/ecommerce-flutter/actions/runs/45433169586)).
- [x] Record and publish catalog, details, cart screenshots, plus an edited short demo (see [media guide](DEMO.md)).

## Remaining: credible checkout semantics

| Priority | Task | Acceptance criteria |
| --- | --- | --- |
| P0 | Establish a real payment-status contract in `ecommerce-proxy` | Session-scoped `pending`, `confirmed`, `failed`, `unknown`, with explicit verified-payment criteria |
| P0 | Guard cart archival and success routing | Never clear cart or announce paid success solely because of `order.created` or a thank-you URL |
| P0 | Fix order reconstruction and idempotency | Use remote variant/order lines, server totals and currency; archive once by verified order ID |
| P1 | Introduce a checkout-specific coordinator | WebView/SSE/timer/lifecycle hooks update state; exactly one host maps state to routes |
| P1 | Implement resume, timeout and manual reconciliation | Pending session can be re-checked after bank app return, delayed webhook, or app restart |
| P1 | Test SSE and navigation races | Duplicates, connection loss, out-of-order events, inactive session, late notifications |
| P1 | Test checkout failure/recovery | No duplicate checkout creation, retain cart on cancellation/unknown, clear error states |
| P2 | Improve API and UI resilience | Typed responses, error handling, more variants/currencies, accessibility and narrow screens |
| P2 | Extend automated verification | Flutter analysis/tests already run in CI; add format enforcement and Go API contract tests when needed |

## Boundaries

- `appLifecycle` is an incomplete experimental branch; do not merge it unchanged.
- `/api/v1/config` is not implemented in the current proxy; Flutter uses a safe local default.
- The cleaned-up Go proxy supports checkout-session creation and SSE, but an **order-creation** event does not certify payment.
- The initial portfolio cleanup does **not** require a live payment or full banking-app handoff demo. Those belong to checkout hardening.
- Avoid unrelated dependency-wide upgrades, redesigns and new infrastructure while stabilizing checkout.

See [checkout state proposal](CHECKOUT_STATE_DESIGN.md) and [testing](TESTING.md).
