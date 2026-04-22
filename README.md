# Loan Default Risk Analysis

**Project Goal**: Analyze Horizon Financial Group’s loan book to identify key drivers of default and recommend changes to the credit scoring model and approval thresholds.

## Project Overview

This analysis investigates why ~25% of loans default well above the target of 12%. Using two datasets (`borrowers.csv` and `loans.csv`), we:

- Calculate default rates by borrower and loan attributes
- Identify high-risk segments (credit score, DTI, purpose, employment)
- Recommend actionable thresholds for underwriting

---

## Tech Stack

| Tool                     | Usage                                                 |
| ------------------------ | ----------------------------------------------------- |
| **SQL**                  | Clean and join raw data into `clean_loans` view       |
| **Python + Pandas**      | Perform segmentation, correlation, and visualizations |
| **Matplotlib + Seaborn** | Generate charts for insights                          |
| **Google Colab**         | Run analysis interactively (notebook link below)      |

---

## 📂 Dataset Summary

**Input Files** (after cleaning and export):

| File              | Description                                              |
| ----------------- | -------------------------------------------------------- |
| `clean_loans.csv` | Final cleaned dataset with joined borrower and loan data |
| `clean_loans.csv` | Exported from PostgreSQL via `\copy`                     |

**Key Columns**:

| Column              | Type      | Purpose                   |
| ------------------- | --------- | ------------------------- |
| `defaulted`         | Int (0/1) | Indicator for default     |
| `credit_score`      | Int       | Borrower’s credit score   |
| `dti_ratio`         | Float     | Debt-to-income ratio      |
| `loan_purpose`      | String    | Reason for loan           |
| `employment_status` | String    | Full-Time, Contract, etc. |
| `years_employed`    | Int       | Time with current job     |
| `loan_amount`       | Float     | Size of loan              |

---

## 📊 Key Findings

> _Summarized from the analysis below — see full charts and code in [Colab Notebook](#)_

1. **Overall Default Rate**: 25.3% - **well above the 12% target**
2. **Highest Default Rate**:
   - **Credit Score Bucket**: `520–599` (Poor) - 42.1% default rate
   - **DTI Bucket**: `50%+` - 38.7% default rate
   - **Employment Status**: `Self-Employed` - 40.5% default rate
   - **Loan Purpose**: `Vacation` - 38.2% default rate
3. **Critical Thresholds**:
   - **Minimum Credit Score**: 650 (Average) or higher
   - **Max DTI**: 40%
   - **Employment**: 2+ years of continuous employment
   - **Loan Purpose**: Restrict or price higher for high-risk purposes

---

## Analysis Summary

### ✅ Question 1: Default Rate by Credit Score

- **Poor credit** (520–599): 42.1% default rate
- **Excellent credit** (750+): 8.1% default rate
- **Recommendation**: Set minimum credit score to **650** or higher

### ✅ Question 2: Default Rate by DTI

- **DTI > 40%**: 35.6% default rate
- **DTI ≤ 40%**: 10.2% default rate
- **Recommendation**: Set **maximum DTI of 40%** for approval

### ✅ Question 3: Loan Purpose & Amount

- **Highest Risk Purpose**: `Vacation` (38.2% default)
- **Average Loan Amount**: $16,200 for defaults vs. $12,800 for non-defaults
- **Recommendation**: Cap vacation loans at $10,000 or require co-signer

### ✅ Question 4: Employment Status & Tenure

- **< 2 years employed**: 33.7% default rate
- **2+ years employed**: 11.3% default rate
- **Recommendation**: Set **minimum 2 years of employment** as hard cutoff

---

## Recommendations for Underwriting

| Risk Factor           | Threshold                              | Rationale                                                 |
| --------------------- | -------------------------------------- | --------------------------------------------------------- |
| **Credit Score**      | ≥ 650                                  | Lower scores correlate with high default rates            |
| **DTI Ratio**         | ≤ 40%                                  | Rate jumps significantly above 40%                        |
| **Employment Tenure** | ≥ 2 years                              | Borrowers with <2 years are 3x more likely to default     |
| **Loan Purpose**      | Restrict: Vacation, Debt Consolidation | High default rates - consider higher pricing or co-signer |
| **Loan Amount**       | ≤ $10,000 for high-risk purposes       | Larger loans = higher loss if default                     |

---

## Visuals & Outputs

All charts were generated and saved as PNG files:

- `q1_default_rate_credit_score.png`
- `q2_dti_scatter.png`
- `q2_dti_trend.png`
- `q3_loan_purpose_default_rate.png`
- `q3_loan_amount_boxplot.png`
- `q4_employment_status_default_rate.png`
- `q4_years_employed_trend.png`

---

## How to Run

1. **Upload** `clean_loans.csv` to Google Colab
2. **Run** the notebook cells in order
3. **Review** results and charts
4. **Use** the thresholds in the underwriting system

> Note: This analysis assumes data is clean and representative. Any future changes to the credit scoring model should be tested with A/B testing.

---

## Credits

- **AnalystBuilder**
- **Date**: April 20, 2026

---
