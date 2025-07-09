-- Part 1: Create Tables

CREATE TABLE Guide (
    guide_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    certification_yr INT CHECK (certification_yr > 2010)
);

CREATE TABLE Adventure (
    adventure_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    price DECIMAL(6,2) CHECK (price >= 20 AND price <= 500),
    type VARCHAR(20) CHECK (type IN ('Hiking', 'Rafting', 'Skiing')),
    guide_id INT,
    FOREIGN KEY (guide_id) REFERENCES Guide(guide_id) ON DELETE CASCADE,
    UNIQUE (name, location, date),
    UNIQUE (adventure_id, guide_id, date)
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    customer_id INT,
    adventure_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE,
    FOREIGN KEY (adventure_id) REFERENCES Adventure(adventure_id),
    UNIQUE (customer_id, adventure_id)
);

-- Part 2: Insert Data

-- Guides
INSERT INTO Guide VALUES (1, 'Maya Rivers', 2012);
INSERT INTO Guide VALUES (2, 'Elijah Peak', 2014);
INSERT INTO Guide VALUES (3, 'Sierra Trail', 2016);
INSERT INTO Guide VALUES (4, 'Logan Snow', 2015);  
INSERT INTO Guide VALUES (5, 'Ava Cliff', 2021);

-- Customers
INSERT INTO Customer VALUES (201, 'Nina Lake', 'nina@gmail.com');
INSERT INTO Customer VALUES (202, 'Owen Ridge', 'owen@yahoo.com');
INSERT INTO Customer VALUES (203, 'Emma Stone', 'emma@gmail.com');
INSERT INTO Customer VALUES (204, 'Liam Boulder', 'liam@msudenver.edu');

-- Adventures
INSERT INTO Adventure VALUES (101, 'Estes Trek', 'Estes Park', '2024-07-12', 150.00, 'Hiking', 1);
INSERT INTO Adventure VALUES (102, 'Aspen Raft', 'Aspen', '2024-07-14', 200.00, 'Rafting', 2);
INSERT INTO Adventure VALUES (103, 'Garden Hike', 'Garden of the Gods', '2024-08-01', 90.00, 'Hiking', 3);
INSERT INTO Adventure VALUES (104, 'Snowy Run', 'Aspen', '2024-12-20', 180.00, 'Skiing', 4);  -- Will be cascaded
INSERT INTO Adventure VALUES (105, 'Eagle Ridge', 'Eagle', '2024-09-05', 120.00, 'Hiking', 1);
INSERT INTO Adventure VALUES (106, 'Sky Slide', 'Vail', '2024-12-25', 220.00, 'Skiing', 5);

-- Constraint Violations 
-- INSERT INTO Adventure VALUES (107, 'Too Cheap', 'Boulder', '2024-08-01', 10.00, 'Hiking', 1); -- Fails: price < 20
-- INSERT INTO Adventure VALUES (108, 'Sky Dive', 'Vail', '2024-09-12', 250.00, 'Skydiving', 2); -- Fails: type invalid

-- Bookings
INSERT INTO Booking VALUES (301, 201, 101);
INSERT INTO Booking VALUES (302, 202, 102);
INSERT INTO Booking VALUES (303, 201, 103);
INSERT INTO Booking VALUES (304, 203, 104);
INSERT INTO Booking VALUES (305, 204, 105);
INSERT INTO Booking VALUES (306, 202, 106);
INSERT INTO Booking VALUES (307, 203, 101);

-- Remove any Booking tied to adventure 104 
DELETE FROM Booking WHERE adventure_id = 104;

-- Part 3: SQL Tasks

-- 1. All adventures in Aspen under $300
SELECT * FROM Adventure
WHERE location = 'Aspen' AND price < 300;

-- 2. Bookings for customers with Gmail
SELECT B.*
FROM Booking B
JOIN Customer C ON B.customer_id = C.customer_id
WHERE C.email LIKE '%@gmail.com';

-- 3. Adventures led by guides certified after 2015
SELECT A.*
FROM Adventure A
JOIN Guide G ON A.guide_id = G.guide_id
WHERE G.certification_yr > 2015;

-- 4. Count of adventures per guide
SELECT guide_id, COUNT(*) AS total_adventures
FROM Adventure
GROUP BY guide_id;

-- 5. Update price of an adventure
UPDATE Adventure
SET price = 350.00
WHERE adventure_id = 103;

-- 6. Delete a guide (Guide 4) and trigger ON DELETE CASCADE
DELETE FROM Guide WHERE guide_id = 4;

-- 7. Verify adventure deletion (Adventure 104 should be gone)
SELECT * FROM Adventure;

-- 8. Add and drop a CHECK constraint
ALTER TABLE Adventure
ADD CONSTRAINT chk_type CHECK (type IN ('Hiking', 'Rafting', 'Skiing'));

-- Optional: Drop the CHECK constraint afterwards
ALTER TABLE Adventure DROP CHECK chk_type;
