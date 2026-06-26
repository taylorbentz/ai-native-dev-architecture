# Research: DataFrame Library Options

Illustrative decision write-up — the kind of artifact that lives in `docs/<product>/research/`.

| Option | Pros | Cons | Verdict |
|---|---|---|---|
| Standard library only | zero deps, simple | manual joins/aggregations | good for small jobs |
| A columnar dataframe lib | fast, expressive | dependency weight | chosen for larger stages |
| A lazy/streaming engine | scales past memory | newer, smaller community | revisit if data grows |

**Decision:** standard library for the small normalization stages; adopt a columnar library only where
profiling shows it's needed. Recorded here so the next engineer sees the reasoning, not just the result.
