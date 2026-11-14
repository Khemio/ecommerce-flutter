# Roadmap: stabilize first, then complete checkout

This is a prioritized set of **proposed** issues, not a claim that GitHub issues were created. The immediate goal is a presentable, functional Flutter/Go prototype. Avoid adding a heavyweight state management or navigation framework until the current flow is correct.

## P0 — blockers / correctness before a demo

| ID | Task | Why / acceptance criteria |
| --- | --- | --- |
| F-01 | Fix Flutter constructor/named-argument mismatches | `Product`, `SummaryPanel`, and `RemoteOrder` have named-argument inconsistencies on inspected branches. `flutter analyze` succeeds and app starts on target device. |
| F-02 | Fix SSE listener startup and cleanup | `listenToSSE()` must stop the old connection **before** setting `_isExplicitlyStopped=false`; subscribing actually occurs; timers/subscriptions are disposed. |
| F-03 | Remove or explicitly gate proxy's fake `order.created` test event | `ecommerce-proxy/dev` currently schedules it on **every** checkout. Production-like test flows must not report a paid order from synthetic data. |
| F-04 | Establish authoritative checkout verification semantics | WebView `/thank_you` and `order.created` are hints, not proof of payment; proxy must distinguish paid/confirmed, failed/canceled and pending/unknown. |
| F-05 | Repair or isolate `appLifecycle` WIP | Missing `widget.checkoutId` and `ShopProvider.checkIfCheckoutIsCompleted()` must be replaced with a real `sessionId`-based status flow, or exclude the branch from builds. |
| F-06 | Make remote order parsing and archival safe | Stop overwriting `RemoteOrder.dataIsValid`; derive receipt from verified server line items; handle variants, prices/currency, duplicates, and empty local cart. |
| F-07 | Fix cart/order handling after interrupted checkout | Do not clear cart on unverified event; preserve cart on failure/unknown; archive at most once; avoid losing an order if one preference write fails. |

## P1 — necessary for a robust portfolio prototype

| ID | Task | Acceptance criteria |
| --- | --- | --- |
| F-08 | Extract checkout state coordinator and one navigation function | WebView, SSE, lifecycle, and timeout **update state**; one checkout flow host performs route transitions, idempotently. |
| F-09 | Add status reconciliation API and manual retry | Backend can answer a session's status; resume, timeout button and cold start use the same method. Never show an unverified success. |
| F-10 | Make SSE reconnect deterministic | Bounded backoff; stop/cancel all pending timers; no reconnect after disposal/terminal state; webhook-before-SSE tested. |
| F-11 | Define explicit errors/recovery UX | Distinguish declined, canceled, network/offline, slow processing and server errors. Failure page navigation always reaches a usable screen. |
| F-12 | Replace default widget test, add focused unit tests | Parser, cart, coordinator, navigation deduplication and retry/timeout have passing tests; include a proxy contract test. |
| F-13 | Resolve branch divergence intentionally | Compare `main` with `dev`; do not merge `appLifecycle` as-is; document the tested Flutter/proxy branch pairing. |
| F-14 | Fix configuration endpoint/fallback | Implement `/config` in proxy or remove call; safely handle catalogs of 0–4 products. |
| F-15 | Remove sensitive checkout URL logging | Full prefilled URLs include email/address; logs use redacted URL/metadata only. |

## P2 — worthwhile, bounded improvements

| ID | Task | Acceptance criteria |
| --- | --- | --- |
| F-16 | Add consistent HTTP client and timeouts | Centralize typed DTOs, timeout/cancellation, error mapping and testable transport; no naked network calls in widgets. |
| F-17 | Persist pending checkout context carefully | Restart restores session and performs verified reconciliation; expiration and privacy policy are explicit. |
| F-18 | Refine product/variant and money models | Multiple variants, nullable Shopify fields, availability, integer-minor-unit/decimal currency handling, and server totals are modeled correctly. |
| F-19 | Improve accessibility and layout | Small screens, keyboard behavior, touch target sizes, semantic labels, and both language variants are tested. |
| F-20 | Provide automated checks | CI runs formatting, `flutter analyze`, unit/widget tests, and Go proxy contract tests. |

## Suggested milestones

### Milestone A — reproducible working client

- Resolve compilation and default SDK setup; establish `flutter analyze` pass.
- Fix SSE startup, subscription cancellation and obvious data model errors.
- Run product browsing/cart and a **simulation-labeled** checkout outcome against a safe test double.

### Milestone B — trustworthy checkout behavior

- Implement/verify proxy-side status lookup and remove unconditional fake success notifications.
- Add coordinator, lifecycle resume reconciliation and a single route-transition function.
- Implement failed/unknown/retry flows; test bank redirect, SSE delay, app background and duplicated messages.

### Milestone C — presentable and maintainable project

- Add automated tests, error/loading states, configuration strategy, privacy cleanup and branch integration.
- Update root README with actual tested platforms, screenshots (if permitted) and a concise architecture explanation.

## Explicit non-goals for this pass

Do not introduce cloud databases, account synchronization, another payment processor, complex routing frameworks, analytics infrastructure, or a broad UI redesign solely to repair this checkout flow. Those can follow after the internship prototype has a correct, testable lifecycle.

## Companion proxy dependencies

- `ecommerce-proxy/dev`: remove `testSSEDelayed(sessionID)` from ordinary checkout handling; preserve a safe test-only mode.
- Add a reliable, authenticated-enough session status contract and financial-status mapping; decide when order creation differs from successful payment.
- Consider persistent/replicated checkout sessions if deploying multiple instances or relying on recovery after restart.
- Update the proxy's existing `docs/DEVELOPMENT_BRANCHES.md` and `docs/API.md` when these endpoint contracts are implemented.
