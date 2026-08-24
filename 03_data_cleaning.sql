-- Rows where age = 0 (likely bad data)
SELECT COUNT(*) AS invalid_age_rows FROM patients WHERE age = 0;

-- Remove patients with invalid age (age = 0 is not a valid value)
DELETE FROM patients WHERE age = 0;

-- Verify cleanup: total patients should reduce, invalid age rows should be 0
SELECT COUNT(*) AS total_patients FROM patients;
SELECT COUNT(*) AS invalid_age_rows FROM patients WHERE age = 0;
