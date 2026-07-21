-- =============================================================================
-- Data Loading Script: Load Data into Bronze Tables
-- Database: cadetos_bronze
-- Project : CadetOS Data Warehouse
-- =============================================================================
-- Purpose:
--     Loads CSV files directly into the Bronze layer tables.
--     Lines are terminated by '\r\n' (CRLF) since the source CSVs have Windows 
--     style line endings. This prevents hidden '\r' characters in the database.
-- =============================================================================

USE cadetos_bronze;

-- Disable constraints & logs for faster loading (optional, good for interviews)
SET UNIQUE_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Registration Ingestion
TRUNCATE TABLE registration;
LOAD DATA LOCAL INFILE '/Users/bhati/Documents/new_cadetos/datasets/registration.csv'
INTO TABLE registration
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Corrected from '\n' to handle CRLF
IGNORE 1 ROWS;

-- 2. NCC Unit Ingestion
TRUNCATE TABLE ncc_unit;
LOAD DATA LOCAL INFILE '/Users/bhati/Documents/new_cadetos/datasets/ncc_unit.csv'
INTO TABLE ncc_unit
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Corrected from '\n' to handle CRLF
IGNORE 1 ROWS;

-- 3. Attendance Ingestion
TRUNCATE TABLE attendance;
LOAD DATA LOCAL INFILE '/Users/bhati/Documents/new_cadetos/datasets/attendance.csv'
INTO TABLE attendance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Corrected from '\n' to handle CRLF
IGNORE 1 ROWS;

-- 4. Rank Details Ingestion
TRUNCATE TABLE rank_details;
LOAD DATA LOCAL INFILE '/Users/bhati/Documents/new_cadetos/datasets/rank_details.csv'
INTO TABLE rank_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Corrected from '\n' to handle CRLF
IGNORE 1 ROWS;

-- 5. Camp Details Ingestion
TRUNCATE TABLE camp_details;
LOAD DATA LOCAL INFILE '/Users/bhati/Documents/new_cadetos/datasets/camp_details.csv'
INTO TABLE camp_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Corrected from '\n' to handle CRLF
IGNORE 1 ROWS;

-- 6. Certificate Results Ingestion
TRUNCATE TABLE certificate_results;
LOAD DATA LOCAL INFILE '/Users/bhati/Documents/new_cadetos/datasets/certificate_results.csv'
INTO TABLE certificate_results
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Corrected from '\n' to handle CRLF
IGNORE 1 ROWS;

SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;

-- Output Ingestion Counts (Verification)
SELECT 'registration' AS table_name, COUNT(*) AS record_count FROM registration
UNION ALL
SELECT 'ncc_unit', COUNT(*) FROM ncc_unit
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance
UNION ALL
SELECT 'rank_details', COUNT(*) FROM rank_details
UNION ALL
SELECT 'camp_details', COUNT(*) FROM camp_details
UNION ALL
SELECT 'certificate_results', COUNT(*) FROM certificate_results;
