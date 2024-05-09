-- creating tables

USE breakdowndb;

CREATE TABLE members (
	MemberID varchar(10),
    MemberFName varchar(20),
    MemberLName varchar(20),
    MemberLoc varchar(20)
);

CREATE TABLE vehicle (
	VehicleReg varchar(10),
    VehicleMake varchar(20),
    VehicleModel varchar(10),
    MemberID varchar(10)
);

CREATE TABLE engineer (
	EngineerID int,
    EngineerFName varchar(20),
    EngineerLName varchar(20)
);

CREATE TABLE breakdown (
	BreakdownID int,
    VehicleReg varchar(10),
    EngineerID int,
    BreakdownDATE date,
    BreakdownTIME time,
    BreakdownLoc varchar(20)
);


SELECT * FROM breakdown;

ALTER TABLE members
ADD PRIMARY KEY (MemberID);

ALTER TABLE vehicle
ADD PRIMARY KEY (VehicleReg);

ALTER TABLE engineer
ADD PRIMARY KEY (EngineerID);

ALTER TABLE breakdown
ADD PRIMARY KEY (BreakdownID);

ALTER TABLE vehicle
DROP COLUMN memberID;

ALTER TABLE vehicle
ADD COLUMN MemberID varchar(10);

ALTER TABLE vehicle
ADD FOREIGN KEY (MemberID) REFERENCES members(MemberID);

ALTER TABLE breakdown
ADD FOREIGN KEY (VehicleReg) REFERENCES vehicle(VehicleReg);

ALTER TABLE breakdown
ADD FOREIGN KEY (EngineerID) REFERENCES engineer(EngineerID);

INSERT INTO members VALUES (1, "Sam", "Smith", "London"),
							(2, "Alice", "W", "Oxford"),
                            (3, "J", "Kennedy", "Brighton"),
                            (4, "Kate", "Middleton", "London"),
                            (5, "Taylor", "Swift", "Canterbury");
                            

INSERT INTO vehicle (VehicleReg, VehicleMake, VehicleModel, MemberID)
VALUES ("AB24 CDE", "Audi", "A3", 5),
		("AB22 CDR", "Audi", "A4", 3),
        ("AB24 CFT", "BMW", "2 Series", 2),
        ("AB19 CHG", "BMW", "M2", 1),
        ("AB23 FYE", "Ford", "SUV", 1),
        ("AC17 KOE", "Ford", "Hatchback", 4),
		("AB22 JDE", "Honda", "SUV", 5),
		("AB11 GYL", "Honda", "Hatchback", 3);
        
DROP TABLE vehicle;

DELETE FROM vehicle;
        
INSERT INTO vehicle (MemberID)
VALUES ((SELECT memberID FROM members WHERE MemberFName = "Sam"));

SELECT * FROM vehicle;
		
                            
                            
INSERT INTO engineer 
VALUES (1, "Bob", "Marley"), 
		(2, "Jessica", "Alba"),
        (3, "Anthony", "Hopkins");
                            
SELECT * FROM engineer;

INSERT INTO breakdown 
VALUES (1, "AB24 CDE", 1, "2023-01-10", "11:01:00", "London"), 
		(2, "AB24 CFT", 3, "2022-05-27", "09:45:00", "London"),
        (3, "AB22 CDR", 1, "2024-05-22", "12:20:00", "London"),
        (4, "AB11 GYL", 2, "2022-03-20", "12:00:00", "London"),
        (5, "AB24 CFT", 2, "2023-08-15", "15:15:00", "London"),
        (6, "AB22 CDR", 1, "2022-02-02", "10:50:00", "London"),
        (7, "AB19 CHG", 2, "2024-05-22", "10:12:00", "London"),
        (8, "AB24 CDE", 3, "2023-10-20", "11:30:00", "London"),
        (9, "AB23 FYE", 1, "2023-11-25", "14:37:00", "London"),
        (10, "AC17 KOE", 2, "2024-01-15", "19:00:00", "London"),
        (11, "AB24 CFT", 3, "2024-05-01", "12:10:00", "London"),
        (12, "AB22 JDE", 3, "2023-11-12", "09:22:00", "London");
        
        
SELECT * FROM breakdown;

DELETE FROM breakdown;


-- query on the names of members who live in a location e.g. For example, London. 
SELECT MemberFName FROM members WHERE MemberLoc = "London";


-- query on all cars registered with the company Audi. 
SELECT VehicleModel FROM vehicle WHERE VehicleMake = "Audi";


-- query on the number of engineers that work for the company. 
SELECT EngineerID FROM engineer;


-- query on the number of members registered. 
SELECT MemberID FROM members;


-- query on all the breakdown after a particular date 
SELECT * FROM breakdown WHERE BreakdownDATE >= "2023-08-15";


-- query on all the breakdown between 2 dates 
SELECT * FROM breakdown WHERE BreakdownDATE >= "2023-08-15" AND BreakdownDATE <= "2024-01-15";


-- query on the number of time a particular vehicle has broken down 
SELECT VehicleReg FROM breakdown;


-- query on the number of vehicles broken down more than once 
SELECT VehicleReg, COUNT(*)
FROM breakdown
GROUP BY VehicleReg
HAVING COUNT(*) > 1;


-- query on all the vehicles a member owns
SELECT MemberFName, VehicleMake FROM members, vehicle WHERE members.MemberID = 2 AND vehicle.MemberID = 2;

-- or

SELECT MemberFName, VehicleMake
FROM members
INNER JOIN vehicle ON members.MemberID = vehicle.MemberID
WHERE members.MemberID = 2;


-- query on the number of vehicles each member has – sort the data based on the number of cars from highest to lowest
SELECT MemberFName, COUNT(VehicleMake)
FROM members
INNER JOIN vehicle ON members.MemberID = vehicle.MemberID
GROUP BY members.MemberID
ORDER BY COUNT(VehicleMake) DESC;


-- query on all vehicles that have broken down in a particular location along with member details. 
SELECT members.*, vehicle.VehicleMake, breakdown.BreakdownLoc
FROM members
INNER JOIN vehicle ON members.MemberID = vehicle.MemberID
INNER JOIN breakdown ON vehicle.VehicleReg = breakdown.vehicleReg;


-- query on a list of all breakdowns along with member and engineer details between two dates.
-- use of BETWEEN query 
SELECT members.*, engineer.*, breakdown.*
FROM members
INNER JOIN vehicle ON members.MemberID = vehicle.MemberID
INNER JOIN breakdown ON vehicle.VehicleReg = breakdown.vehicleReg
INNER JOIN engineer ON breakdown.EngineerID = engineer.EngineerID
WHERE BreakdownDATE BETWEEN "2023-08-15" AND "2024-01-15";


-- CROSS JOIN query
SELECT MemberFName, vehicle.*
FROM members
CROSS JOIN vehicle
WHERE members.MemberID = vehicle.MemberID;


-- EXISTS query
SELECT MemberFName, VehicleMake, BreakdownDATE
FROM members
INNER JOIN vehicle ON members.MemberID = vehicle.MemberID
INNER JOIN breakdown ON vehicle.VehicleReg = breakdown.vehicleReg
WHERE EXISTS(SELECT BreakdownID FROM breakdown WHERE BreakdownDATE BETWEEN  "2023-08-15" AND "2024-01-15");


-- ANY query
SELECT MemberFName
FROM members
WHERE MemberID = ANY
	(SELECT MemberID
    FROM vehicle
    WHERE VehicleMake = "BMW");
    
    
-- Create a stored procedure which will display the following: If a member has more than one vehicle, then display ‘multi-car policy’ otherwise it should be ‘Single-car-policy’. 
SELECT MemberFName, COUNT(VehicleMake),
	CASE COUNT(VehicleMake)
		WHEN 1 THEN 'single-car policy'
		WHEN 2 THEN 'multi-car policy'
    END AS 'policy'
FROM members
INNER JOIN vehicle ON members.MemberID = vehicle.MemberID
GROUP BY MemberFName;
    

