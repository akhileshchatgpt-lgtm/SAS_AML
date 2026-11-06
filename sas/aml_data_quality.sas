/*
  Independent AML analytics demonstration
  Input : synthetic CSV; update path to a location accessible to SAS
  Output: WORK.DQ_EXCEPTIONS, WORK.TRANSACTIONS_VALID, WORK.TRANSACTIONS_CLEAN
  Note  : Educational example only; not a production AML control.
*/

options mprint mlogic symbolgen;

/* Update this path to a location accessible from the SAS session. */
%let input_file=../data/sample_transactions.csv;

proc import datafile="&input_file"
    out=work.transactions_raw
    dbms=csv
    replace;
    guessingrows=max;
    getnames=yes;
run;

/* Both output tables must be declared in the DATA statement. */
data work.dq_exceptions work.transactions_valid;
    set work.transactions_raw;
    length exception_reason $300;
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

/* Keep one row per transaction ID and capture duplicate rows separately. */
proc sort data=work.transactions_valid
          out=work.transactions_clean
          dupout=work.duplicate_transactions
          nodupkey;
    by transaction_id;
run;

/* Illustrative review queue; threshold is not a legal reporting threshold. */
data work.demo_review_queue;
    set work.transactions_clean;
    length review_reason $100;
    review_reason = '';

    if amount >= 250000 then
        review_reason = catx('; ', review_reason, 'DEMO_HIGH_VALUE');
    if upcase(customer_risk) = 'HIGH' then
        review_reason = catx('; ', review_reason, 'DEMO_HIGH_CUSTOMER_RISK');

    if not missing(review_reason) then output;
run;

title "AML Demo - Data Quality Summary";
proc sql;
    select count(*) as valid_unique_transactions
    from work.transactions_clean;

    select count(*) as data_quality_exceptions
    from work.dq_exceptions;

    select count(*) as duplicate_transaction_rows
    from work.duplicate_transactions;

    select count(*) as demo_review_candidates
    from work.demo_review_queue;
quit;
title;

proc print data=work.dq_exceptions noobs;
    title "Data Quality Exceptions";
run;

proc print data=work.demo_review_queue noobs;
    title "Illustrative AML Review Queue";
run;
title;
