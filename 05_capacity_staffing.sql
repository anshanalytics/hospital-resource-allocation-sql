-- Which service has the highest patient refusal rate (% of requests that were refused)?
USE hospital_db;

-- Which service has the highest patient refusal rate (% of requests that were refused)?
SELECT service,
    SUM(patients_refused) AS total_refused,
    SUM(patients_request) AS total_requests,
    CONCAT(ROUND(SUM(patients_refused) * 100.0 / SUM(patients_request), 2), "%") AS refusal_rate_pct
FROM services_weekly
GROUP BY service
ORDER BY refusal_rate_pct DESC
LIMIT 1;

-- In which week were the most staff absences (present = 0) recorded?
SELECT week, COUNT(*) AS staff_absences
FROM staff_schedule
WHERE present = 0
GROUP BY week
ORDER BY staff_absences DESC
LIMIT 1;

-- Which service has the lowest average available beds?
SELECT service,
       ROUND(AVG(available_beds), 2) AS avg_ava_beds
FROM services_weekly
GROUP BY service
HAVING ROUND(AVG(available_beds), 2) = (
    SELECT MIN(avg_beds)
    FROM (
        SELECT ROUND(AVG(available_beds), 2) AS avg_beds
        FROM services_weekly
        GROUP BY service
    ) AS t
);

-- Compare average patient_satisfaction during weeks where event = 'flu' vs 
-- weeks with no event — does satisfaction drop during flu weeks?

SELECT 
    event,
    ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
FROM services_weekly
WHERE event IN ('flu', 'none')
GROUP BY event;

-- Which staff member has worked the most weeks (highest count of present = 1 in staff_schedule)?

SELECT 
    staff_id,
    COUNT(*) AS weeks_worked
FROM staff_schedule
WHERE present = 1
GROUP BY staff_id
ORDER BY weeks_worked DESC
LIMIT 1;







