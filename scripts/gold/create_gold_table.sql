-- =============================================================================
-- DDL Script: Create Gold Tables (Star Schema)
-- Database: cadetos_gold
-- Project : CadetOS Data Warehouse
-- =============================================================================
-- Purpose:
--     Create analytics-optimized tables (Star Schema) ready for BI tools like Tableau.
--
-- Design Principles:
--     - Dimension Tables: Standard star schema dimensions (dim_cadet, dim_rank, 
--       dim_certificate, dim_camp, dim_date).
--     - Fact Tables: Granular transaction tables (fct_attendance, fct_camp_participation, 
--       fct_rank_assignment, fct_certificate_achievement).
--     - Aggregate Tables: Pre-calculated summaries for rapid dashboard loading.
--     - Indexes: Optimized for joins and filtering on common business grains.
-- =============================================================================

DROP DATABASE IF EXISTS cadetos_gold;
CREATE DATABASE cadetos_gold;
USE cadetos_gold;

-- =============================================================================
-- SECTION 1: DIMENSION TABLES
-- =============================================================================

-- =============================================================================
-- Table: dim_cadet (Cadet Master Dimension)
-- Grain: One row per cadet (SCD Type 1)
-- =============================================================================
CREATE TABLE dim_cadet (
    cadet_id INT AUTO_INCREMENT PRIMARY KEY,
    dli_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    age_at_enrollment INT,  -- Calculated during ETL
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
    unit VARCHAR(100),
    directorate VARCHAR(100),
    group_name VARCHAR(100),
    squadron VARCHAR(100),
    cadet_year INT,
    joining_date DATE,
    enrollment_status VARCHAR(30),
    current_rank VARCHAR(30),  -- Latest rank held
    latest_rank_date DATE,  -- Date latest rank assigned
    b_certificate_status VARCHAR(20),  -- Completed / Not Completed
    c_certificate_status VARCHAR(20),  -- Completed / Not Completed
    total_camp_count INT DEFAULT 0,  -- Pre-calculated fact summary
    total_attendance_records INT DEFAULT 0,  -- Pre-calculated fact summary
    is_active INT DEFAULT 1,  -- 1=Active, 0=Inactive/Completed
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================================================
-- Table: dim_rank (Rank Level Reference Dimension)
-- =============================================================================
CREATE TABLE dim_rank (
    rank_id INT PRIMARY KEY,
    rank_name VARCHAR(30) NOT NULL UNIQUE,
    rank_level INT NOT NULL,  -- 1=SUO (highest) to 8=CDT (lowest)
    rank_description VARCHAR(100)
);

-- =============================================================================
-- Table: dim_certificate (Certificate Reference Dimension)
-- =============================================================================
CREATE TABLE dim_certificate (
    certificate_id INT PRIMARY KEY,
    certificate_name VARCHAR(50) NOT NULL UNIQUE,
    certificate_level INT NOT NULL,  -- 1=A, 2=B, 3=C
    requirements VARCHAR(500),
    typical_year INT  -- Year typically completed
);

-- =============================================================================
-- Table: dim_camp (Camp Type Reference Dimension)
-- =============================================================================
CREATE TABLE dim_camp (
    camp_id INT PRIMARY KEY,
    camp_type VARCHAR(50) NOT NULL UNIQUE,
    camp_description VARCHAR(200),
    is_mandatory INT,  -- 1=Mandatory, 0=Optional
    typical_duration_days INT
);

-- =============================================================================
-- Table: dim_date (Date Dimension for Time Analysis)
-- Grain: One row per calendar date (allows easy weekend/month/quarter analysis)
-- =============================================================================
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY, -- Format: YYYYMMDD
    calendar_date DATE NOT NULL UNIQUE,
    day_of_week INT,  -- 1=Sunday to 7=Saturday (MySQL standard)
    day_name VARCHAR(10),
    week_of_year INT,
    month INT,
    month_name VARCHAR(10),
    quarter INT,
    year INT,
    is_weekend INT  -- 1=Weekend, 0=Weekday
);

-- =============================================================================
-- SECTION 2: FACT TABLES
-- =============================================================================

-- =============================================================================
-- Table: fct_attendance (Parade Attendance Transactions)
-- Grain: One row per cadet per parade date
-- =============================================================================
CREATE TABLE fct_attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    dli_number VARCHAR(20) NOT NULL,
    cadet_id INT,  -- FK to dim_cadet
    parade_date DATE,
    parade_date_id INT,  -- FK to dim_date
    attendance_status VARCHAR(20),  -- Present, Absent
    is_late INT,  -- 1=Yes, 0=No
    is_excused INT,  -- 1=Yes, 0=No
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cadet_id) REFERENCES dim_cadet(cadet_id),
    INDEX idx_date (parade_date),
    INDEX idx_dli (dli_number)
);

-- =============================================================================
-- Table: fct_camp_participation (Camp Attendance Facts)
-- Grain: One row per cadet per camp participation
-- =============================================================================
CREATE TABLE fct_camp_participation (
    camp_participation_id INT AUTO_INCREMENT PRIMARY KEY,
    dli_number VARCHAR(20) NOT NULL,
    cadet_id INT,  -- FK to dim_cadet
    camp_type VARCHAR(50),
    camp_location VARCHAR(100),
    camp_year INT,
    camp_type_id INT,  -- FK to dim_camp
    is_completed INT DEFAULT 1,  -- 1=Completed, 0=Not attended
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cadet_id) REFERENCES dim_cadet(cadet_id),
    INDEX idx_cadet (dli_number),
    INDEX idx_camp_year (camp_year)
);

-- =============================================================================
-- Table: fct_rank_assignment (Rank Assignment Timeline)
-- Grain: One row per cadet per rank assignment
-- =============================================================================
CREATE TABLE fct_rank_assignment (
    rank_assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    dli_number VARCHAR(20) NOT NULL,
    cadet_id INT,  -- FK to dim_cadet
    rank_name VARCHAR(30),
    rank_id INT,  -- FK to dim_rank
    assigned_date DATE,
    assigned_date_id INT,  -- FK to dim_date
    days_in_rank INT,  -- Calculated post-load if needed
    is_current_rank INT DEFAULT 0,  -- 1=Current, 0=Historical
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cadet_id) REFERENCES dim_cadet(cadet_id),
    INDEX idx_dli (dli_number),
    INDEX idx_assigned_date (assigned_date)
);

-- =============================================================================
-- Table: fct_certificate_achievement (Certificate Achievements)
-- Grain: One row per cadet per certificate passed
-- =============================================================================
CREATE TABLE fct_certificate_achievement (
    certificate_achievement_id INT AUTO_INCREMENT PRIMARY KEY,
    dli_number VARCHAR(20) NOT NULL,
    cadet_id INT,  -- FK to dim_cadet
    certificate_type VARCHAR(20),  -- A, B, C
    certificate_id INT,  -- FK to dim_certificate
    grade VARCHAR(10),  -- A, B, C, D, F
    passing_year INT,
    is_passed INT,  -- 1=Passed, 0=Failed
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cadet_id) REFERENCES dim_cadet(cadet_id),
    INDEX idx_dli (dli_number),
    INDEX idx_certificate (certificate_type)
);

-- =============================================================================
-- SECTION 3: AGGREGATE/SUMMARY TABLES (For Fast Dashboard Response)
-- =============================================================================

-- =============================================================================
-- Table: agg_cadet_annual_metrics (Annual metrics per cadet)
-- =============================================================================
CREATE TABLE agg_cadet_annual_metrics (
    cadet_metric_id INT AUTO_INCREMENT PRIMARY KEY,
    cadet_id INT,
    dli_number VARCHAR(20),
    year INT,
    total_parades INT,
    present_count INT,
    absent_count INT,
    leave_count INT,
    attendance_percentage DECIMAL(5,2),
    camps_attended INT,
    ranks_held INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cadet_id) REFERENCES dim_cadet(cadet_id),
    INDEX idx_year (year),
    INDEX idx_cadet (cadet_id)
);

-- =============================================================================
-- Table: agg_unit_summary (Unit-level aggregations)
-- =============================================================================
CREATE TABLE agg_unit_summary (
    unit_metric_id INT AUTO_INCREMENT PRIMARY KEY,
    unit VARCHAR(100),
    directorate VARCHAR(100),
    squadron VARCHAR(100),
    total_cadets INT,
    active_cadets INT,
    completed_cadets INT,
    avg_attendance_percentage DECIMAL(5,2),
    total_ranks_assigned INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_unit (unit),
    INDEX idx_squadron (squadron)
);

-- =============================================================================
-- SECTION 4: INDEX OPTIMIZATION
-- =============================================================================
ALTER TABLE fct_attendance ADD INDEX idx_attendance_status (attendance_status);
ALTER TABLE fct_attendance ADD INDEX idx_is_late (is_late);

ALTER TABLE fct_camp_participation ADD INDEX idx_camp_type (camp_type);
ALTER TABLE fct_camp_participation ADD INDEX idx_is_completed (is_completed);

ALTER TABLE fct_rank_assignment ADD INDEX idx_rank_name (rank_name);
ALTER TABLE fct_rank_assignment ADD INDEX idx_is_current (is_current_rank);

ALTER TABLE fct_certificate_achievement ADD INDEX idx_grade (grade);
ALTER TABLE fct_certificate_achievement ADD INDEX idx_is_passed (is_passed);

SELECT '=== GOLD LAYER TABLES CREATED ===' AS status;
SHOW TABLES;
