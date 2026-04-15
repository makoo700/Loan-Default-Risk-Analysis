SELECT *
FROM borrowerprofiles
LIMIT 10;
SELECT *
FROM loan_applications
LIMIT 10;
-- Check nulls in borrowers table
SELECT COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE borrower_id IS NULL
    ) AS null_borrower_id,
    COUNT(*) FILTER (
        WHERE age IS NULL
    ) AS null_age,
    COUNT(*) FILTER (
        WHERE credit_score IS NULL
    ) AS null_credit_score,
    COUNT(*) FILTER (
        WHERE annual_income IS NULL
    ) AS null_income,
    COUNT(*) FILTER (
        WHERE employment_status IS NULL
    ) AS null_employment,
    COUNT(*) FILTER (
        WHERE years_employed IS NULL
    ) AS null_years_employed,
    COUNT(*) FILTER (
        WHERE existing_monthly_debt IS NULL
    ) AS null_monthly_debt
FROM borrowerprofiles;
-- Check nulls in loans table
SELECT COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE loan_id IS NULL
    ) AS null_loan_id,
    COUNT(*) FILTER (
        WHERE borrower_id IS NULL
    ) AS null_borrower_id,
    COUNT(*) FILTER (
        WHERE dti_ratio IS NULL
    ) AS null_dti,
    COUNT(*) FILTER (
        WHERE loan_ammount IS NULL
    ) AS null_loan_amount,
    COUNT(*) FILTER (
        WHERE defaulted IS NULL
    ) AS null_defaulted,
    COUNT(*) FILTER (
        WHERE interest_rate IS NULL
    ) AS null_interest_rate,
    COUNT(*) FILTER (
        WHERE loan_purpose IS NULL
    ) AS null_purpose
FROM loan_applications;
--check for duplicates 
SELECT borrower_id,
    COUNT (*) AS occurences
FROM borrowerprofiles
GROUP BY borrower_id
HAVING COUNT(*) > 1;
-- Duplicate loan_id in loans table
SELECT loan_id,
    COUNT(*) AS occurrences
FROM loan_applications
GROUP BY loan_id
HAVING COUNT(*) > 1;
-- Check if one borrower has multiple loans 
SELECT borrower_id,
    COUNT(*) AS loan_count
FROM loan_applications
GROUP BY borrower_id
HAVING COUNT(*) > 1
ORDER BY loan_count DESC;
--some borrowers have more than one loan
--normal credit scores range between 300-850
SELECT credit_score,
    borrower_id
FROM borrowerprofiles
WHERE credit_score < 300
    OR credit_score > 850;
--check for negative or zero income
SELECT borrower_id,
    annual_income
FROM borrowerprofiles
WHERE annual_income <= 0;
--check for negative loan ammounts 
SELECT borrower_id,
    loan_ammount,
    dti_ratio
FROM loan_applications
WHERE loan_ammount <= 0
    OR dti_ratio < 0;
--check for join integrity 
--check whether a loan doesn't have a borrower
SELECT l.loan_id,
    l.borrower_id
FROM loan_applications l
    LEFT JOIN borrowerprofiles b ON l.borrower_id = b.borrower_id
WHERE b.borrower_id IS NULL;
--check whether a borrower doesn't have a loan
SELECT b.borrower_id
FROM borrowerprofiles b
    LEFT JOIN loan_applications l ON b.borrower_id = l.borrower_id
WHERE l.loan_id IS NULL;
SELECT MIN(credit_score) AS min_credit_score,
    MAX(credit_score) AS max_credit_score
FROM borrowerprofiles;
CREATE VIEW clean_loans AS
SELECT b.borrower_id,
    b.age,
    b.state,
    b.education_level,
    b.employment_status,
    b.years_employed,
    b.annual_income,
    b.credit_score,
    b.home_ownership,
    b.dependents,
    b.existing_monthly_debt,
    l.loan_id,
    l.application_date,
    l.loan_purpose,
    l.loan_ammount,
    l.term_months,
    l.interest_rate,
    l.monthly_payment,
    l.dti_ratio,
    l.loan_status,
    l.days_delinquent,
    l.defaulted,
    CASE
        WHEN b.credit_score BETWEEN 500 AND 599 THEN 'Poor'
        WHEN b.credit_score BETWEEN 600 AND 649 THEN 'Fair'
        WHEN b.credit_score BETWEEN 650 AND 700 THEN 'Average'
        WHEN b.credit_score BETWEEN 701 AND 749 THEN 'Good'
        WHEN b.credit_score >= 750 THEN 'Excellent'
        ELSE 'Out of range'
    END AS credit_score_bucket,
    -- DTI bucket
    CASE
        WHEN l.dti_ratio < 20 THEN 'Low'
        WHEN l.dti_ratio BETWEEN 20 AND 34 THEN 'Moderate'
        WHEN l.dti_ratio BETWEEN 35 AND 49 THEN 'High'
        WHEN l.dti_ratio >= 50 THEN 'Very High'
        ELSE 'Unknown'
    END AS dti_bucket,
    -- Employment tenure flag
    CASE
        WHEN b.years_employed < 2 THEN 'Less than 2 years'
        ELSE '2 or more years'
    END AS employment_tenure_flag
FROM borrowerprofiles b
    INNER JOIN loan_applications l ON b.borrower_id = l.borrower_id -- Cleaning filters
WHERE l.defaulted IN (0, 1)
    AND b.credit_score BETWEEN 300 AND 850
    AND b.annual_income > 0
    AND l.loan_ammount > 0
    AND l.dti_ratio >= 0
    AND b.years_employed >= 0;
-- Export the cleaned view to CSV for Python analysis
\ copy (
    SELECT *
    FROM clean_loans
) TO 'C:\Users\PC\Desktop\Loan Default Risk Analysis\csv_files\clean_loans.csv' WITH (FORMAT CSV, HEADER TRUE);