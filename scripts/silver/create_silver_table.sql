-- =============================================================================
-- DDL Script: Create Silver Tables (Corrected for Data Integrity)
-- Database: cadetos_silver
-- Project : CadetOS Data Warehouse
-- =============================================================================
-- Purpose:
--     Creates all Silver Layer tables for cleaned and standardized data.
--     - No FOREIGN KEYS belong in Silver; those are defined in Gold.
--     - Date fields are defined as native DATE types (standardizing them early).
--     - Natural business IDs are kept as VARCHAR(20) PRIMARY KEYs to preserve 
--       the unique keys provided by the source system.
-- =============================================================================

DROP DATABASE IF EXISTS cadetos_silver;
CREATE DATABASE cadetos_silver;
USE cadetos_silver;

-- ============================================================================
-- Table: registration
-- ============================================================================
DROP TABLE IF EXISTS registration;
CREATE TABLE registration (
    dli_number VARCHAR(20) PRIMARY KEY, -- Made primary key since it is unique
    full_name VARCHAR(100),
    gender VARCHAR(10),
    date_of_birth DATE, -- Date type (clean)
    aadhaar_number VARCHAR(20),
    email VARCHAR(100),
    mobile_number VARCHAR(15),
    alternate_mobile_number VARCHAR(15),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    father_name VARCHAR(100),
    mother_name VARCHAR(100),
    college VARCHAR(100),
    course VARCHAR(100),
    college_roll_number VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_email (email)
);

-- ============================================================================
-- Table: ncc_unit
-- ============================================================================
DROP TABLE IF EXISTS ncc_unit;
CREATE TABLE ncc_unit (
    dli_number VARCHAR(20) PRIMARY KEY, -- Made primary key (1-to-1 with registration)
    unit VARCHAR(100),
    directorate VARCHAR(100),
    group_name VARCHAR(100),
    squadron VARCHAR(100),
    cadet_year INT,
    joining_date DATE, -- Corrected from VARCHAR to DATE
    enrollment_status VARCHAR(30),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_squadron (squadron)
);

-- ============================================================================
-- Table: attendance
-- ============================================================================
DROP TABLE IF EXISTS attendance;
CREATE TABLE attendance (
    attendance_id VARCHAR(20) PRIMARY KEY, -- Corrected from AUTO_INCREMENT INT to VARCHAR
    dli_number VARCHAR(20),
    parade_date DATE, -- Corrected from VARCHAR to DATE
    attendance_status VARCHAR(20),
    late VARCHAR(10), -- Will contain 'Yes' or 'No' standard
    excused VARCHAR(10), -- Will contain 'Yes' or 'No' standard
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_dli_number (dli_number),
    INDEX idx_parade_date (parade_date),
    INDEX idx_attendance_status (attendance_status)
);

-- ============================================================================
-- Table: camp_details
-- ============================================================================
DROP TABLE IF EXISTS camp_details;
CREATE TABLE camp_details (
    camp_id VARCHAR(20) PRIMARY KEY, -- Corrected from AUTO_INCREMENT INT to VARCHAR
    dli_number VARCHAR(20),
    camp_type VARCHAR(50),
    camp_location VARCHAR(100),
    camp_year INT,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_dli_number (dli_number),
    INDEX idx_camp_type (camp_type),
    INDEX idx_camp_year (camp_year)
);

-- ============================================================================
-- Table: certificate_results
-- ============================================================================
DROP TABLE IF EXISTS certificate_results;
CREATE TABLE certificate_results (
    certificate_id VARCHAR(20) PRIMARY KEY, -- Corrected from AUTO_INCREMENT INT to VARCHAR
    dli_number VARCHAR(20),
    certificate_type VARCHAR(20),
    grade VARCHAR(10),
    passing_year INT,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_dli_number (dli_number),
    INDEX idx_certificate_type (certificate_type),
    INDEX idx_passing_year (passing_year)
);

-- ============================================================================
-- Table: rank_details
-- ============================================================================
DROP TABLE IF EXISTS rank_details;
CREATE TABLE rank_details (
    rank_id VARCHAR(20) PRIMARY KEY, -- Corrected from AUTO_INCREMENT INT to VARCHAR
    dli_number VARCHAR(20),
    rank_name VARCHAR(30),
    assigned_date DATE, -- Corrected from VARCHAR to DATE
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_dli_number (dli_number),
    INDEX idx_rank_name (rank_name),
    INDEX idx_assigned_date (assigned_date)
);

-- ============================================================================
-- Verification
-- ============================================================================
SELECT '=== SILVER LAYER TABLES CREATED ===' AS status;
SHOW TABLES;
