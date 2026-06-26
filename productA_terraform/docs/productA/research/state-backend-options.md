# Research: State Backend Options

Illustrative comparison of where to keep infrastructure state.

| Option | Pros | Cons |
|---|---|---|
| Local file | trivial | no locking, not shared, easy to lose |
| Remote object store + lock | shared, locked, durable | one-time setup |
| Managed remote backend | zero-ops, built-in locking | vendor coupling |

**Decision:** remote object store with locking — shared and safe without vendor lock-in. Documented so
the tradeoff is visible to future maintainers.
