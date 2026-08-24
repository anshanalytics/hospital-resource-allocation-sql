-- Within each service, rank the weeks by patient satisfaction (highest to lowest)
USE hospital_db;
SELECT week,service,patient_satisfaction,
RANK() OVER(PARTITION BY service ORDER BY patient_satisfaction DESC) AS satisfaction_rank
FROM services_weekly;
-- Is there a relationship between staff_morale 
-- and patient_satisfaction? (Do weeks with low staff_morale also show low patient_satisfaction?)
-- Compare patient satisfaction across different staff morale ranges
SELECT
    CASE 
        WHEN staff_morale >= 80 THEN 'Very High Morale'
        WHEN staff_morale >= 60 THEN 'Moderate Morale'
        ELSE 'Low Morale'
    END AS morale_category,
    ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction,
    COUNT(*) AS total_weeks
FROM services_weekly
GROUP BY morale_category
ORDER BY avg_satisfaction DESC;

-- Show the month-wise trend of patients_admitted for each service — is demand increasing or decreasing over time?

WITH monthly_data AS (
    SELECT
        service,
        month,
        SUM(patients_admitted) AS total_admitted
    FROM services_weekly
    GROUP BY service, month
)
SELECT
    service,
    month,
    total_admitted,
    LAG(total_admitted) OVER (
        PARTITION BY service
        ORDER BY month
    ) AS previous_month_admitted,
    total_admitted - LAG(total_admitted) OVER (
        PARTITION BY service
        ORDER BY month
    ) AS change_from_previous_month
FROM monthly_data
ORDER BY service, month;

-- Identify the top 3 "crisis weeks" — weeks 
-- where refusal rate was highest AND staff_morale was lowest at the same time.

WITH ranked_data AS (
    SELECT 
        week, 
        service,
        ROUND(patients_refused * 100.0 / patients_request, 2) AS refusal_rate_pct,
        staff_morale,
        RANK() OVER (ORDER BY (patients_refused * 100.0 / patients_request) DESC) AS refusal_rank,
        RANK() OVER (ORDER BY staff_morale ASC) AS morale_rank
    FROM services_weekly
)
SELECT 
    week, service, refusal_rate_pct, staff_morale,
    (refusal_rank + morale_rank) AS combined_rank_score
FROM ranked_data
ORDER BY combined_rank_score ASC
LIMIT 3;

-- Is there a pattern between staff attendance rate (% of present = 1)
--  and patient_satisfaction for a service — i.e., do services with more staff absences 
-- show lower patient satisfaction? 
WITH attendance_data AS (
    SELECT 
        service,
        ROUND(SUM(CASE WHEN present = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attendance_rate_pct
    FROM staff_schedule
    GROUP BY service
),
satisfaction_data AS (
    SELECT 
        service,
        ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
    FROM services_weekly
    GROUP BY service
)
SELECT 
    a.service,
    a.attendance_rate_pct,
    s.avg_satisfaction
FROM attendance_data a
JOIN satisfaction_data s ON a.service = s.service
ORDER BY a.attendance_rate_pct DESC;

