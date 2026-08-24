# Hospital Capacity & Resource Analysis using SQL

A SQL-driven analysis of hospital bed capacity, staffing, and patient satisfaction — built to identify operational bottlenecks and support resource allocation decisions.

## Project Overview

Hospitals constantly balance limited beds, staff schedules, and patient demand. This project analyzes a hospital operations dataset sourced from Kaggle to answer 15 business questions — ranging from basic admission counts to advanced trend and relationship analysis using SQL window functions and CTEs.

**Tech Stack:** MySQL 8.0 · MySQL Workbench · [Kaggle Dataset](https://www.kaggle.com/datasets/jaderz/hospital-beds-management)

## Database Schema

| Table | Rows | Columns |
|---|---:|---|
| `patients` | 988 | patient_id, name, age, arrival_date, departure_date, service, satisfaction |
| `staff` | 110 | staff_id, staff_name, role, service |
| `services_weekly` | 208 | week, month, service, available_beds, patients_request, patients_admitted, patients_refused, patient_satisfaction, staff_morale, event |
| `staff_schedule` | 6,552 | week, staff_id, staff_name, role, service, present |

**Total: 7,858 rows across 4 relational tables**

## Data Cleaning

- Removed 12 rows with invalid `age = 0` from the `patients` table (~1.2% of data).
- Cleaning query: `sql/03_data_cleaning.sql`
- ## Repository Structure

```text
├── 01_schema.sql
├── 02_data_verification.sql
├── 03_data_cleaning.sql
├── 04_admissions_satisfaction.sql
├── 05_capacity_staffing.sql
├── 06_trend_correlation_analysis.sql
├── Hospital_SQL_Project_Presentation.pptx
├── README.md
├── patients.csv
├── services_weekly.csv
├── staff.csv
└── staff_schedule.csv

## SQL Techniques Used

- Aggregate functions (`SUM`, `AVG`, `COUNT`) with `GROUP BY`
- Multi-table `JOIN`s across relational tables
- Window functions: `RANK()`, `LAG()` with `PARTITION BY`
- Common Table Expressions (CTEs), including chained/multiple CTEs
- Conditional aggregation using `CASE WHEN`
- Date calculations using `DATEDIFF()` and date formatting functions
- Data cleaning using `DELETE`
- Data type correction using `ALTER TABLE`

## Business Questions & Insights

### Basic — Admissions & Satisfaction Overview

**Q1. How many patients were admitted in each service?**

Emergency (260), Surgery (253), ICU (238), General Medicine (237). Admissions are fairly evenly distributed across services, with no single service dominating overall patient volume.

**Q2. Which service has the highest number of admitted patients?**

Emergency, with 260 admissions — making it the service with the highest patient volume and an important priority for capacity planning.

**Q3. How many staff members are there for each role?**

Nurses (69), Nursing Assistants (23), Doctors (18). Nurses make up approximately 63% of the workforce, making nurse scheduling an important operational consideration.

**Q4. What is the average patient satisfaction score for each service?**

Surgery (80.28), ICU (79.96), Emergency (79.64), General Medicine (78.35). Scores are relatively close across services, ranging from approximately 78 to 80, with no service showing a dramatic difference in average patient experience.

**Q5. What is the average length of stay for patients in each service?**

Surgery (7.85 days), ICU (7.60 days), Emergency (7.17 days), General Medicine (6.90 days). Surgery and ICU patients have the longest average stays, highlighting the importance of bed-turnover planning in these services.

### Intermediate — Capacity & Staffing Insights

**Q6. Which service has the highest patient refusal rate?**

Emergency: 5,008 of 6,193 requests were refused — an **80.87% refusal rate**. This represents the most significant capacity pressure identified in the dataset.

**Q7. In which week were the most staff absences recorded?**

Week 3, with 126 absences. This represents a notable staffing gap that could be cross-checked against admission levels and operational events.

**Q8. Which service has the lowest average available beds?**

ICU, with an average of 14.85 available beds. This represents the tightest average bed capacity among the services analyzed.

**Q9. Does patient satisfaction drop during flu weeks vs. no-event weeks?**

No-event weeks average 79.73 satisfaction compared with 78.74 during flu weeks. This represents a modest decline of approximately 1 point during flu weeks.

**Q10. Which staff member has worked the most weeks?**

Staff ID `STF-4e69ee46`, present for 34 weeks — the highest attendance count in the dataset. This staff member could be considered when reviewing workload distribution and scheduling balance.

### Advanced — Trend & Relationship Analysis

**Q11. Rank weeks within each service by patient satisfaction (window function).**

Using `RANK() OVER (PARTITION BY service ...)`, each service's highest- and lowest-satisfaction weeks can be identified and compared. This can help identify weeks with unusually strong or weak patient satisfaction.

**Q12. Is there a relationship between staff morale and patient satisfaction?**

Very High Morale (80.84 avg satisfaction), Low Morale (80.44), Moderate Morale (78.89). Patient satisfaction varies only modestly across morale categories, suggesting a weak association between staff morale and patient satisfaction in this dataset.

**Q13. Show the month-wise trend of patients admitted per service.**

Emergency admissions declined across the observed months, falling from 124 in month 1 to 63 by month 7. This trend could be considered when planning future staffing and capacity requirements.

**Q14. Identify the top 3 weeks with the strongest combination of high refusal rate and low staff morale.**

Week 1 (General Medicine, refusal 81.59%, morale 43), Week 19 (Emergency, refusal 77.14%, morale 45), Week 52 (General Medicine, refusal 71.11%, morale 40).

By ranking refusal rate and staff morale separately and combining the ranks, these weeks surface as having the strongest combination of high refusal pressure and low morale. General Medicine appears twice among the top three weeks, highlighting a recurring operational pressure point in the dataset.

**Q15. Is there a pattern between staff attendance rate and patient satisfaction per service?**

Emergency (60.40% attendance, 77.88 satisfaction), Surgery (60.23%, 79.27), ICU (60.12%, 81.62), General Medicine (59.00%, 81.23).

Attendance rates are relatively similar across services, while satisfaction varies. This suggests that attendance rate alone does not explain the differences in patient satisfaction.

**Note:** This analysis compares service-level averages and represents an association, not a formal statistical correlation.

## Key Takeaways

1. **Emergency capacity pressure** — 80.87% of Emergency requests are refused, making it the most significant operational issue identified in the dataset.

2. **ICU: fewest beds, highest satisfaction** — ICU has the lowest average available bed count (14.85) while showing the highest average patient satisfaction (81.62), making this an area worth investigating further.

3. **Demand is declining in observed months** — Emergency admissions fell from 124 to 63 across the observed months.

4. **Morale shows weak association with satisfaction** — Patient satisfaction varies only modestly across the different staff morale categories.

5. **Recurring operational pressure** — General Medicine appears twice among the top three weeks with the strongest combination of high refusal rate and low staff morale.

6. **Flu weeks show a modest satisfaction dip** — Average satisfaction fell from 79.73 during no-event weeks to 78.74 during flu weeks.

## Sample Query

```sql
-- Identify the top 3 weeks with the strongest combination of
-- high refusal rate and low staff morale

WITH ranked_data AS (
    SELECT 
        week,
        service,
        ROUND(
            patients_refused * 100.0 / patients_request,
            2
        ) AS refusal_rate_pct,
        staff_morale,
        RANK() OVER (
            ORDER BY patients_refused * 100.0 / patients_request DESC
        ) AS refusal_rank,
        RANK() OVER (
            ORDER BY staff_morale ASC
        ) AS morale_rank
    FROM services_weekly
)
SELECT 
    week,
    service,
    refusal_rate_pct,
    staff_morale,
    (refusal_rank + morale_rank) AS combined_rank_score
FROM ranked_data
ORDER BY combined_rank_score ASC
LIMIT 3;

## Presentation

A full walkthrough (all 15 queries with results and business insights) is available in the project presentation — built for interview and portfolio use.

**[View the Project Presentation](./Hospital_SQL_Project_Presentation.pptx)**

## Author

**Ansh Sharma**

[LinkedIn](https://www.linkedin.com/in/ansh-sharma-02445b360/) · [Email](mailto:dansh4270@gmail.com)
