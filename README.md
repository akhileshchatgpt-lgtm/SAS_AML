# Independent AML Analytics Toolkit

An educational, open-source demonstration of AML data engineering and transaction-monitoring concepts using synthetic transaction data.

> **Status:** Early-stage project. Python examples and tests are included; SAS and Oracle SQL examples are provided but have not been executed in a licensed SAS or Oracle environment. This is not a production AML system.

## What is included

| Area | Example |
|---|---|
| Synthetic data | `data/sample_transactions.csv` |
| SAS | Data-quality checks and illustrative review queue in `sas/aml_data_quality.sas` |
| Oracle SQL | Customer summaries, cross-border summaries, duplicate and amount checks in `sql/transaction_analysis_oracle.sql` |
| Python | Standard-library toolkit in `python/aml_toolkit.py` |
| Tests | Python unit tests in `python/test_aml_toolkit.py` |
| Scenario notes | `docs/aml_scenario_design.md` |

## Quick start (Python)

Requires Python 3.10+ and no third-party dependencies. From the repository root:

```bash
python python/aml_toolkit.py --input data/sample_transactions.csv --output-dir output
```

Optional illustrative threshold:

```bash
python python/aml_toolkit.py --threshold 250000
```

The command creates:
- `output/data_quality_exceptions.json`
- `output/demo_review_queue.json`
- `output/customer_summary.json`

Run tests:

```bash
cd python
python -m unittest -v
```

A GitHub Actions workflow runs the Python unit tests on relevant pushes and pull requests.

## SAS example

Open `sas/aml_data_quality.sas` in a SAS environment. Update the CSV path in the `PROC IMPORT` step to the actual location accessible to the SAS session. The program separates data-quality exceptions, deduplicates valid transaction IDs, and creates a demonstration review queue.

## Oracle SQL example

See `sql/transaction_analysis_oracle.sql`. Create and load a demonstration table named `AML_DEMO_TRANSACTIONS` with columns matching the CSV header before running the queries.

## Demonstration rules and limitations

The sample threshold of INR 250,000 and the HIGH customer-risk flag are illustrative parameters only. They are not legal reporting thresholds, regulatory interpretations, or validated detection rules. Cross-border activity is not inherently suspicious. The sample data is synthetic and must not be used to infer real-world risk.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Contributions should be original, tested, explainable, and use synthetic or appropriately licensed data.

## Responsible use and disclaimer

- Never upload customer, account, payment, personal, employer, or client-confidential data.
- Do not upload proprietary SAS AML source code, product binaries, internal configurations, or employer-owned materials.
- This repository is independent and is not affiliated with, sponsored by, or endorsed by SAS Institute or any financial institution.
- This toolkit is for education and software demonstration only. It is not legal, compliance, or financial advice and is not suitable for production decisions without institutional validation, governance, security review, and human oversight.

## License

MIT. See [LICENSE](LICENSE).
