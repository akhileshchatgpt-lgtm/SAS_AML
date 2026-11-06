/*
  Independent AML analytics demonstration
  Input : ../data/sample_transactions.csv
  Output: WORK.DQ_EXCEPTIONS and WORK.TRANSACTIONS_CLEAN
  Note  : Uses synthetic data only. Educational example, not a production control.
*/

options mprint mlogic symbolgen;

/* Import synthetic transaction data */
proc import datafile="../data/sample_transactions.csv"
    out=work.transactions_raw
    dbms=csv
    replace;
    guessingrows=max;
    getnames=yes;
run;

/* Standardize fields and derive validation flags */
data work.transactions_checked;
    set work.transactions_raw;
    length exception_reason $200;
    exception_reason = '';

    if missing(transaction_id) then
        exception_reason = catx('; ', exception_reason, 'MISSING_TRANSACTION_ID');
    if missing(customer_id) then
        exception_reason = catx('; ', exception_reason, 'MISSING_CUSTOMER_ID');
    if missing(transaction_date) then
        exception_reason = catx('; ', exception_reason, 'MISSING_TRANSACTION_DATE');
    if missing(amount) then
        exception_reason = catx('; ', exception_reason, 'MISSING_AMOUNT');
    else if amount <= 0 then
        exception_reason = catx('; ', exception_reason, 'NON_POSITIVE_AMOUNT');

    if missing(currency) then
        exception_reason = catx('; ', exception_reason, 'MISSING_CURRENCY');
    if missing(transaction_type) then
        exception_reason = catx('; ', exception_reason, 'MISSING_TRANSACTION_TYPE');

    if not missing(exception_reason) then output work.dq_exceptions;
    else output work.transactions_valid;
run;

/* Identify duplicate transaction IDs */
proc sort data=work.transactions_valid
          out=work.transactions_sorted
          dupout=work.duplicate_transactions
          nodupkey;
    by transaction_id;
run;

/* Final clean set excludes invalid rows and duplicate IDs */
data work.transactions_clean;
    set work.transactions_sorted;
run;

title "AML Demo - Data Quality Summary";
proc sql;
    select count(*) as valid_unique_transactions
    from work.transactions_clean;

    select count(*) as data_quality_exceptions
    from work.dq_exceptions;

    select count(*) as duplicate_transaction_rows
    from work.duplicate_transactions;
quit;
title;

/* Illustrative high-value / high-risk review queue.
   Threshold is a demo parameter and is NOT a legal reporting threshold. */
data work.demo_review_queue;
    set work.transactions_clean;
    length review_reason $100;
    if amount >= 250000 or upcase(customer_risk) = 'HIGH' then do;
        review_reason = 'DEMO_HIGH_VALUE_OR_HIGH_CUSTOMER_RISK';
        output;
    end;
run;

proc print data=work.dq_exceptions noobs;
    title "Data Quality Exceptions";
run;

proc print data=work.demo_review_queue noobs;
    title "Illustrative AML Review Queue";
run;

title;
