# Environment Dependencies product migration

## Boundary

New consumers must depend on and import one of the focused products:

- `Environment Dependencies Core` / `Environment_Dependencies_Core` for `EnvVars`,
  dictionary and scalar behavior, process-only `live()`, and `\.envVars`.
- `Environment Dependencies Foundation Integration` /
  `Environment_Dependencies_Foundation_Integration` when URL, file/dotenv overlay,
  `allowedInsecureHosts`, or `\.projectRoot` behavior is required. This leaf depends on
  and exposes Core; Core has no reverse edge.

The existing `Environment Dependencies` / `Environment_Dependencies` product and target
are deprecated compatibility-only migration debt. The target contains only explicit
re-exports of Core and Foundation Integration and must receive no new behavior or consumers.

## Committed consumer census

The census was performed on 2026-07-16 with `git grep ... HEAD` across repositories under
`/Users/coen/Developer`. It therefore records committed bytes only; every uncommitted working-
tree change is excluded. The package itself is excluded from the consumer totals. Seven
repositories select the legacy product in nine manifest locations and contain 42 committed
source/test import files. No committed `Environment_Dependencies.` module-qualified symbol
reference was found.

| Repository | Commit | Tree | Import files | Product selections |
|------------|--------|------|-------------:|-------------------:|
| `swift-github-live` | `51bc9a193d1691338b78cf21acf49bf03645f7ff` | `d30d5d417a169f5c648b7a2489b6a3d06681d3e0` | 2 | 1 |
| `swift-mailgun` | `29fb2eb658a3b809cf3ef2a9b61629c81e4889e9` | `a7ce5fca3e38dd87912a3539d8b8a7153428f32d` | 1 | 1 |
| `swift-mailgun-live` | `5f5f663ec2a65baabf2056d8f60664c95cf5d6fc` | `9e0f4bd191b5a2bbfabc02cce703b3ad189c0beb` | 3 | 1 |
| `swift-records` | `679c17f2175f079a48dfd7129a81b63e3cff5421` | `2d92fd2fe89ba9cd1580acaa50db26a45ad48cd1` | 5 | 3 |
| `swift-server-foundation` | `781565c82111579cf2748af82e0c08b400095019` | `3d26c89c035336888b3cc6d721a61245f88e6639` | 1 | 1 |
| `swift-stripe` | `d4b0d07371a82048dbfdfef2c0a8369ad58c131f` | `fa4c0233969ded0ea41543e10cbd6de5aa96866b` | 13 | 1 |
| `swift-stripe-live` | `2c5e62bdbd32a7faf4a06551a8ee70e8f9a6c99c` | `c59cc32f89dda4f8e2dd96a0a9fedc1e2a266745` | 17 | 1 |

### Exact manifest files

- `swift-github-live/Package.swift`
- `swift-mailgun/Package.swift`
- `swift-mailgun-live/Package.swift`
- `swift-records/Package.swift`
- `swift-records/Tests/Package.swift` (two selected-product target dependencies)
- `swift-server-foundation/Package.swift`
- `swift-stripe/Package.swift`
- `swift-stripe-live/Package.swift`

### Exact import files

`swift-github-live`:

- `Sources/GitHub Live Shared/EnvironmentVariables+Testing.swift`
- `Sources/GitHub Live Shared/exports.swift`

`swift-mailgun`:

- `Sources/Mailgun Shared/exports.swift`

`swift-mailgun-live`:

- `Sources/Mailgun Shared Live/EnvironmentVariables.swift`
- `Tests/Mailgun Live Tests/ReadmeVerificationTests.swift`
- `Tests/Mailgun Live Tests/Sandbox Reset Test.swift`

`swift-records`:

- `Sources/Records/Core/PostgresClient.Configuration+Environment.swift`
- `Tests/Records Test Support/exports.swift`
- `Tests/Records Tests/Integration/Database/ConfigurationTests.swift`
- `Tests/Records Tests/Support/support.swift`
- `Tests/Records Tests/TestInfrastructure/BasicTests.swift`

`swift-server-foundation`:

- `Sources/ServerFoundationEnvVars/exports.swift`

`swift-stripe`:

- `Sources/Stripe Shared/EnvironmentVariables.swift`
- `Sources/Stripe Web Elements/Stripe Web Elements Address/Address+HTML.swift`
- `Sources/Stripe Web Elements/Stripe Web Elements Currency Selector/CurrencySelector+HTML.swift`
- `Sources/Stripe Web Elements/Stripe Web Elements Express Checkout/ExpressCheckout+HTML.swift`
- `Sources/Stripe Web Elements/Stripe Web Elements Link Authentication/LinkAuthentication+HTML.swift`
- `Sources/Stripe Web Elements/Stripe Web Elements Payment Method Messaging/PaymentMethodMessaging+HTML.swift`
- `Sources/Stripe Web Elements/Stripe Web Elements Payment/Payment+HTML.swift`
- `Sources/Stripe Web Elements/Stripe Web Elements Tax ID/TaxID+HTML.swift`
- `Tests/Stripe Checkout Sessions Tests/Stripe Checkout Sessions Client Tests.swift`
- `Tests/Stripe Customers Tests/Stripe Customers Client Tests.swift`
- `Tests/Stripe Products Tests/Stripe Products Prices Tests/Stripe Products Prices Client Tests.swift`
- `Tests/Stripe Products Tests/Stripe Products Products Tests/Stripe Products Products Client Tests.swift`
- `Tests/Stripe Tests/Stripe Billing Subscriptions Client Tests.swift`

`swift-stripe-live`:

- `Sources/Stripe Live Shared/EnvironmentVariables.swift`
- `Sources/Stripe Live Shared/exports.swift`
- `Tests/Stripe Customers Live Tests/Stripe Customers Client Tests.swift`
- `Tests/Stripe Live Shared Tests/URLRequest Handler Stripe Rate Limit Tests.swift`
- `Tests/Stripe Live Tests/ReadmeVerificationTests.swift`
- `Tests/Stripe Live Tests/Simple Rate Limit Test.swift`
- `Tests/Stripe Live Tests/Stripe Billing Subscriptions Client Integration Tests.swift`
- `Tests/Stripe Live Tests/Stripe Checkout Sessions Client Integration Tests.swift`
- `Tests/Stripe Live Tests/Stripe Payment Intents Client Integration Tests.swift`
- `Tests/Stripe Live Tests/Stripe Rate Limit Extreme Tests.swift`
- `Tests/Stripe Live Tests/Stripe Rate Limit Production Test.swift`
- `Tests/Stripe Live Tests/Stripe Rate Limit Stress Tests.swift`
- `Tests/Stripe Live Tests/Stripe Rate Limit Within Limits Tests.swift`
- `Tests/Stripe Live Tests/Stripe Rate Limiting Integration Tests.swift`
- `Tests/Stripe Products Live Tests/Stripe Products Prices Live Tests/Stripe Products Prices Client Tests.swift`
- `Tests/Stripe Products Live Tests/Stripe Products Products Live Tests/Stripe Products Products Client Tests.swift`
- `Tests/Stripe Products Live Tests/Test Handler Decode.swift`

## Retirement gate

Remove the compatibility facade only when all of the following are simultaneously true:

1. Every repository consumer in a fresh committed census has migrated to an explicit Core or
   Foundation Integration product/import, and the legacy product has zero selected-product
   consumers.
2. The target graph proves there is no Core-to-Foundation-Integration edge.
3. The compatibility compile fixture remains green immediately before removal.
4. Removal occurs in a separately versioned breaking release.

Consumer migration is deliberately outside the additive boundary change that introduced these
products.
