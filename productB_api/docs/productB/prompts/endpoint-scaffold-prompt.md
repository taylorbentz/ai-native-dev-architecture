# Prompt: Scaffold a New Endpoint

> Add a new endpoint `<METHOD> <path>`. Spec-first: add it to the OpenAPI spec, then create the handler
> under `src/routes/`, validating input at the boundary and returning a structured error on bad input.
> Add a test. Run `/api-contract-check` to confirm the handler and spec agree.
