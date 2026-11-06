# Python AML Analytics Demo

Standard-library-only demonstration utilities for synthetic transaction data.

## Requirements

- Python 3.10 or newer
- No third-party packages required

## Run

From the repository root:

```bash
python python/aml_toolkit.py --input data/sample_transactions.csv --output-dir output
```

Optional illustrative threshold:

```bash
python python/aml_toolkit.py --threshold 250000
```

The command writes three JSON files: data-quality exceptions, an illustrative review queue, and customer transaction summaries.

## Tests

```bash
cd python
python -m unittest -v
```

All rules and thresholds are examples only. They are not legal, regulatory, or production alerting rules.
