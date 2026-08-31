# How I Analyzed a 40-Rep Sales Team and Found $5.93M in Hidden Revenue Opportunity

*A case study in RevOps analytics: from raw data to executive recommendations*

---

If you manage sales teams, you already know the frustration: you have data everywhere — CRM dashboards, monthly reviews, activity reports — but converting that data into confident, targeted coaching decisions is genuinely hard.

Which reps need coaching? What kind of coaching? Where will your intervention time produce the highest revenue return?

I recently built an end-to-end analytical framework to answer these questions, and the results surprised me. Here's what I learned analyzing 24 months of performance data for a 40-rep B2B sales team.

**[View the live interactive dashboard on Tableau Public →](https://public.tableau.com/app/profile/hamza.bashir.butt/viz/Sales_Team_Performance_Analytics/Dashboard1)**

---

## The Setup

The dataset represents a mid-sized B2B sales organization operating across four territories (North America, EMEA, APAC, LATAM) and three customer segments (SMB, Mid-Market, Enterprise). Over 24 months, the team generated $43.1M in revenue across 1,487 closed deals.

Aggregate metrics tell you the team averages 79.26% quota attainment — respectable but below target. What they don't tell you is where the leverage is.

That's what analysis reveals.

---

## Finding #1: The 13.7x Performance Spread

The top-performing rep hit 160.16% of quota. The bottom-performing rep hit 11.71%.

That's a 13.7x gap between best and worst on the same team, selling the same product, with the same tools and processes.

This spread isn't unusual — every sales team has variance. But most managers underestimate how much revenue this variance represents in real dollars. In this case: lifting just the bottom performers to team average would add millions.

**The question isn't whether to coach. It's how to prioritize.**

---

## Finding #2: The Talent Pyramid

Segmenting the team by quota attainment revealed four clear tiers:

- **Top Performers (4 reps, 10%)** – averaging 115.4% attainment
- **Solid Performers (18 reps, 45%)** – averaging 91.94%
- **Underperformers (12 reps, 30%)** – averaging 68.85%
- **At-Risk (6 reps, 15%)** – averaging 40.35%

The revenue implications are stark. Top Performers generate 2.8x the monthly revenue of At-Risk reps ($79K vs $28K).

But here's what most performance reports miss: the At-Risk cohort isn't randomly distributed across the team.

---

## Finding #3: The APAC Problem (Territory-Level, Not Individual)

When I broke performance down by territory:

- **EMEA:** 84.79% attainment (13 reps)
- **North America:** 80.39% (14 reps)
- **LATAM:** 76.02% (4 reps)
- **APAC:** 70.49% (9 reps)

A 14.3 percentage point gap between EMEA and APAC is significant. But the more interesting finding came when I cross-tabulated territory with customer segment.

APAC underperforms **across every segment** — SMB, Mid-Market, and Enterprise. This eliminates "wrong deals" or "segment coaching gap" as explanations.

When a territory underperforms uniformly across segments, the issue is structural: leadership, market dynamics, resource allocation, or competitive positioning. Individual coaching won't fix a territory-level problem.

**Recommendation: APAC needs a strategic review, not just more coaching sessions.**

---

## Finding #4: The Counterintuitive Truth About Activity vs Skill

This is the finding that surprised me most.

When I built the conversion funnel by tier, I expected Top Performers to convert better at every stage. That's the intuitive coaching narrative: "your best reps know how to close."

The data said otherwise:

| Tier | Avg Calls/Month | Deals Closed | Demo → Deal Conversion |
|---|---|---|---|
| Top Performer | 46 | 3.4 | **47.19%** |
| Solid Performer | 29 | 2.1 | **49.79%** |
| Underperformer | 20 | 1.2 | **57.35%** |
| At-Risk | 21 | 1.1 | **53.41%** |

Underperformers actually convert BETTER at each funnel stage. What they lack isn't skill — it's volume.

Top Performers make 2.3x more calls than Underperformers. That single behavioral difference explains most of the performance gap.

**The coaching implication is important:** activity accountability programs will outperform sales technique training for this team. If you spend six months teaching MEDDIC to reps who aren't making enough calls, you'll get zero performance lift.

---

## Finding #5: Pipeline Coverage as an Early Warning System

I looked at pipeline coverage ratios across tiers:

- Top Performers: 3.47x average coverage
- Solid Performers: 2.80x
- Underperformers: 2.01x
- At-Risk: 1.97x

Pipeline coverage below 2.5x is a strong leading indicator of future underperformance. It typically precedes missed quota by 2-3 months.

**Operational recommendation:** Automated alerts when any rep's coverage drops below 2.5x triggers immediate coaching intervention — before the missed quarter, not after.

---

## The Coaching Priority Matrix

Not all underperformers need the same intervention. Some are tenured reps who've plateaued. Some are new reps still ramping. Some should have been managed out months ago.

I built a segmentation model that categorizes each rep by both attainment AND tenure:

| Category | Rep Count | Criteria | Recommended Action |
|---|---|---|---|
| Retain & Reward | 5 | ≥100% attainment | Compensation review, growth conversations |
| Skill Development | 18 | 75-99% attainment, 12+ months | Fine-tuning coaching |
| Intensive Coaching | 12 | 50-75% attainment, 12+ months | Weekly structured coaching |
| Performance Review | 5 | <50% attainment, 18+ months | Formal PIP or exit |

This framework ensures coaching investment goes where it has highest expected return. The 12-rep Intensive Coaching cohort represents the largest addressable opportunity — reps with enough tenure to have learned the product but who need focused intervention to unlock performance.

---

## The Headline: $5.93M in Annual Revenue Opportunity

I built a financial impact model to size the coaching opportunity:

**Underperformers (12 reps):**
- Current monthly revenue: $40,178/rep
- Solid Performer target: $63,591/rep
- Monthly gap: $23,413/rep
- Annual opportunity: **$3.37M**

**At-Risk (6 reps):**
- Current monthly revenue: $27,996/rep
- Solid Performer target: $63,591/rep
- Monthly gap: $35,596/rep
- Annual opportunity: **$2.56M**

**Total addressable opportunity: $5.93M annually** — a 14% revenue lift.

At realistic 30-50% coaching success rates, this translates to $1.8M-$3.0M in captured revenue.

The methodology is transparent: it assumes lifting underperformers only to Solid Performer average (not to Top Performer levels), and adjusts for realistic coaching success rates.

---

## What Recruiters Look For

If you're a hiring manager evaluating this analysis:

- **Business framing first** – Every finding tied to a decision or dollar impact
- **Multiple analytical dimensions** – Not just aggregate metrics; cross-tabulated cuts revealed structural insights
- **Prescriptive, not descriptive** – Ends with recommendations and ROI, not just "here's what happened"
- **Technical depth** – SQL uses window functions, CTEs, correlated subqueries; visualization uses dual-axis, reference lines, calculated fields
- **Executive-ready presentation** – Dashboard designed for stakeholder consumption, not analyst self-satisfaction

---

## The Full Analysis

**Live Dashboard:** [Sales Team Performance Analytics on Tableau Public](https://public.tableau.com/app/profile/hamza.bashir.butt/viz/Sales_Team_Performance_Analytics/Dashboard1)

**GitHub Repository (with SQL, Python, methodology):** [Coming soon]

The repository includes:
- Python data generation script
- 15 SQL analytical queries (window functions, CTEs, Pareto analysis)
- 6-sheet Tableau workbook
- Full methodology documentation
- Strategic recommendations with financial modeling

---

## Applying This to Your Team

Even without the exact same tools, the analytical framework transfers:

1. **Segment your team** by performance tier AND tenure — don't lump underperformers together
2. **Check activity levels before assuming skill gaps** — the highest-leverage coaching often addresses volume, not technique
3. **Look for territory or segment-level patterns** — some problems can't be solved with individual coaching
4. **Model the financial opportunity** — coaching without ROI framing loses executive support

If your CRM has quota attainment, activity data, and pipeline metrics (most do), you can run this analysis on your own team in a few days.

---

## About Me

I'm **Hamza Butt**, a Business Operations & Revenue Analytics professional with 2+ years driving performance analytics and process optimization across UK fintech and energy verticals. Currently open to Business Operations Analyst, Revenue Operations Analyst, and BI Analyst roles in UAE, KSA, Qatar, Malaysia, and remote US/UK SaaS.

If you're building or scaling a sales operation and need this kind of analytical thinking on your team, let's talk.

**Connect on LinkedIn:** [linkedin.com/in/hamzabutt01](https://linkedin.com/in/hamzabutt01)

---

*If this analysis was useful, share it with a sales leader who's trying to figure out where to focus their coaching investment. And follow me for more RevOps analytics case studies — I'm publishing three portfolio projects this month.*

---

**#SalesOps #RevenueOperations #SalesAnalytics #DataAnalytics #B2BSales #SalesLeadership #Tableau #SQL #BusinessIntelligence #FintechCareers**