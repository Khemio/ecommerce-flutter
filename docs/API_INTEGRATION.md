# Integration with `ecommerce-proxy`

> `ecommerce-flutter` `dev`/`appLifecycle` expects the proxy's **development** checkout-session/SSE contract. The proxy's `main` branch supports browsing and cart creation but **does not** offer `sessionId`, `/events`, or `/shopify/webhook`. The apps are therefore not checkout-compatible if Flutter `dev` is pointed at proxy `main`.

## Configuration

`lib/app_config.dart` defines `apiVer = 'v1'` and `BASE_URL` via `String.fromEnvironment`; the default currently is `http://192.168.100.46:8080`.

| Flutter call | URL | Proxy `main` | Proxy `dev` |
| --- | --- | --- | --- |
| Products | `GET /api/v1/products` | Yes | Yes |
| Promotional layout | `GET /api/v1/config` | No | No (not found in registered routes) |
| Create checkout | `POST /api/v1/checkout` | Yes, without `sessionId` | Yes, with `sessionId` |
| Order notifications | `GET /api/v1/events?sessionId=...` | No | Yes (SSE) |
| Shopify webhook | `POST /api/v1/shopify/webhook` | No | Yes (Shopify-to-proxy only) |

A config 404 currently triggers a client fallback; it should be an explicit feature flag or a server endpoint, not assumed to exist. Product JSON is a Shopify-derived flattened shape; the UI reads the **first** variant and first image.

## Create a checkout

Flutter sends a JSON array using the current `CartScreen._handleCheckout()` implementation:

```http
POST /api/v1/checkout
Content-Type: application/json

[{"variantId":"49175344709849","quantity":2}]
```

It sends `product.variantId`, the **last path segment** of the Shopify GID, not the full GID. The proxy normalizes numeric IDs for Shopify. In proxy `dev`, a successful response has the general form:

```json
{
  "id": "gid://shopify/Cart/example",
  "checkoutUrl": "https://example.myshopify.com/cart/c/example",
  "totalQuantity": 2,
  "sessionId": "a-uuid-generated-by-proxy",
  "attributes": []
}
```

`CartScreen` requires nonempty `sessionId` and `checkoutUrl`, optionally prefills name/email/address using `CheckoutPrefiller`, starts the SSE listener, and pushes the WebView. Proxy `main` returns a checkout URL but lacks `sessionId`, so this client rejects that otherwise successful response.

**Note:** URL parameters contain personal contact/address data and may appear in logs/history. Limit debug logging of prefilled URLs (the current client prints them). Ensure the checkout URL remains on a trusted hosted Shopify domain before opening it.

## Order notifications over SSE (`dev`)

Client connects to:

```http
GET /api/v1/events?sessionId=<uuid>
Accept: text/event-stream
```

Proxy `dev` registers this endpoint and sends heartbeats. After correlating a Shopify webhook to the stored session, it writes an SSE event resembling:

```text
event: order.created
data: {"order_id":"123","order_name":"#1001","order_number":1001,"confirmation_number":"ABC123","total_price":"100.00","currency":"HUF","line_items":[{"product_id":"10","variant_id":"20","title":"Example","quantity":2,"price":"50.00"}]}

```

The client parses this via `RemoteOrder.fromJson`, then archives local history and clears the cart. The proxy carries the `go_session_id` cart attribute into Shopify's order webhook for correlation; this correlation is maintained **in process memory**, not a durable database.

**Important distinctions:**

- `order.created` is an **order creation event**, not proof that `financial_status` is paid. The current proxy webhook maps financial status from Shopify but does not pass it in its SSE `OrderEvent`.
- Proxy `dev` unconditionally invokes `testSSEDelayed(sessionID)` and emits a **fake** `order.created` event after roughly five seconds. This must be disabled or gated to explicit testing before validating purchases.
- A disconnect, process restart, multiple proxy instances, expired session, or client never starting SSE can leave the outcome unknown.
- The client has a 15-minute timeout screen, but its manual-check button currently only delays locally and does not query the proxy.
- No reliable checkout-status lookup endpoint was found on the inspected proxy branch. **Do not add it to API docs as implemented.**

## Proposed reconciliation contract (not implemented)

Introduce an authenticated, session-scoped endpoint such as:

```http
GET /api/v1/checkout/status?sessionId=<uuid>
```

Return a documented, idempotent status for at least `pending`, `confirmed`, `failed`, or `unknown` with a verified order identity and update timestamp, **without** exposing PII or admin credentials. `confirmed` must have explicit server-side criteria (for example, a Shopify-confirmed payment/financial status, if that is the product requirement). The session identifier must not be treated as sufficient authorization for sensitive details.

The client should reconcile on app resume, WebView completion/redirect, SSE disconnect, manual retry, and cold start. Return an unknown/pending state rather than asserting failure when no fresh server signal is available.

## Integration verification checklist

1. Start proxy `dev` with a test Shopify store and webhook secret; remove or feature-gate simulated SSE events.
2. Fetch products with Flutter and verify price strings/variant ID parsing, zero products, and unavailable products.
3. Create checkout and confirm `sessionId` and valid `checkoutUrl` are returned.
4. Confirm SSE actually subscribes, then test webhook-before-subscription and after-subscription ordering.
5. Test successful *verified* payment, bank app return, cancellation, no redirect, network loss, expiration, repeated events, and duplicate resume callbacks.
6. Confirm cart/history change exactly once and that reopening the app recovers a pending checkout without fabricating success.
