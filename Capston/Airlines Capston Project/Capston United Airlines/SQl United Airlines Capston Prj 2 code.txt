/* Question 1*/
SELECT DayOfWeek, COUNT(*) AS num_delayed_flights
FROM airline 
WHERE Delay = 1 -- Assuming  1 indicates a delayed flight
GROUP BY DayOfWeek;

/* Question No2:- Determine the number of delayed flights for various airlines */
SELECT Airline, COUNT(*) AS num_delayed_flights
FROM airline
WHERE Delay = 1
GROUP BY Airline;

/* Question No3:- Determine how many delayed flights land at airports with at least 10 runways */
-- create combined table
/* table created from python
CREATE TABLE flights (
	
  id_air int,
  Airline varchar(2),
  
  AirportFrom varchar(3),
  AirportTo varchar(3),
  DayOfWeek int,
  Time int,
  Length int,
  Delay int,
  Type varchar(15),
  elevation_ft_from int,
  iata_code_from varchar(3),
  length_ft_from int,
  width_ft_from int,
  lighted_from varchar(1),
  number_of_runways_from int,
  elevation_ft_to int,
  iata_code_to varchar(3),
  airport_ident varchar(4),
  length_ft_to int,
  width_ft_to int,
  lighted_to varchar(1),
  number_of_runways_to int
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.3/Uploads/df_output_air.csv' INTO TABLE flights
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/
SELECT COUNT(*) AS total_delayed_flights
FROM flights 
WHERE delay = 1 AND number_of_runways_from > 10;

/* 4.
Compare the number of delayed flights at airports higher than average elevation and those 
that are lower than average elevation for both source and destination airports */
-- Average elevation across all airports
SELECT AVG(elevation_ft) AS avg_elevation FROM airports; 
-- the avg elevation 1144 ft
SELECT COUNT(*) AS total_delayed_flights_greater_avg_elevation
FROM flights 
WHERE delay = 1 AND elevation_ft_from > 1144;

SELECT COUNT(*) AS total_delayed_flights_less_avg_elevation
FROM flights 
WHERE delay = 1 AND elevation_ft_from < 1144;
