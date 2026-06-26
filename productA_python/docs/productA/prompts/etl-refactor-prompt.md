# Prompt: Refactor an ETL Stage

Reusable prompt for splitting a monolithic ETL step into pure transform + thin I/O wrapper.

> Refactor `src/etl/<module>.py` so the transformation logic is a pure function with no I/O, and the
> reading/writing happens in a thin wrapper. Preserve behavior exactly. Add a test for the empty-input
> case. Run `/etl-validate` when done.
