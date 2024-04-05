-- Create a new database
CREATE DATABASE healthcare_analysis;

-- Use the database
USE healthcare_analysis;

-- Create the 'medical_examinations' table
CREATE TABLE medical_examinations (
    CustomerID VARCHAR(255) PRIMARY KEY,
    BMI FLOAT,
    HBA1C FLOAT,
    HeartIssues VARCHAR(3),
    AnyTransplants VARCHAR(3),
    Cancerhistory VARCHAR(3),
    NumberOfMajorSurgeries VARCHAR(255),
    smoker VARCHAR(5)
);

-- Create the 'hospitalisation' table (similar structure)
CREATE TABLE hospitalisation (
    CustomerID VARCHAR(255) PRIMARY KEY, 
    year INT,
    month VARCHAR(3),
    date INT,
    children INT,
    charges FLOAT,
    HospitalTier VARCHAR(255),
    CityTier VARCHAR(255),
    StateID VARCHAR(255)
);

-- Create the 'names' table 
CREATE TABLE names (
    CustomerID VARCHAR(20) PRIMARY KEY,
    last_name VARCHAR(50),
    salute VARCHAR(4),
    first_name VARCHAR(50)
);
-- Now load the Med Examination csv file from computer to Mysql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/Medical Examinations.csv' INTO TABLE medical_examinations
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
select * FROM medical_examinations;
-- Now load the Hospitalisation details csv file from computer to Mysql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/Hospitalisation details.csv' INTO TABLE hospitalisation
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT *FROM  hospitalisation;

-- Now load the names csv file from computer to Mysql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/Names.csv' INTO TABLE names
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT *FROM  names;
-- Join all tables on primary key
CREATE TABLE merged_data AS
SELECT names.CustomerID, -- Include other desired columns
       medical_examinations.BMI,
       medical_examinations.HBA1C,
       medical_examinations.HeartIssues,
       medical_examinations.Cancerhistory,
       medical_examinations.NumberOfMajorSurgeries,
       medical_examinations.smoker,
       hospitalisation.charges,
       hospitalisation.year,
       hospitalisation.children,
       hospitalisation.HospitalTier,
       hospitalisation.CityTier,
       hospitalisation.StateID
     
FROM healthcare_analysis.names
INNER JOIN medical_examinations ON names.CustomerID = medical_examinations.CustomerID
INNER JOIN hospitalisation ON names.CustomerID = hospitalisation.CustomerID;
-- Set primary key in the merged table
ALTER TABLE merged_data
ADD PRIMARY KEY (CustomerID); 
/* SELECT
    AVG(age) AS average_age,
    AVG(children) AS average_children,
    AVG(BMI) AS average_bmi,
    AVG(charges) AS average_hospitalization_costs
FROM joined_data  -- Replace with the name of your joined table
WHERE HeartIssues = 'yes'
  AND HBA1C > 6.5  -- Condition for identifying diabetic individuals
GROUP BY HeartIssues; 
*/
-- add fiels age
ALTER TABLE merged_data
ADD COLUMN age INT;  -- Add the new 'age' column

SET SQL_SAFE_UPDATES = 0; -- we have to set safe update off where you use set without where
-- Your UPDATE statement here
UPDATE merged_data
SET age = 2024 - year;
SET SQL_SAFE_UPDATES = 1;  -- Re-enable safe updates after your statement

-- Query to get diabetic data
SELECT
    AVG(age) AS average_age,
    AVG(children) AS average_children,
    AVG(BMI) AS average_bmi,
    AVG(charges) AS average_hospitalization_costs
FROM merged_data  -- my merged table
WHERE HeartIssues = 'yes'
  AND HBA1C > 6.5  -- Condition for identifying diabetic individuals
GROUP BY HeartIssues; 
-- Find the average hospitalization cost for each hospital tier and each city level
SELECT HospitalTier, CityTier, AVG(charges) AS average_hospitalization_cost
FROM hospitalisation
GROUP BY HospitalTier, CityTier;
-- Determine the number of people who have had major surgery with a history of cancer
SELECT COUNT(*) AS people_with_cancer_and_surgery
FROM medical_examinations
WHERE NumberOfMajorSurgeries <> 'No major surgery' -- Filter out 'No major surgery'
  AND CancerHistory = 'Yes'; 
  
  -- Determine the number of tier-1 hospitals in each state
SELECT StateID, COUNT(*) AS tier_1_hospital_count
FROM hospitalisation
WHERE HospitalTier = 'tier - 1' -- Specify the exact tier designation
GROUP BY StateID; 




