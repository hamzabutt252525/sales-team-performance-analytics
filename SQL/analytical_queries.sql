-- ============================================
-- Sales Team Performance Analytics
-- Analytical Queries for RevOps Coaching Framework
-- Author: Hamza Butt
-- Date: August 2026
-- Database: SQLite
-- Total Queries: 15 across 8 analytical dimensions
-- ============================================


-- ============================================
-- Query 1: Team Performance Overview
-- Purpose: Baseline understanding of overall team performance
-- Key Finding: Team of 40 reps averaging 79.26% quota attainment,
--              with 13.7x gap between top (160.16%) and bottom (11.71%) performer.
--              Total revenue: $43.1M across 1,487 deals closed.
-- ============================================
SELECT 
    COUNT(DISTINCT rep_id) AS total_reps,
    ROUND(AVG(quota_attainment_pct), 2) AS avg_quota_attainment,
    ROUND(MIN(quota_attainment_pct), 2) AS min_attainment,
    ROUND(MAX(quota_attainment_pct), 2) AS max_attainment,
    SUM(deals_closed) AS total_deals_closed,
    ROUND(SUM(monthly_revenue), 0) AS total_revenue
FROM monthly_performance;


-- ============================================
-- Query 2: Performance Distribution by Tier
-- Purpose: Distribution of reps across performance categories
-- Key Finding: Only 10% of team are Top Performers (4 reps). 45% are 
--              Underperformers or At-Risk (18 reps). Top Performers generate 
--              2.8x monthly revenue of At-Risk reps ($79K vs $28K).
-- ============================================
SELECT 
    performance_tier,
    COUNT(DISTINCT sr.rep_id) AS rep_count,
    ROUND(AVG(quota_attainment_pct), 2) AS avg_attainment,
    ROUND(SUM(monthly_revenue), 0) AS total_revenue,
    ROUND(AVG(monthly_revenue), 0) AS avg_revenue_per_month
FROM sales_reps sr
JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
GROUP BY performance_tier
ORDER BY 
    CASE performance_tier
        WHEN 'Top Performer' THEN 1
        WHEN 'Solid Performer' THEN 2
        WHEN 'Underperformer' THEN 3
        WHEN 'At-Risk' THEN 4
    END;


-- ============================================
-- Query 3: Territory Performance Analysis
-- Purpose: Identify geographic performance patterns
-- Key Finding: APAC significantly underperforming at 70.49% attainment vs 
--              EMEA at 84.79% (14.3 percentage point gap). 6 of 9 APAC reps
--              (67%) are underperforming or at-risk. Territory-level issue.
-- ============================================
SELECT 
    sr.territory,
    COUNT(DISTINCT sr.rep_id) AS rep_count,
    ROUND(AVG(mp.quota_attainment_pct), 2) AS avg_attainment,
    ROUND(SUM(mp.monthly_revenue), 0) AS total_revenue,
    ROUND(AVG(mp.monthly_revenue), 0) AS avg_revenue_per_month,
    COUNT(DISTINCT CASE WHEN sr.performance_tier IN ('Underperformer', 'At-Risk') THEN sr.rep_id END) AS underperforming_count
FROM sales_reps sr
JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
GROUP BY sr.territory
ORDER BY avg_attainment DESC;


-- ============================================
-- Query 4: Segment Performance Analysis
-- Purpose: Compare performance across customer segments (SMB/Mid-Market/Enterprise)
-- Key Finding: Enterprise underperforming (70.05% attainment) despite similar 
--              deal sizes to SMB ($30.8K vs $30.8K). Enterprise sales cycles 
--              12% longer (74.8 vs 67 days) without yielding larger deals - 
--              suggests targeting or coaching gap.
-- ============================================
SELECT 
    sr.primary_segment,
    COUNT(DISTINCT sr.rep_id) AS rep_count,
    ROUND(AVG(mp.quota_attainment_pct), 2) AS avg_attainment,
    ROUND(AVG(mp.avg_deal_size), 0) AS avg_deal_size,
    ROUND(AVG(mp.avg_cycle_days), 1) AS avg_sales_cycle,
    ROUND(SUM(mp.monthly_revenue), 0) AS total_revenue
FROM sales_reps sr
JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
GROUP BY sr.primary_segment
ORDER BY avg_attainment DESC;


-- ============================================
-- Query 5: Tenure Impact on Performance
-- Purpose: Analyze how rep tenure correlates with performance
-- Key Finding: Ramp-up gap is severe - 0-6 month reps at only 50.44% attainment.
--              Performance plateaus at 86-88% after 12 months. 2-3 year reps 
--              close fewer deals (1.6/mo vs 2.0) but similar revenue - increasing 
--              deal sophistication over time.
-- ============================================
SELECT 
    CASE 
        WHEN mp.months_tenure < 6 THEN '0-6 months'
        WHEN mp.months_tenure < 12 THEN '6-12 months'
        WHEN mp.months_tenure < 24 THEN '1-2 years'
        WHEN mp.months_tenure < 36 THEN '2-3 years'
        ELSE '3+ years'
    END AS tenure_bucket,
    COUNT(DISTINCT mp.rep_id) AS rep_count,
    ROUND(AVG(mp.quota_attainment_pct), 2) AS avg_attainment,
    ROUND(AVG(mp.deals_closed), 1) AS avg_deals_per_month,
    ROUND(AVG(mp.monthly_revenue), 0) AS avg_monthly_revenue
FROM monthly_performance mp
GROUP BY tenure_bucket
ORDER BY 
    CASE tenure_bucket
        WHEN '0-6 months' THEN 1
        WHEN '6-12 months' THEN 2
        WHEN '1-2 years' THEN 3
        WHEN '2-3 years' THEN 4
        WHEN '3+ years' THEN 5
    END;


-- ============================================
-- Query 6: Individual Rep Rankings
-- Purpose: Rank all reps by attainment for individual performance tracking
-- Uses: Window function (RANK)
-- Key Finding: Top rep (Omar Lopez, EMEA SMB) at 126.92%, bottom rep 
--              (Michael Nguyen, LATAM Mid-Market) at 37.83%. Notably, NO 
--              Enterprise rep ranks in Top Performer tier - all top performers
--              are in SMB or Mid-Market segments.
-- ============================================
SELECT 
    sr.full_name,
    sr.territory,
    sr.primary_segment,
    sr.performance_tier,
    ROUND(AVG(mp.quota_attainment_pct), 2) AS avg_attainment,
    ROUND(SUM(mp.monthly_revenue), 0) AS total_revenue,
    RANK() OVER (ORDER BY AVG(mp.quota_attainment_pct) DESC) AS performance_rank
FROM sales_reps sr
JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
GROUP BY sr.rep_id, sr.full_name, sr.territory, sr.primary_segment, sr.performance_tier
ORDER BY avg_attainment DESC;


-- ============================================
-- Query 7: Month-over-Month Trend Analysis
-- Purpose: Track revenue momentum and identify seasonal patterns
-- Uses: Window function (LAG) for period-over-period comparison
-- Key Finding: Team grew from 20 reps (Jan 2024) to 40 (Dec 2024). Two notable 
--              revenue dips: Jan 2025 (-$464K MoM, post-holiday) and Sep 2025 
--              (-$68K). Q4 2025 breakthrough - Oct 2025 first month above 
--              100% attainment (101.18%). Overall trajectory: 51% → 100%+ attainment.
-- ============================================
SELECT 
    year,
    month,
    COUNT(DISTINCT rep_id) AS active_reps,
    ROUND(AVG(quota_attainment_pct), 2) AS avg_attainment,
    SUM(deals_closed) AS total_deals,
    ROUND(SUM(monthly_revenue), 0) AS total_revenue,
    ROUND(SUM(monthly_revenue) - LAG(SUM(monthly_revenue)) OVER (ORDER BY year, month), 0) AS revenue_change_from_prev_month
FROM monthly_performance
GROUP BY year, month
ORDER BY year, month;


-- ============================================
-- Query 8: Activity to Outcome Conversion Analysis
-- Purpose: Identify where in the funnel each performance tier loses efficiency
-- Key Finding: CRITICAL INSIGHT - Top Performers make 2.3x more calls (46 vs 20)
--              than Underperformers. Counterintuitively, Underperformers convert
--              BETTER at each funnel stage (57% demo-to-deal vs 47% for Top). 
--              Root cause is activity volume, NOT execution skill. Coaching should
--              focus on activity minimums, not sales technique training.
-- ============================================
SELECT 
    sr.performance_tier,
    ROUND(AVG(mp.calls_made), 0) AS avg_calls,
    ROUND(AVG(mp.meetings_held), 1) AS avg_meetings,
    ROUND(AVG(mp.demos_completed), 1) AS avg_demos,
    ROUND(AVG(mp.deals_closed), 1) AS avg_deals,
    ROUND(AVG(mp.meetings_held * 1.0 / NULLIF(mp.calls_made, 0)) * 100, 2) AS call_to_meeting_pct,
    ROUND(AVG(mp.demos_completed * 1.0 / NULLIF(mp.meetings_held, 0)) * 100, 2) AS meeting_to_demo_pct,
    ROUND(AVG(mp.deals_closed * 1.0 / NULLIF(mp.demos_completed, 0)) * 100, 2) AS demo_to_deal_pct
FROM sales_reps sr
JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
GROUP BY sr.performance_tier
ORDER BY 
    CASE sr.performance_tier
        WHEN 'Top Performer' THEN 1
        WHEN 'Solid Performer' THEN 2
        WHEN 'Underperformer' THEN 3
        WHEN 'At-Risk' THEN 4
    END;


-- ============================================
-- Query 9: Pipeline Coverage and Win Rate by Tier
-- Purpose: Assess pipeline health across performance tiers
-- Key Finding: Pipeline coverage is a strong leading indicator. Top Performers
--              maintain 3.47x coverage vs 2.01x for Underperformers. Top 
--              Performers close in 43.7 days vs 84.3 for Underperformers (1.9x 
--              faster). Coverage <2.5x should trigger automatic coaching alert.
-- ============================================
SELECT 
    sr.performance_tier,
    ROUND(AVG(mp.pipeline_value), 0) AS avg_pipeline_value,
    ROUND(AVG(mp.pipeline_coverage_ratio), 2) AS avg_pipeline_coverage,
    ROUND(AVG(mp.win_rate) * 100, 2) AS avg_win_rate_pct,
    ROUND(AVG(mp.avg_cycle_days), 1) AS avg_sales_cycle_days
FROM sales_reps sr
JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
GROUP BY sr.performance_tier
ORDER BY 
    CASE sr.performance_tier
        WHEN 'Top Performer' THEN 1
        WHEN 'Solid Performer' THEN 2
        WHEN 'Underperformer' THEN 3
        WHEN 'At-Risk' THEN 4
    END;


-- ============================================
-- Query 10: Deal Loss Reason Analysis
-- Purpose: Identify top reasons for lost deals and revenue leakage
-- Key Finding: $74M in total lost deal revenue. Top three reasons account for
--              62% of losses: Price ($17.97M, 214 deals), Competitor ($17.29M, 
--              194 deals), No Decision ($11.05M, 125 deals). Actions: discount 
--              authority review, competitive battle cards, qualification training.
-- ============================================
SELECT 
    loss_reason,
    COUNT(*) AS deal_count,
    ROUND(SUM(deal_size_usd), 0) AS lost_revenue,
    ROUND(AVG(deal_size_usd), 0) AS avg_lost_deal_size,
    ROUND(AVG(cycle_days), 1) AS avg_cycle_before_loss
FROM deals
WHERE deal_status = 'Lost'
GROUP BY loss_reason
ORDER BY lost_revenue DESC;


-- ============================================
-- Query 11: Territory + Segment Cross Analysis
-- Purpose: Two-dimensional analysis to identify strongest and weakest combinations
-- Key Finding: EMEA Mid-Market strongest combination (106.17% attainment). 
--              APAC underperforms in ALL segments (74.71% SMB, 74.53% Mid-Market,
--              42.08% Enterprise) - confirming territory-wide issue rather than 
--              segment-specific coaching gap.
-- ============================================
SELECT 
    sr.territory,
    sr.primary_segment,
    COUNT(DISTINCT sr.rep_id) AS rep_count,
    ROUND(AVG(mp.quota_attainment_pct), 2) AS avg_attainment,
    ROUND(SUM(mp.monthly_revenue), 0) AS total_revenue,
    ROUND(AVG(mp.avg_deal_size), 0) AS avg_deal_size
FROM sales_reps sr
JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
GROUP BY sr.territory, sr.primary_segment
ORDER BY sr.territory, avg_attainment DESC;


-- ============================================
-- Query 12: Coaching Priority Matrix (Effort vs Impact)
-- Purpose: Segment reps into coaching intervention categories
-- Uses: CTE for cleaner logic, CASE for multi-dimensional categorization
-- Key Finding: 42% of team needs meaningful intervention. Distribution: 5 reps
--              Performance Review Required, 12 Intensive Coaching, 18 Skill 
--              Development, 5 Retain & Reward. Biggest coaching leverage is
--              the 12-rep Intensive Coaching cohort.
-- ============================================
WITH rep_performance AS (
    SELECT 
        sr.rep_id,
        sr.full_name,
        sr.territory,
        sr.primary_segment,
        sr.performance_tier,
        AVG(mp.quota_attainment_pct) AS avg_attainment,
        AVG(mp.calls_made) AS avg_activity,
        AVG(mp.monthly_revenue) AS avg_revenue,
        MAX(mp.months_tenure) AS current_tenure
    FROM sales_reps sr
    JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
    GROUP BY sr.rep_id, sr.full_name, sr.territory, sr.primary_segment, sr.performance_tier
)
SELECT 
    full_name,
    territory,
    primary_segment,
    ROUND(avg_attainment, 2) AS attainment_pct,
    ROUND(avg_activity, 0) AS avg_calls,
    ROUND(avg_revenue, 0) AS monthly_revenue,
    current_tenure AS tenure_months,
    CASE 
        WHEN avg_attainment >= 100 THEN 'Retain & Reward'
        WHEN avg_attainment BETWEEN 75 AND 99.99 AND current_tenure >= 12 THEN 'Skill Development'
        WHEN avg_attainment BETWEEN 50 AND 74.99 AND current_tenure >= 12 THEN 'Intensive Coaching'
        WHEN avg_attainment < 50 AND current_tenure >= 18 THEN 'Performance Review Required'
        WHEN current_tenure < 12 THEN 'Onboarding Focus'
        ELSE 'Standard Coaching'
    END AS coaching_priority
FROM rep_performance
ORDER BY 
    CASE 
        WHEN avg_attainment < 50 AND current_tenure >= 18 THEN 1
        WHEN avg_attainment BETWEEN 50 AND 74.99 AND current_tenure >= 12 THEN 2
        WHEN current_tenure < 12 THEN 3
        WHEN avg_attainment BETWEEN 75 AND 99.99 AND current_tenure >= 12 THEN 4
        WHEN avg_attainment >= 100 THEN 5
        ELSE 6
    END,
    avg_attainment ASC;


-- ============================================
-- Query 13: Quarterly Performance Trends
-- Purpose: Higher-level aggregation for executive reporting
-- Key Finding: Consistent quarterly improvement in 2025. Q4 2025 = first quarter
--              at 100%+ attainment (100.82%). Deal size doubled from Q1 2024 
--              ($21.5K) to Q4 2025 ($42.6K), suggesting improved deal targeting 
--              and value-selling maturity over time.
-- ============================================
SELECT 
    year,
    quarter,
    COUNT(DISTINCT rep_id) AS active_reps,
    ROUND(AVG(quota_attainment_pct), 2) AS avg_attainment,
    SUM(deals_closed) AS total_deals,
    ROUND(SUM(monthly_revenue), 0) AS total_revenue,
    ROUND(AVG(avg_deal_size), 0) AS avg_deal_size,
    ROUND(AVG(win_rate) * 100, 2) AS avg_win_rate_pct
FROM monthly_performance
GROUP BY year, quarter
ORDER BY year, quarter;


-- ============================================
-- Query 14: Revenue Concentration Analysis (Modified Pareto)
-- Purpose: Identify what percentage of team generates what percentage of revenue
-- Uses: CTEs with window functions (RANK, cumulative SUM)
-- Key Finding: Team is less top-heavy than typical 80/20 pattern. Top 25% of 
--              reps generate 40% of revenue. Top 50% generate 67.7%. Bottom 25%
--              only 12.5%. Team depth exists - coaching investment in middle 
--              tier has highest leverage.
-- ============================================
WITH rep_revenue AS (
    SELECT 
        sr.rep_id,
        sr.full_name,
        SUM(mp.monthly_revenue) AS total_rep_revenue,
        RANK() OVER (ORDER BY SUM(mp.monthly_revenue) DESC) AS revenue_rank
    FROM sales_reps sr
    JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
    GROUP BY sr.rep_id, sr.full_name
),
cumulative AS (
    SELECT 
        full_name,
        total_rep_revenue,
        revenue_rank,
        SUM(total_rep_revenue) OVER (ORDER BY revenue_rank) AS cumulative_revenue,
        SUM(total_rep_revenue) OVER () AS grand_total_revenue
    FROM rep_revenue
)
SELECT 
    full_name,
    revenue_rank,
    ROUND(total_rep_revenue, 0) AS total_revenue,
    ROUND(cumulative_revenue, 0) AS cumulative_revenue,
    ROUND((cumulative_revenue * 100.0 / grand_total_revenue), 2) AS cumulative_pct_of_total
FROM cumulative
ORDER BY revenue_rank;


-- ============================================
-- Query 15: Financial Impact Model - Coaching ROI
-- Purpose: Quantify the revenue opportunity from coaching interventions
-- Uses: CTE with correlated subquery
-- Key Finding: HEADLINE INSIGHT - $5.93M annual revenue opportunity from lifting 
--              underperformers to Solid Performer level. Breakdown: Underperformers
--              ($3.37M from 12 reps at $23.4K monthly gap each), At-Risk ($2.56M 
--              from 6 reps at $35.6K monthly gap each). Represents 14% revenue 
--              lift at 100% coaching success; realistic 30-50% success = $1.8M-$3M.
-- ============================================
WITH tier_gaps AS (
    SELECT 
        performance_tier,
        AVG(monthly_revenue) AS current_avg_monthly_revenue,
        (SELECT AVG(monthly_revenue) 
         FROM sales_reps sr2 
         JOIN monthly_performance mp2 ON sr2.rep_id = mp2.rep_id
         WHERE sr2.performance_tier = 'Solid Performer') AS target_avg_monthly_revenue
    FROM sales_reps sr
    JOIN monthly_performance mp ON sr.rep_id = mp.rep_id
    GROUP BY performance_tier
)
SELECT 
    tg.performance_tier,
    COUNT(DISTINCT sr.rep_id) AS rep_count,
    ROUND(tg.current_avg_monthly_revenue, 0) AS current_avg_monthly_rev,
    ROUND(tg.target_avg_monthly_revenue, 0) AS target_avg_monthly_rev,
    ROUND(tg.target_avg_monthly_revenue - tg.current_avg_monthly_revenue, 0) AS monthly_gap_per_rep,
    ROUND((tg.target_avg_monthly_revenue - tg.current_avg_monthly_revenue) * COUNT(DISTINCT sr.rep_id) * 12, 0) AS annual_revenue_opportunity
FROM tier_gaps tg
JOIN sales_reps sr ON sr.performance_tier = tg.performance_tier
WHERE tg.performance_tier IN ('Underperformer', 'At-Risk')
GROUP BY tg.performance_tier, tg.current_avg_monthly_revenue, tg.target_avg_monthly_revenue;