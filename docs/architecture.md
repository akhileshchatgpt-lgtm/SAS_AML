# Architecture Overview

## Scope

The repository demonstrates a small, file-based workflow. It does not connect to a bank, payment network, SAS AML installation, production database, or external screening service.

## Data flow

1. Read the synthetic CSV file.
2. Validate required fields, dates, amounts, and duplicate transaction IDs.
3. Generate transparent demonstration review candidates using configurable amount and customer-risk flags, plus cross-border context.
4. Aggregate positive transaction amounts by customer.
5. Write JSON outputs for inspection.

## Components

- `data/sample_transactions.csv`: synthetic input
- `python/aml_toolkit.py`: standard-library implementation
- `python/test_aml_toolkit.py`: unit tests
- `sas/aml_data_quality.sas`: independent SAS-language demonstration
- `sql/transaction_analysis_oracle.sql`: Oracle SQL examples

## Important limitations

The rules are deterministic examples, not a trained model, validated typology, regulatory threshold, or production alerting system. No automated conclusion of suspicious activity is made. Human review, institutional policy, legal analysis, data governance, model validation, security controls, and auditability would be required before any real-world deployment.
