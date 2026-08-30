CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;


CREATE TABLE patients (
    patient_id VARCHAR(50) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    arrival_date DATE NOT NULL,
    departure_date DATE,
    service VARCHAR(50) NOT NULL,
    satisfaction INT
);

CREATE TABLE staff (
    staff_id VARCHAR(20) PRIMARY KEY AUTO_INCREMENT,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    service VARCHAR(50) NOT NULL
);

CREATE TABLE services_weekly (
    week INT NOT NULL,
    month INT NOT NULL,
    service VARCHAR(50) NOT NULL,
    available_beds INT,
    patients_request INT,
    patients_admitted INT,
    patients_refused INT,
    patient_satisfaction FLOAT,
    staff_morale FLOAT,
    event VARCHAR(100)
);

CREATE TABLE staff_schedule (
    week INT NOT NULL,
    staff_id VARCHAR(20) NOT NULL,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    service VARCHAR(50) NOT NULL,
    present TINYINT
);
