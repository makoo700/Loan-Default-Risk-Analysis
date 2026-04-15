CREATE TABLE borrowerprofiles(
    borrower_id VARCHAR PRIMARY KEY ,
    age INT,
    state VARCHAR,
    education_level VARCHAR,
    employment_status VARCHAR,
    years_employed INT,
    annual_income INT,
    credit_score INT,
    home_ownership VARCHAR,
    dependents INT,
    existing_monthly_debt INT
);

CREATE TABLE loan_applications(
    loan_id VARCHAR,
    borrower_id VARCHAR,
    application_date INT,
    loan_purpose VARCHAR,
    loan_ammount INT,
    term_months INT,
    interest_rate FLOAT,
    monthly_payment FLOAT,
    dti_ratio FLOAT,
    loan_status VARCHAR,
    days_delinquent INT,
    defaulted INT
);