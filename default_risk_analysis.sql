SELECT COUNT(*) AS total_loans,
    SUM(defaulted) AS total_defaults,
    ROUND(SUM(defaulted)::NUMERIC / COUNT(*) * 100, 2) AS overall_default_rate_pct
FROM clean_loans;
-- default rate by credit score bucket
SELECT credit_score_bucket,
    COUNT(*) AS total_loans,
    SUM(defaulted) AS total_defaults,
    ROUND(SUM(defaulted)::NUMERIC / COUNT(*) * 100, 2) AS overall_default_rate_pct
FROM clean_loans
GROUP BY credit_score_bucket
ORDER BY credit_score_bucket;
--default rate by dti
SELECT dti_bucket,
    COUNT(*) AS total_loans,
    SUM(defaulted) AS total_defaults,
    ROUND(SUM(defaulted)::NUMERIC / COUNT(*) * 100, 2) AS overall_default_rate_pct
FROM clean_loans
GROUP BY dti_bucket
ORDER BY dti_bucket;
--the higher he dti ratio, the more likely the individual defaults
-- Find DTI threshold where default rate exceeds 12%
WITH dti_trend AS (
    SELECT FLOOR(dti_ratio / 5) * 5 AS dti_range_start,
        COUNT(*) AS loan_count,
        SUM(defaulted) AS default_count,
        ROUND(SUM(defaulted)::NUMERIC / COUNT(*) * 100, 2) AS default_rate_pct
    FROM clean_loans
    GROUP BY dti_range_start
    HAVING COUNT(*) >= 5 -- Minimum sample size
)
SELECT dti_range_start AS dti_threshold_start,
    default_rate_pct,
    loan_count
FROM dti_trend
WHERE default_rate_pct > 12
ORDER BY dti_range_start
LIMIT 1;
--Loan porpose with the highest default rate
SELECT loan_purpose,
    COUNT(*) AS total_loans,
    SUM(defaulted) AS total_defaults,
    ROUND(SUM(defaulted)::NUMERIC / COUNT(*) * 100, 2) AS overall_default_rate_pct
FROM clean_loans
GROUP BY loan_purpose
ORDER BY loan_purpose;
--loan purppose with the the highest default rate are weddings, cap them at a ceratin amount
-- Default rate by employment status
SELECT employment_status,
    COUNT(*) AS total_loans,
    SUM(defaulted) AS total_defaults,
    ROUND(SUM(defaulted)::NUMERIC / COUNT(*) * 100, 2) AS default_rate_pct
FROM clean_loans
GROUP BY employment_status
ORDER BY default_rate_pct DESC;
--part time employment has the highest default rate at 27.69%
-- Default rate by tenure (<2 years vs 2+ years)
SELECT employment_tenure_flag,
    COUNT(*) AS total_loans,
    SUM(defaulted) AS total_defaults,
    ROUND(SUM(defaulted)::NUMERIC / COUNT(*) * 100, 2) AS default_rate_pct
FROM clean_loans
GROUP BY employment_tenure_flag
ORDER BY default_rate_pct DESC;
--Individual with less than 2 years of employment have a default rate of 34.52%