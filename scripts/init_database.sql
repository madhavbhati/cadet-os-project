-- =============================================================================
-- Database Initialization Script: Setup CadetOS Warehouses
-- Project : CadetOS Data Warehouse
-- =============================================================================
-- Purpose:
--     Initializes the three distinct database environments (Bronze, Silver, Gold)
--     required for the Medallion architecture execution.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS cadetos_bronze;
CREATE DATABASE IF NOT EXISTS cadetos_silver;
CREATE DATABASE IF NOT EXISTS cadetos_gold;

SELECT 'Databases cadetos_bronze, cadetos_silver, and cadetos_gold initialized successfully.' AS Status;
