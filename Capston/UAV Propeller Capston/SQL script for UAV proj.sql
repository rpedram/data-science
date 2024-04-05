create database prop_experiment; 
show schemas;
use prop_experiment;
-- create the structure of the table in the schema
-- Drop the tables if they already exist to avoid errors
DROP TABLE IF EXISTS experiment_1;
DROP TABLE IF EXISTS experiment_2;
DROP TABLE IF EXISTS experiment_3;

-- Create the tables
CREATE TABLE experiment_1 (
  Propeller_Name VARCHAR(255),
  Blade_Name VARCHAR(255),
  Propeller_Brand VARCHAR(255),
  Number_of_Blades INT,
  Propeller_Diameter DECIMAL(4,2),
  Propeller_Pitch DECIMAL(4,2),
  Advanced_Ratio_Input DECIMAL(5,3),
  RPM_Rotation_Input INT,
  Thrust_Coefficient_Output DECIMAL(5,3),
  Power_Coefficient_Output DECIMAL(5,3),
  Efficiency_Output DECIMAL(5,3)
);
CREATE TABLE experiment_2 (
  Propeller_Name VARCHAR(255),
  Blade_Name VARCHAR(255),
  Propeller_Brand VARCHAR(255),
  Number_of_Blades INT,
  Propeller_Diameter DECIMAL(4,2),
  Propeller_Pitch DECIMAL(4,2),
  Advanced_Ratio_Input DECIMAL(5,3),
  RPM_Rotation_Input INT,
  Thrust_Coefficient_Output DECIMAL(5,3),
  Power_Coefficient_Output DECIMAL(5,3),
  Efficiency_Output DECIMAL(5,3)
);
CREATE TABLE experiment_3 (
  Propeller_Name VARCHAR(255),
  Blade_Name VARCHAR(255),
  Propeller_Brand VARCHAR(255),
  Number_of_Blades INT,
  Propeller_Diameter DECIMAL(4,2),
  Propeller_Pitch DECIMAL(4,2),
  Advanced_Ratio_Input DECIMAL(5,3),
  RPM_Rotation_Input INT,
  Thrust_Coefficient_Output DECIMAL(5,3),
  Power_Coefficient_Output DECIMAL(5,3),
  Efficiency_Output DECIMAL(5,3)
);
select * FROM experiment_2;
-- Now load the emp record csv file from computer to Mysql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/experiment_vol1.csv' INTO TABLE experiment_1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
select * FROM experiment_1;
-- you can only upload csv from upload folder in MYSQL path C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/
SELECT COUNT(*) AS total_rows FROM experiment_1;
-- load experiment 2
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/experiment_vol2.csv' INTO TABLE experiment_2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- load experiment 3
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/experiment_vol3.csv' INTO TABLE experiment_3
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- check import is correct
SELECT COUNT(*) AS total_rows FROM experiment_2;
SELECT COUNT(*) AS total_rows FROM experiment_3;
-- Task 1 number of props in exp1 with thrust coeff >12 %
SELECT 
    COUNT(*) AS num_propellers
FROM
    experiment_1
WHERE
    Thrust_Coefficient_Output > 0.12; 
-- Task 2 in exp1 desc order by eff
SELECT * 
FROM experiment_1
ORDER BY Efficiency_Output DESC;
-- task 3 find 100 worst props in exp1 by power coeff
SELECT * 
FROM experiment_1
ORDER BY Power_Coefficient_Output ASC
LIMIT 100;
-- merger exp1,2 and three and find -ve and zero eff
-- I had weeded this data out of my panda as its incorrect and will affect model
/* We create a new table and make union with the existing table in insert it */
-- create a combined table
CREATE TABLE comb_experiments (
  Propeller_Name VARCHAR(255),
  Blade_Name VARCHAR(255),
  Propeller_Brand VARCHAR(255),
  Number_of_Blades INT,
  Propeller_Diameter DECIMAL(4,2),
  Propeller_Pitch DECIMAL(4,2),
  Advanced_Ratio_Input DECIMAL(5,3),
  RPM_Rotation_Input INT,
  Thrust_Coefficient_Output DECIMAL(5,3),
  Power_Coefficient_Output DECIMAL(5,3),
  Efficiency_Output DECIMAL(5,3)
);
INSERT INTO comb_experiments
SELECT * FROM experiment_1
UNION ALL
SELECT * FROM experiment_2
UNION ALL
SELECT * FROM experiment_3;

--  Count propellers with negative or zero efficiency
SELECT COUNT(*) AS num_inefficient_propellers
FROM comb_experiments
WHERE Efficiency_Output <= 0;


