# CadetOS Data Catalog

This catalog documents the schemas, fields, and data types across the three layers of the **CadetOS Data Warehouse**.

---

## 1. Bronze Layer (Landing Zone - Raw Schemas)
Stores raw CSV ingestion data as-is. All ID fields are imported as `VARCHAR(20)` strings to prevent key truncation.

### `registration`
*   `dli_number` (VARCHAR(20), PK): Unique cadet alphanumeric identifier.
*   `full_name` (VARCHAR(100)): Full name of the cadet.
*   `gender` (VARCHAR(10)): Raw gender text input.
*   `date_of_birth` (VARCHAR(20)): Date of birth (unstructured format).
*   `aadhaar_number` (VARCHAR(20)): 12-digit Aadhaar number.
*   `email` (VARCHAR(100)): Email address.
*   `mobile_number` (VARCHAR(20)): Primary mobile number.
*   `alternate_mobile_number` (VARCHAR(20)): Alternate contact number.
*   `city` (VARCHAR(50)): City of residence.
*   `state` (VARCHAR(50)): State of residence.
*   `pincode` (VARCHAR(10)): PIN code.
*   `father_name` (VARCHAR(100)): Father's name.
*   `mother_name` (VARCHAR(100)): Mother's name.
*   `college` (VARCHAR(150)): Enrolled college name.
*   `course` (VARCHAR(100)): Course of study.
*   `college_roll_number` (VARCHAR(50)): Student roll number.

### `ncc_unit`
*   `dli_number` (VARCHAR(20), PK): Alphanumeric cadet link identifier.
*   `unit` (VARCHAR(100)): Raw NCC unit name.
*   `directorate` (VARCHAR(100)): Raw NCC directorate name.
*   `group_name` (VARCHAR(100)): Raw NCC group name.
*   `squadron` (VARCHAR(100)): Squadron affiliation (Alpha, Bravo, Charlie, Delta).
*   `cadet_year` (INT): Active year of the cadet (1, 2, or 3).
*   `joining_date` (VARCHAR(20)): Date the cadet joined the NCC.
*   `enrollment_status` (VARCHAR(50)): Status (Active, Completed, Passed Out).

### `attendance`
*   `attendance_id` (VARCHAR(20), PK): Unique transaction key.
*   `dli_number` (VARCHAR(20), FK): Cadet identifier.
*   `parade_date` (VARCHAR(20)): Date of the parade.
*   `attendance_status` (VARCHAR(20)): Raw attendance (P, Present, A, Absent).
*   `late_status` (VARCHAR(20)): Raw late flag indicator.
*   `excused_leave` (VARCHAR(20)): Raw excused flag indicator.

---

## 2. Silver Layer (Cleaned & Validated Zone)
Standardized structures where text casing, spelling errors, phone numbers, and timeline anomalies have been conformed and parsed.

### `registration`
*   `dli_number` (VARCHAR(20), PK): Cleaned cadet identifier.
*   `gender` (VARCHAR(10)): Conformed to Title Case: `Male` or `Female`.
*   `date_of_birth` (DATE): Casted into native database date format.
*   `mobile_number` (VARCHAR(10)): Standardized 10-digit number.
*   `college` (VARCHAR(150)): Standardized names (e.g. conformed to `Delhi Technological University (DTU)`).

### `ncc_unit`
*   `squadron` (VARCHAR(50)): Cleaned and standard Title Case names.
*   `enrollment_status` (VARCHAR(50)): Standardized Title Case categories.
*   `joining_date` (DATE): Casted into native database date format.

### `attendance`
*   `attendance_status` (VARCHAR(10)): Standardized to `Present` or `Absent`.
*   `late` (VARCHAR(3)): Standardized to `Yes` or `No`.
*   `excused` (VARCHAR(3)): Standardized to `Yes` or `No`.
*   `parade_date` (DATE): Cleaned date. Filtered to exclude records before cadet joining date.

### `rank_details`
*   `rank_name` (VARCHAR(10)): Conformed to standardized codes: `SUO`, `JUO`, `CQMS`, `CSM`, `SGT`, `CPL`, `LCPL`, `CDT`.
*   `assigned_date` (DATE): Cleaned date. Filtered using window functions to exclude demotions.

---

## 3. Gold Layer (Star Schema - Analytics Zone)
Models data into dimensional and fact structures optimized for analytics tools like Tableau.

### Dimensions
*   `dim_cadet`: Master cadet dimension containing attributes and pre-calculated aggregations (`total_camp_count`, `total_attendance_records`).
*   `dim_rank`: Ranks dimensional metadata.
*   `dim_certificate`: Certificate dimension.
*   `dim_camp`: Camp metadata.
*   `dim_date`: Calendar dimension detailing year, month, quarter, week of year, day name, and weekend indicators.

### Facts
*   `fct_attendance`: Attendance transaction facts.
*   `fct_camp_participation`: Camp participation facts.
*   `fct_rank_assignment`: Cadet promotion timeline records.
*   `fct_certificate_achievement`: Exam attempts and results facts.
