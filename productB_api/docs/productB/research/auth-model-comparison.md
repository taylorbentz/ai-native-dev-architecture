# Research: Auth Model Comparison

Illustrative comparison for the API's authentication approach.

| Model | Pros | Cons | Fit |
|---|---|---|---|
| Session cookies | simple, server-controlled revocation | sticky sessions, CSRF care | good for first-party web |
| Bearer tokens (JWT) | stateless, easy across services | revocation is harder | good for service-to-service |
| Delegated (OAuth) | no password handling | most setup | good for third-party access |

**Decision:** bearer tokens for service-to-service traffic, short-lived with refresh; revisit delegated
auth if third-party integrations appear. Recorded so the reasoning outlives the decision.
