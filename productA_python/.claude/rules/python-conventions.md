---
paths:
  - "**/*.py"
---

# Python Conventions

- 4-space indentation; never tabs.
- Type hints on all public functions.
- Pure transform functions where possible; isolate I/O at the edges.
- Tests live beside the module as `test_<module>.py`; cover the empty-input case.
- Read configuration and secrets from the environment, never hard-coded.
