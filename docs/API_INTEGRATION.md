# Integration with `ecommerce-proxy`

Updated **November 24, 2026** against the `main` branches of the Go proxy and the cleaned-up Flutter client. Checkout URL creation was smoke-tested; **payment completion and webhook/SSE end-to-end behavior were not**.

## Compatibility

| Client operation | API path | Proxy `main` support |
| --- | --- | --- |
| Products | `GET /api/v1/products` | Yes |
| Product detail | `GET /api/v1/product/{product_id}` | Yes |
| Create checkout | `POST /api/v1/checkout` | Yes: `sessionId` and `checkoutUrl` |
| Order notifications | `GET /api/v1/events?sessionId=...` | Yes: SSE |
| Shopify webhook | `POST /api/v1/shopify/webhook` | Yes: HMAC verification |
| Promotional configuration | `GET /api/v1/config` | **No**; Flutter uses a local fallback |
| Authoritative payment/status reconciliation | Not defined | **No** |

The Go proxy now provides the session/SSE API on `main` (unlike the earlier November 14 review). The Flutter client's default base URL is `http://localhost:8080`; override via `--dart-define=BASE_URL=...`. The Android emulator reaches the Windows host via `10.0.2.2`.

## Products

`GET /api/v1/products` returns a JSON array of flattened Shopify-derived products. The client reads `id`, `title`, `description`, `productType`, `vendor`, `availableForSale`, `images[]`, and the **first** `variants[]` item, including `id`, nullable `sku`, and `price.amount`. It does not currently provide a multiple-variant picker. Missing image and SKU values are handled safely; parsed prices use `double` in this prototype.

## Checkout creation

```http
POST /api/v1/checkout
Content-Type: application/json

[{"variantId":"49175344709849","quantity":2}]
```

The client sends the last segment of the Shopify variant GID. The Go proxy validates each line, creates a Shopify cart and returns a session identifier and hosted checkout URL, including fields resembling:

```json
{
  "sessionId": "uuid-from-proxy",
  "id": "gid://shopify/Cart/example",
  "checkoutUrl": "https://example.myshopify.com/cart/c/example",
  "totalQuantity": 2,
  "attributes": []
}
```

Flutter requires nonempty `sessionId` and `checkoutUrl`, starts the SSE listener, and opens `CheckoutScreen` (WebView). Checkout URL creation and navigation were manually smoke-tested; **no payment was performed as part of that test**.

Profile prefilling may place customer name/address/email into URL query parameters. The previous full checkout-URL debug log was removed. Avoid logging or exposing these URLs elsewhere.

## SSE order notification

```http
GET /api/v1/events?sessionId=<uuid>
Accept: text/event-stream
```

The proxy can correlate a signed Shopify order webhook to an in-memory session and send an event:

```text
event: order.created
data: {"order_id":"123","order_name":"#1001","order_number":1001,"confirmation_number":"ABC123","total_price":"100.00","currency":"HUF","line_items":[{"product_id":"10","variant_id":"20","title":"Example","quantity":2,"price":"50.00"}]}
```

**An `order.created` event is not a `paid` event.** The current event contract does not prove successful payment. The proxy may lose session state on restart or multi-instance routing, and the client still makes order-history/cart mutations and route transitions from this provisional event. Do not demonstrate or describe these as verified payment completion.

The first SSE startup/stop-ordering defect and timer cleanup were fixed in Flutter, but reconnection, duplicates, webhook-before-subscribe, and payment outcomes need integration tests.

## Configuration

`/api/v1/config` is not available on the Go proxy. Flutter now builds a local promotion set from up to five products, including empty catalogs, by default. Only a compatible experimental backend should be used with `--dart-define=ENABLE_REMOTE_CONFIG=true`.

## Required future backend contract

Define a secured, session-scoped status lookup with clear `pending`, `confirmed`, `failed` and `unknown` semantics and a server-verified criterion for `confirmed`. The URL, endpoint, response schema, and authorization are **not yet implemented**. The checkout coordinator should reconcile on redirect, app resume, timeout, reconnect, and restart. Cart archival and success UI must be idempotent and follow verification.

See [Checkout state design](CHECKOUT_STATE_DESIGN.md) and [Roadmap](ROADMAP.md).
