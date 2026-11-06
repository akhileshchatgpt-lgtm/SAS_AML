# Synthetic Transaction Data Dictionary

File: `data/sample_transactions.csv`

| Field | Meaning | Example |
|---|---|---|
| transaction_id | Synthetic transaction identifier | TXN1001 |
| customer_id | Synthetic customer identifier | CUST001 |
| transaction_date | ISO date (YYYY-MM-DD) | 2026-10-01 |
| amount | Positive or intentionally invalid demo amount | 12500 |
| currency | Currency code | INR |
| transaction_type | Demonstration transaction category | TRANSFER |
| channel | Demonstration transaction channel | ONLINE |
| country | Origin country code | IN |
| counterparty_country | Counterparty country code | AE |
| customer_risk | Synthetic risk label | HIGH |

All rows are fabricated for software demonstration. Identifiers do not represent real customers or accounts. The sample intentionally includes a zero amount to exercise validation. The dataset is not representative of any institution's customer base or transaction distribution.
