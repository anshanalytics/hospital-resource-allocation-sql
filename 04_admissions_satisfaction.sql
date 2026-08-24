-- How many patients were admitted in each service (from the patients table)?
SELECT service, COUNT(*) AS admitted_patients
FROM patients
GROUP BY service
ORDER BY admitted_patients DESC;

-- Which service has the highest number of admitted patient
SELECT service, COUNT(*) AS admitted_patients
FROM patients
GROUP BY service
ORDER BY admitted_patients DESC
LIMIT 1;

-- How many staff members are there for each role (doctor, nurse, nursing_assistant)?
SELECT role,
COUNT(*) AS total_members
FROM staff
GROUP BY role
ORDER BY total_members DESC;

-- What is the average patient satisfaction score for each service?
SELECT service, 
ROUND(AVG(satisfaction),2) AS avg_patient_satisfaction
FROM patients
GROUP BY service
ORDER BY avg_patient_satisfaction DESC;

-- What is the average length of stay (days between arrival_date and departure_date) for patients in each service?

SELECT service,
ROUND(AVG(DATEDIFF(departure_date, arrival_date)),2) AS avg_length_of_stay
FROM patients
GROUP BY service
ORDER BY avg_length_of_stay DESC;














