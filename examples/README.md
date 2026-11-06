# Example Usage

## Dataset

Use `../data/sample_transactions.csv`. It contains synthetic transaction records only.

## SAS example

Open `../sas/aml_data_quality.sas` in a SAS environment and update the relative input path if your working directory differs. The program imports the CSV, separates data-quality exceptions, identifies duplicate transaction IDs, and creates an illustrative review queue.

## Oracle SQL examples

Review `../sql/transaction_analysis_oracle.sql`. Create or load a demo table named `AML_DEMO_TRANSACTIONS` with columns matching the CSV header before running the queries.

## Expected observations

The sample intentionally includes one non-positive amount to demonstrate a data-quality exception. The remaining records can be used to explore customer summaries, high-value review candidates, and cross-border summaries.

All scenario thresholds are illustrative and must not be used as production or regulatory rules.
