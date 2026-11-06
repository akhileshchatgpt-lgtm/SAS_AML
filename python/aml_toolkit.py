"""Independent AML analytics demo using synthetic transaction data only.

This module is educational software, not a production AML control or legal advice.
It uses only the Python standard library.
"""
from __future__ import annotations

import argparse
import csv
import json
from collections import Counter, defaultdict
from datetime import date
from decimal import Decimal, InvalidOperation
from pathlib import Path
from typing import Iterable

REQUIRED_FIELDS = (
    "transaction_id", "customer_id", "transaction_date", "amount",
    "currency", "transaction_type", "country", "counterparty_country",
    "customer_risk",
)


def parse_amount(value: str) -> Decimal | None:
    """Parse a monetary value without binary floating-point rounding."""
    try:
        return Decimal(value.strip())
    except (InvalidOperation, AttributeError):
        return None


def load_transactions(path: str | Path) -> list[dict[str, str]]:
    with Path(path).open("r", newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if not reader.fieldnames:
            raise ValueError("CSV has no header row")
        missing = sorted(set(REQUIRED_FIELDS) - set(reader.fieldnames))
        if missing:
            raise ValueError("Missing required columns: " + ", ".join(missing))
        return [{key: (value or "").strip() for key, value in row.items()}
                for row in reader]


def validate_transactions(rows: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    """Return one exception record per invalid row, preserving source row number."""
    exceptions: list[dict[str, str]] = []
    seen_ids: set[str] = set()
    for row_number, row in enumerate(rows, start=2):
        reasons: list[str] = []
        for field in ("transaction_id", "customer_id", "transaction_date",
                      "amount", "currency", "transaction_type"):
            if not row.get(field, "").strip():
                reasons.append(f"MISSING_{field.upper()}")

        raw_amount = row.get("amount", "")
        amount = parse_amount(raw_amount)
        if raw_amount and amount is None:
            reasons.append("INVALID_AMOUNT")
        elif amount is not None and amount <= 0:
            reasons.append("NON_POSITIVE_AMOUNT")

        raw_date = row.get("transaction_date", "")
        if raw_date:
            try:
                date.fromisoformat(raw_date)
            except ValueError:
                reasons.append("INVALID_TRANSACTION_DATE")

        transaction_id = row.get("transaction_id", "")
        if transaction_id:
            if transaction_id in seen_ids:
                reasons.append("DUPLICATE_TRANSACTION_ID")
            seen_ids.add(transaction_id)

        if reasons:
            exceptions.append({
                "row_number": str(row_number),
                "transaction_id": transaction_id,
                "customer_id": row.get("customer_id", ""),
                "reasons": ";".join(reasons),
            })
    return exceptions


def build_review_queue(
    rows: Iterable[dict[str, str]],
    amount_threshold: Decimal = Decimal("250000"),
) -> list[dict[str, str]]:
    """Create transparent demo review candidates; threshold is not regulatory."""
    queue: list[dict[str, str]] = []
    for row in rows:
        amount = parse_amount(row.get("amount", ""))
        if amount is None or amount <= 0:
            continue
        reasons: list[str] = []
        if amount >= amount_threshold:
            reasons.append("DEMO_HIGH_VALUE")
        if row.get("customer_risk", "").upper() == "HIGH":
            reasons.append("DEMO_HIGH_CUSTOMER_RISK")
        if (row.get("country") and row.get("counterparty_country")
                and row["country"].upper() != row["counterparty_country"].upper()):
            reasons.append("DEMO_CROSS_BORDER")
        if reasons:
            item = dict(row)
            item["review_reasons"] = ";".join(reasons)
            queue.append(item)
    return queue


def customer_summary(rows: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    totals: dict[str, Decimal] = defaultdict(Decimal)
    counts: Counter[str] = Counter()
    for row in rows:
        customer = row.get("customer_id", "")
        amount = parse_amount(row.get("amount", ""))
        if customer and amount is not None and amount > 0:
            totals[customer] += amount
            counts[customer] += 1
    return [
        {"customer_id": customer, "transaction_count": str(counts[customer]),
         "total_amount": format(totals[customer], "f")}
        for customer in sorted(totals, key=lambda key: (-totals[key], key))
    ]


def write_json(path: str | Path, payload: object) -> None:
    Path(path).write_text(json.dumps(payload, indent=2), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Synthetic-data AML analytics demo")
    parser.add_argument("--input", default="data/sample_transactions.csv")
    parser.add_argument("--output-dir", default="output")
    parser.add_argument("--threshold", default="250000",
                        help="Illustrative amount threshold; not a regulatory threshold")
    args = parser.parse_args()

    rows = load_transactions(args.input)
    threshold = parse_amount(args.threshold)
    if threshold is None or threshold <= 0:
        parser.error("--threshold must be a positive decimal amount")

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    write_json(output_dir / "data_quality_exceptions.json", validate_transactions(rows))
    write_json(output_dir / "demo_review_queue.json", build_review_queue(rows, threshold))
    write_json(output_dir / "customer_summary.json", customer_summary(rows))
    print(f"Processed {len(rows)} rows. Results written to {output_dir.resolve()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
