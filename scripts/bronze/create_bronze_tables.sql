-- =============================================================================
-- DDL Script: Create Bronze Tables (Corrected for String Keys)
-- Database: cadetos_bronze
-- Project : CadetOS Data Warehouse
-- =============================================================================
-- Purpose:
--     Create all Bronze Layer tables to ingest raw data as-is from CSVs.
--     All IDs are updated to VARCHAR(20) since the source CSV contains alphanumeric 
--     keys (e.g. 'ATT03603', 'CMP0001', 'CRT0001', 'RNK0001').
-- =============================================================================

CREATE DATABASE IF NOT EXISTS cadetos_bronze;
USE cadetos_bronze;

-- =============================================================================
-- Table: registration
-- =============================================================================
DROP TABLE IF EXISTS registration;
CREATE TABLE registration (
    dli_number VARCHAR(20),
    full_name VARCHAR(100),
    gender VARCHAR(10),
    date_of_birth VARCHAR(20),
    aadhaar_number VARCHAR(20),
    email VARCHAR(100),
    mobile_number VARCHAR(20),
    alternate_mobile_number VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    father_name VARCHAR(100),
    mother_name VARCHAR(100),
    college VARCHAR(150),
    course VARCHAR(100),
    college_roll_number VARCHAR(30)
);

-- =============================================================================
-- Table: ncc_unit
-- =============================================================================
DROP TABLE IF EXISTS ncc_unit;
CREATE TABLE ncc_unit (
    dli_number VARCHAR(20),
    unit VARCHAR(100),
    group_name VARCHAR(100),
    directorate VARCHAR(100),
    squadron VARCHAR(30),
    cadet_year INT,
    joining_date VARCHAR(20),
    enrollment_status VARCHAR(30)
);

-- =============================================================================
-- Table: attendance
-- =============================================================================
DROP TABLE IF EXISTS attendance;
CREATE TABLE attendance (
    attendance_id VARCHAR(20), -- Corrected from INT to VARCHAR
    dli_number VARCHAR(20),
    parade_date VARCHAR(20),
    attendance_status VARCHAR(20),
    late_status VARCHAR(10),
    excused_leave VARCHAR(10)
);

-- =============================================================================
-- Table: rank_details
-- =============================================================================
DROP TABLE IF EXISTS rank_details;
CREATE TABLE rank_details (
    rank_id VARCHAR(20), -- Corrected from INT to VARCHAR
    dli_number VARCHAR(20),
    rank_name VARCHAR(50),
    assigned_date VARCHAR(20)
);

-- =============================================================================
-- Table: camp_details
-- =============================================================================
DROP TABLE IF EXISTS camp_details;
CREATE TABLE camp_details (
    camp_id VARCHAR(20), -- Corrected from INT to VARCHAR
    dli_number VARCHAR(20),
    camp_type VARCHAR(100),
    camp_location VARCHAR(100),
    camp_year INT
);

-- =============================================================================
-- Table: certificate_results
-- =============================================================================
DROP TABLE IF EXISTS certificate_results;
CREATE TABLE certificate_results (
    certificate_id VARCHAR(20), -- Corrected from INT to VARCHAR
    dli_number VARCHAR(20),
    certificate_type VARCHAR(20),
    grade VARCHAR(10),
    passing_year INT
);

SELECT '=== BRONZE LAYER TABLES CREATED ===' AS status;
SHOW TABLES;
