/*
  Independent AML analytics examples for Oracle SQL.
  Source table assumption: AML_DEMO_TRANSACTIONS
  Columns match data/sample_transactions.csv.
  Load only synthetic or appropriately licensed data.
*/

/* 1. Basic transaction volume and value by customer */
SELECT
    CUSTOMER_ID,
    COUNT(*) AS TRANSACTION_COUNT,
    SUM(AMOUNT) AS TOTAL_AMOUNT,
    AVG(AMOUNT) AS AVG_AMOUNT
FROM AML_DEMO_TRANSACTIONS
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_AMOUNT DESC;

/* 2. Illustrative high-value / high-risk review candidates.
   250000 is a demonstration parameter, not a regulatory threshold. */
SELECT
    TRANSACTION_ID,
    CUSTOMER_ID,
    TRANSACTION_DATE,
    AMOUNT,
    CURRENCY,
    CUSTOMER_RISK,
    COUNTRY,
    COUNTERPARTY_COUNTRY,
    CASE
        WHEN AMOUNT >= 250000 AND UPPER(CUSTOMER_RISK) = 'HIGH'
            THEN 'DEMO_HIGH_VALUE_AND_HIGH_RISK'
        WHEN AMOUNT >= 250000
            THEN 'DEMO_HIGH_VALUE'
        WHEN UPPER(CUSTOMER_RISK) = 'HIGH'
            THEN 'DEMO_HIGH_CUSTOMER_RISK'
    END AS REVIEW_REASON
FROM AML_DEMO_TRANSACTIONS
WHERE AMOUNT >= 250000
   OR UPPER(CUSTOMER_RISK) = 'HIGH'
ORDER BY AMOUNT DESC;

/* 3. Cross-border transaction summary */
SELECT
    COUNTRY,
    COUNTERPARTY_COUNTRY,
    COUNT(*) AS TRANSACTION_COUNT,
    SUM(AMOUNT) AS TOTAL_AMOUNT
FROM AML_DEMO_TRANSACTIONS
WHERE COUNTRY <> COUNTERPARTY_COUNTRY
GROUP BY COUNTRY, COUNTERPARTY_COUNTRY
ORDER BY TOTAL_AMOUNT DESC;

/* 4. Data quality: non-positive or missing amounts */
SELECT *
FROM AML_DEMO_TRANSACTIONS
WHERE AMOUNT IS NULL
   OR AMOUNT <= 0;

/* 5. Duplicate transaction identifiers */
SELECT
    TRANSACTION_ID,
    COUNT(*) AS DUPLICATE_COUNT
FROM AML_DEMO_TRANSACTIONS
GROUP BY TRANSACTION_ID
HAVING COUNT(*) > 1;
