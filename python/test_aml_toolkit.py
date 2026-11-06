"""Unit tests for the independent AML demo toolkit."""
import unittest
from decimal import Decimal

from aml_toolkit import (
    build_review_queue, customer_summary, validate_transactions,
)

BASE = {
    "transaction_id": "T1", "customer_id": "C1",
    "transaction_date": "2026-10-01", "amount": "12500",
    "currency": "INR", "transaction_type": "TRANSFER",
    "country": "IN", "counterparty_country": "IN",
    "customer_risk": "LOW",
}


class AMLToolkitTests(unittest.TestCase):
    def test_non_positive_amount_is_exception(self):
        row = dict(BASE, amount="0")
        result = validate_transactions([row])
        self.assertIn("NON_POSITIVE_AMOUNT", result[0]["reasons"])

    def test_duplicate_identifier_is_flagged(self):
        result = validate_transactions([dict(BASE), dict(BASE, customer_id="C2")])
        self.assertIn("DUPLICATE_TRANSACTION_ID", result[1]["reasons"])

    def test_invalid_date_is_flagged(self):
        result = validate_transactions([dict(BASE, transaction_date="not-a-date")])
        self.assertIn("INVALID_TRANSACTION_DATE", result[0]["reasons"])

    def test_review_queue_explains_reasons(self):
        row = dict(BASE, amount="300000", customer_risk="HIGH",
                   counterparty_country="AE")
        result = build_review_queue([row], Decimal("250000"))
        self.assertEqual(
            result[0]["review_reasons"],
            "DEMO_HIGH_VALUE;DEMO_HIGH_CUSTOMER_RISK;DEMO_CROSS_BORDER",
        )

    def test_customer_summary_uses_decimal_totals(self):
        rows = [dict(BASE, amount="0.10"), dict(BASE, transaction_id="T2",
                amount="0.20")]
        result = customer_summary(rows)
        self.assertEqual(result[0]["total_amount"], "0.30")
        self.assertEqual(result[0]["transaction_count"], "2")

    def test_invalid_amount_is_not_in_review_queue(self):
        result = build_review_queue([dict(BASE, amount="not-money")])
        self.assertEqual(result, [])


if __name__ == "__main__":
    unittest.main()
