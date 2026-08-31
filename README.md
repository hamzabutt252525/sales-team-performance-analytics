# Sales Team Performance Analytics
## A Coaching Framework Identifying $5.93M in Annual Revenue Opportunity

**Live Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/hamza.bashir.butt/viz/Sales_Team_Performance_Analytics/Dashboard1)

---

## Project Overview

This project analyzes a 40-rep B2B sales team over 24 months to identify performance gaps, quantify coaching opportunities, and recommend targeted interventions. The analysis combines Python data engineering, SQL analytical modeling, and Tableau visualization to deliver executive-ready insights.

### Business Question
*How do we identify which reps need coaching, what type of coaching, and what revenue impact would result from those interventions?*

### Key Findings
- **$5.93M annual revenue opportunity** identified from lifting 18 underperforming reps to solid performer levels
- **APAC territory systematically underperforms** across all segments (70.49% attainment vs EMEA at 84.79%)
- **Activity volume drives performance**, not skill: Top Performers make 2.3x more calls than Underperformers
- **Pipeline coverage <2.5x** is a leading indicator of future underperformance
- **$74M in lost deal revenue** — Price and Competition drive 47% of losses

---

## Tech Stack

- **Data Generation:** Python (pandas, numpy) — Custom synthetic data mirroring real B2B sales patterns
- **Data Storage:** SQLite database with 3 normalized tables
- **Analytics:** SQL (15 queries using window functions, CTEs, correlated subqueries)
- **Visualization:** Tableau Public (6-sheet interactive dashboard)
- **Documentation:** Markdown

---

## Repository Structure

```
sales-team-performance-analytics/
├── data/                          # Raw data files
│   ├── sales_reps.csv             # 40 sales reps with tenure, territory, segment
│   ├── monthly_performance.csv    # 960 monthly performance records
│   ├── deals.csv                  # 2,000 deal records with outcomes
│   └── sales_analytics.db         # SQLite database
├── notebooks/
│   └── data_generation.ipynb      # Python script for synthetic data
├── sql/
│   └── analytical_queries.sql     # 15 analytical SQL queries
├── tableau/
│   └── Sales_Team_Analytics.twbx  # Tableau workbook
├── analysis/                      # Query result CSVs
├── screenshots/                   # Chart screenshots
├── deliverables/
│   ├── methodology.md             # Full analytical methodology
│   └── linkedin_article.md        # Public writeup
└── README.md                      # This file
```

---

## Analytical Framework (8 Dimensions)

1. **Team Performance Baseline** — Aggregate metrics, spread analysis
2. **Performance Tier Distribution** — Segmentation and concentration
3. **Territory Analysis** — Geographic performance patterns
4. **Segment Analysis** — Customer segment performance (SMB/Mid-Market/Enterprise)
5. **Tenure Impact** — Ramp-up curves and experience effects
6. **Activity-to-Outcome Funnel** — Conversion rates by tier
7. **Pipeline Health** — Coverage ratios and win rates
8. **Coaching Priority Matrix** — Effort vs impact segmentation

---

## Key Analytical Techniques

- **Window Functions:** RANK, LAG for trend analysis and ranking
- **Common Table Expressions (CTEs):** For layered analytical logic
- **Correlated Subqueries:** For financial impact modeling
- **Pareto Analysis:** Revenue concentration curves
- **Cohort Analysis:** Tenure-based performance grouping
- **Case-based Segmentation:** Multi-dimensional coaching categorization

---

## Strategic Recommendations Delivered

**Immediate (0-30 days):**
- APAC territory operational review
- Activity minimums with daily accountability
- Pipeline coverage alerts at <2.5x threshold

**Short-Term (30-90 days):**
- Restructured 6-month onboarding program
- Enterprise sales methodology audit
- Competitive battle cards deployment

**Long-Term (90-180 days):**
- Structured coaching cadence for Intensive Coaching cohort (12 reps)
- Retention/compensation review for Top Performers (5 reps)

**Projected Revenue Impact:** $1.8M–$3.0M annually (30-50% coaching success rate)

---

## About This Project

**Author:** Hamza Butt  
**LinkedIn:** [linkedin.com/in/hamzabutt01](https://linkedin.com/in/hamzabutt01)

This portfolio project demonstrates end-to-end analytics: from raw data engineering through SQL modeling to executive-ready visualization and strategic recommendations. Built to reflect the scope and rigor expected in RevOps / Business Operations Analyst roles at fintech, SaaS, and B2B sales organizations.

**Note on data:** All data is synthetically generated to reflect realistic B2B sales patterns while protecting confidentiality. The analytical framework and methodology are directly applicable to real sales team analysis.