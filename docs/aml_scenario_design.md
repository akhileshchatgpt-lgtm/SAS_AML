# Illustrative AML Scenario Design

## Purpose

This document describes simple, explainable review scenarios for the synthetic dataset in this repository. These are software demonstrations, not validated typologies, regulatory rules, or production alert thresholds.

## Scenario 1: High-value transaction review

**Intent:** Demonstrate how transactions meeting a configurable amount threshold can be selected for analyst review.

**Demo condition:** `AMOUNT >= 250000`

**Output:** Transaction ID, customer ID, date, amount, currency, and review reason.

**Important:** The threshold is arbitrary sample data. It must not be interpreted as a statutory or institution-approved threshold.

## Scenario 2: High customer-risk review

**Intent:** Demonstrate how a customer risk attribute can be used as one input to a review queue.

**Demo condition:** `CUSTOMER_RISK = 'HIGH'`

**Output:** Transactions associated with customers marked HIGH in the synthetic input.

## Scenario 3: Cross-border activity summary

**Intent:** Summarize transactions where the origin country differs from the counterparty country.

**Demo condition:** `COUNTRY <> COUNTERPARTY_COUNTRY`

**Output:** Count and total value grouped by country pair.

A cross-border transaction is not inherently suspicious. Geography alone must not be treated as evidence of wrongdoing.

## Data quality checks

- Missing transaction or customer identifiers
- Missing transaction date or amount
- Non-positive transaction amount
- Missing currency or transaction type
- Duplicate transaction identifiers

## Production considerations

Before any real-world use, a financial institution would need documented business approval, jurisdiction-specific legal and compliance review, calibrated thresholds, customer and product context, explainability, audit trails, access controls, privacy safeguards, validation, and ongoing model/rule monitoring. Human investigation and institutional procedures remain essential.
