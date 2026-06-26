# Research: State Management Survey

Illustrative survey of approaches for sharing state across the UI.

| Approach | Pros | Cons |
|---|---|---|
| Local component state | simplest, no deps | doesn't share across the tree |
| Built-in context | shared, no deps | re-renders if not scoped carefully |
| External store library | powerful, devtools | extra dependency + concepts |

**Decision:** local state by default, built-in context for a handful of truly shared values, and reach
for an external store only if profiling shows it's warranted. Recorded so the default is a deliberate
choice rather than an accident.
