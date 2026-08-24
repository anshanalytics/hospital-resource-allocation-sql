USE hospital_db;
---- Count total rows in each table to verify import

SELECT COUNT(*) AS total_patients FROM patients;
SELECT COUNT(*) AS total_staff FROM staff;
SELECT COUNT(*) AS total_weekly_records FROM services_weekly;
SELECT COUNT(*) AS total_schedule_records FROM staff_schedule;

-- Preview first 5 rows of each table to visually check data quality
SELECT * FROM patients LIMIT 5;
SELECT * FROM services_weekly LIMIT 5;
SELECT * FROM staff LIMIT 5;
SELECT * FROM staff_schedule LIMIT 5;