# Research: Multi-Region Tradeoffs

Illustrative write-up weighing single- vs multi-region deployment.

| Approach | Pros | Cons |
|---|---|---|
| Single region | simplest, cheapest | regional outage = full outage |
| Active/passive | failover safety net | passive capacity mostly idle |
| Active/active | resilient, low latency | data consistency is hard, costly |

**Decision:** start single-region with infrastructure written so a second region is additive, not a
rewrite; revisit active/passive when an availability target demands it. Documented to capture the "why".
