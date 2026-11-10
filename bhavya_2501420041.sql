CREATE DATABASE FlightReservationDB;
USE FlightReservationDB;
CREATE TABLE Airports (
    airport_id INT PRIMARY KEY AUTO_INCREMENT,
    airport_code VARCHAR(10) UNIQUE NOT NULL,
    airport_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(20) UNIQUE NOT NULL,
    source INT NOT NULL,
    destination INT NOT NULL,
    departure_datetime DATETIME NOT NULL,
    arrival_datetime DATETIME NOT NULL,
    total_capacity INT NOT NULL,
    flight_status ENUM('Scheduled', 'Delayed', 'Cancelled', 'Completed')
        DEFAULT 'Scheduled',

    FOREIGN KEY (source) REFERENCES Airports(airport_id),
    FOREIGN KEY (destination) REFERENCES Airports(airport_id),

    CHECK (total_capacity > 0),
    CHECK (source <> destination)
);
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    loyalty_tier ENUM('Silver', 'Gold', 'Platinum')
        DEFAULT 'Silver'
);
CREATE TABLE Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT NOT NULL,
    seat_no VARCHAR(10) NOT NULL,
    fare_class ENUM('Economy', 'Business', 'First')
        DEFAULT 'Economy',

    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    UNIQUE (flight_id, seat_no)
);
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    seat_no VARCHAR(10),
    booking_status ENUM(
        'Confirmed',
        'Waitlisted',
        'Cancelled',
        'Offloaded'
    ) DEFAULT 'Confirmed',

    booking_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('Paid', 'Pending', 'Refunded'),

    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
INSERT INTO Airports
(airport_code, airport_name, city, country)
VALUES
('DEL', 'Indira Gandhi International Airport', 'Delhi', 'India'),
('BOM', 'Chhatrapati Shivaji Airport', 'Mumbai', 'India'),
('BLR', 'Kempegowda International Airport', 'Bangalore', 'India'),
('HYD', 'Rajiv Gandhi International Airport', 'Hyderabad', 'India'),
('MAA', 'Chennai International Airport', 'Chennai', 'India');
INSERT INTO Flights
(flight_number, source, destination,
 departure_datetime, arrival_datetime, total_capacity)
VALUES
('AI101', 1, 2, '2026-11-15 08:00:00',
 '2026-11-15 10:15:00', 3),

('AI202', 1, 3, '2026-11-15 12:00:00',
 '2026-11-15 14:30:00', 5),

('AI303', 2, 3, '2026-11-16 09:00:00',
 '2026-11-16 11:00:00', 4),

('AI404', 3, 4, '2026-11-17 15:00:00',
 '2026-11-17 16:30:00', 3);
 INSERT INTO Passengers
(passenger_name, email, phone, loyalty_tier)
VALUES
('Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Platinum'),
('Aman Verma', 'aman@gmail.com', '9876543211', 'Gold'),
('Priya Singh', 'priya@gmail.com', '9876543212', 'Silver'),
('Neha Gupta', 'neha@gmail.com', '9876543213', 'Platinum'),
('Rohit Kumar', 'rohit@gmail.com', '9876543214', 'Gold'),
('Anjali Mehta', 'anjali@gmail.com', '9876543215', 'Silver'),
('Karan Malhotra', 'karan@gmail.com', '9876543216', 'Gold'),
('Simran Kaur', 'simran@gmail.com', '9876543217', 'Platinum');
INSERT INTO Seats (flight_id, seat_no, fare_class)
VALUES
(1, '1A', 'Business'),
(1, '1B', 'Business'),
(1, '2A', 'Economy'),
(2, '1A', 'Business'),
(2, '1B', 'Business'),
(2, '2A', 'Economy'),
(2, '2B', 'Economy'),
(2, '2C', 'Economy'),
(3, '1A', 'Business'),
(3, '2A', 'Economy'),
(3, '2B', 'Economy'),
(3, '2C', 'Economy'),
(4, '1A', 'Business'),
(4, '2A', 'Economy'),
(4, '2B', 'Economy');
INSERT INTO Bookings
(passenger_id, flight_id, seat_no, booking_status,
 booking_timestamp)
VALUES
(1, 1, '1A', 'Confirmed', '2026-11-01 09:00:00'),
(2, 1, '1B', 'Confirmed', '2026-11-02 10:00:00'),
(3, 1, '2A', 'Confirmed', '2026-11-03 11:00:00'),
(4, 1, NULL, 'Waitlisted', '2026-11-04 12:00:00'),
(5, 1, NULL, 'Waitlisted', '2026-11-05 13:00:00'),

(6, 2, '1A', 'Confirmed', '2026-11-02 10:00:00'),
(7, 2, '1B', 'Confirmed', '2026-11-03 11:00:00'),
(8, 2, '2A', 'Confirmed', '2026-11-04 12:00:00');
INSERT INTO Payments
(booking_id, amount, payment_status)
VALUES
(1, 15000, 'Paid'),
(2, 12000, 'Paid'),
(3, 5000, 'Paid'),
(4, 15000, 'Pending'),
(5, 5000, 'Pending'),
(6, 10000, 'Paid'),
(7, 8000, 'Paid'),
(8, 5000, 'Paid');
SELECT * FROM Airports;
SELECT * FROM Flights;
SELECT * FROM Passengers;
SELECT * FROM Seats;
SELECT * FROM Bookings;
SELECT * FROM Payments;
SELECT
    f.flight_number,
    a1.city AS source_city,
    a2.city AS destination_city,
    f.departure_datetime,
    f.arrival_datetime,
    f.total_capacity
FROM Flights f
JOIN Airports a1 ON f.source = a1.airport_id
JOIN Airports a2 ON f.destination = a2.airport_id
WHERE f.flight_status = 'Scheduled';
SELECT
    f.flight_number,
    f.total_capacity,
    COUNT(b.booking_id) AS seats_booked,
    f.total_capacity - COUNT(b.booking_id) AS seats_available
FROM Flights f
LEFT JOIN Bookings b
    ON f.flight_id = b.flight_id
    AND b.booking_status = 'Confirmed'
WHERE f.flight_id = 1
GROUP BY f.flight_id, f.flight_number, f.total_capacity;
SELECT
    f.flight_number,
    a1.city AS source,
    a2.city AS destination,
    f.departure_datetime
FROM Flights f
JOIN Airports a1 ON f.source = a1.airport_id
JOIN Airports a2 ON f.destination = a2.airport_id
WHERE a1.city = 'Delhi'
AND a2.city = 'Mumbai'
AND DATE(f.departure_datetime) = '2026-11-15'
AND f.flight_status = 'Scheduled';
SELECT
    b.booking_id,
    p.passenger_name,
    f.flight_number,
    b.seat_no,
    b.booking_status
FROM Bookings b
JOIN Passengers p
    ON b.passenger_id = p.passenger_id
JOIN Flights f
    ON b.flight_id = f.flight_id;
    UPDATE Bookings
SET booking_status = 'Cancelled',
    seat_no = NULL
WHERE booking_id = 3;
SELECT
    b.booking_id,
    p.passenger_name,
    f.flight_number,
    p.loyalty_tier,
    b.booking_status
FROM Bookings b
JOIN Passengers p
    ON b.passenger_id = p.passenger_id
JOIN Flights f
    ON b.flight_id = f.flight_id
WHERE b.booking_status = 'Waitlisted';
SELECT
    f.flight_id,
    f.flight_number,
    f.total_capacity,
    COUNT(b.booking_id) AS confirmed_bookings
FROM Flights f
JOIN Bookings b
    ON f.flight_id = b.flight_id
WHERE b.booking_status = 'Confirmed'
GROUP BY f.flight_id, f.flight_number, f.total_capacity
HAVING COUNT(b.booking_id) > f.total_capacity;
SELECT
    b.booking_id,
    p.passenger_name,
    p.loyalty_tier,
    s.fare_class,
    b.booking_timestamp,

    CASE p.loyalty_tier
        WHEN 'Platinum' THEN 1
        WHEN 'Gold' THEN 2
        WHEN 'Silver' THEN 3
    END AS loyalty_priority,

    CASE s.fare_class
        WHEN 'First' THEN 1
        WHEN 'Business' THEN 2
        WHEN 'Economy' THEN 3
    END AS fare_priority

FROM Bookings b
JOIN Passengers p
    ON b.passenger_id = p.passenger_id
LEFT JOIN Seats s
    ON b.flight_id = s.flight_id
    AND b.seat_no = s.seat_no
WHERE b.flight_id = 1
AND b.booking_status = 'Confirmed'
ORDER BY
    loyalty_priority,
    fare_priority,
    b.booking_timestamp;
    UPDATE Bookings
SET booking_status = 'Confirmed'
WHERE booking_id IN (4, 5);
WITH PassengerPriority AS (
    SELECT
        b.booking_id,
        p.passenger_name,
        p.loyalty_tier,
        COALESCE(s.fare_class, 'Economy') AS fare_class,
        b.booking_timestamp,

        ROW_NUMBER() OVER (
            PARTITION BY b.flight_id
            ORDER BY
                CASE p.loyalty_tier
                    WHEN 'Platinum' THEN 1
                    WHEN 'Gold' THEN 2
                    WHEN 'Silver' THEN 3
                END,
                CASE COALESCE(s.fare_class, 'Economy')
                    WHEN 'First' THEN 1
                    WHEN 'Business' THEN 2
                    WHEN 'Economy' THEN 3
                END,
                b.booking_timestamp
        ) AS priority_rank,

        f.total_capacity

    FROM Bookings b
    JOIN Passengers p
        ON b.passenger_id = p.passenger_id
    JOIN Flights f
        ON b.flight_id = f.flight_id
    LEFT JOIN Seats s
        ON b.flight_id = s.flight_id
        AND b.seat_no = s.seat_no

    WHERE b.flight_id = 1
      AND b.booking_status = 'Confirmed'
)

SELECT
    booking_id,
    passenger_name,
    loyalty_tier,
    fare_class,
    priority_rank,
    CASE
        WHEN priority_rank <= total_capacity
            THEN 'Keep Confirmed'
        ELSE 'Offload'
    END AS final_decision
FROM PassengerPriority
ORDER BY priority_rank;
SELECT
    b.booking_id,
    p.passenger_name,
    p.loyalty_tier,
    COALESCE(s.fare_class, 'Economy') AS fare_class,

    RANK() OVER (
        PARTITION BY b.flight_id
        ORDER BY
            CASE p.loyalty_tier
                WHEN 'Platinum' THEN 1
                WHEN 'Gold' THEN 2
                WHEN 'Silver' THEN 3
            END,
            CASE COALESCE(s.fare_class, 'Economy')
                WHEN 'First' THEN 1
                WHEN 'Business' THEN 2
                WHEN 'Economy' THEN 3
            END
    ) AS passenger_rank

FROM Bookings b
JOIN Passengers p
    ON b.passenger_id = p.passenger_id
LEFT JOIN Seats s
    ON b.flight_id = s.flight_id
    AND b.seat_no = s.seat_no
WHERE b.flight_id = 1
AND b.booking_status = 'Confirmed';
EXPLAIN
SELECT *
FROM Flights
WHERE source = 1
AND destination = 2
AND departure_datetime >= '2026-11-15 00:00:00'
AND departure_datetime < '2026-11-16 00:00:00';
CREATE INDEX idx_flight_search
ON Flights(source, destination, departure_datetime);
EXPLAIN
SELECT *
FROM Flights
WHERE source = 1
AND destination = 2
AND departure_datetime >= '2026-11-15 00:00:00'
AND departure_datetime < '2026-11-16 00:00:00';
CREATE INDEX idx_booking_lookup
ON Bookings(flight_id, seat_no, booking_status);
EXPLAIN
SELECT *
FROM Bookings
WHERE flight_id = 1
AND seat_no = '1A'
AND booking_status = 'Confirmed';
EXPLAIN
SELECT *
FROM Bookings
WHERE flight_id = 1
AND seat_no = '1A'
AND booking_status = 'Confirmed';
CREATE VIEW Flight_Seat_Availability AS
SELECT
    f.flight_id,
    f.flight_number,
    f.total_capacity,

    COUNT(
        CASE
            WHEN b.booking_status = 'Confirmed'
            THEN b.booking_id
        END
    ) AS seats_booked,

    f.total_capacity -
    COUNT(
        CASE
            WHEN b.booking_status = 'Confirmed'
            THEN b.booking_id
        END
    ) AS seats_available,

    ROUND(
        COUNT(
            CASE
                WHEN b.booking_status = 'Confirmed'
                THEN b.booking_id
            END
        ) * 100.0 / f.total_capacity,
        2
    ) AS occupancy_percentage

FROM Flights f
LEFT JOIN Bookings b
    ON f.flight_id = b.flight_id

GROUP BY
    f.flight_id,
    f.flight_number,
    f.total_capacity;
    SELECT * FROM Flight_Seat_Availability;
    CREATE VIEW Waitlisted_Overbooked_Passengers AS

SELECT
    b.booking_id,
    p.passenger_name,
    f.flight_number,
    p.loyalty_tier,
    b.booking_status,
    b.booking_timestamp

FROM Bookings b
JOIN Passengers p
    ON b.passenger_id = p.passenger_id
JOIN Flights f
    ON b.flight_id = f.flight_id

WHERE
    b.booking_status = 'Waitlisted'

    OR (
        b.booking_status = 'Confirmed'
        AND (
            SELECT COUNT(*)
            FROM Bookings b2
            WHERE b2.flight_id = b.flight_id
            AND b2.booking_status = 'Confirmed'
        ) > f.total_capacity
    );
    SELECT *
FROM Waitlisted_Overbooked_Passengers
ORDER BY
    CASE loyalty_tier
        WHEN 'Platinum' THEN 1
        WHEN 'Gold' THEN 2
        WHEN 'Silver' THEN 3
    END,
    booking_timestamp;
    CREATE VIEW Confirmed_Bookings AS
SELECT
    booking_id,
    passenger_id,
    flight_id,
    seat_no,
    booking_status
FROM Bookings
WHERE booking_status = 'Confirmed'
WITH CHECK OPTION;
SELECT * FROM Confirmed_Bookings;
UPDATE Payments SET payment_date = '2026-11-01 10:00:00'
WHERE payment_id = 1;

UPDATE Payments SET payment_date = '2026-11-02 11:00:00'
WHERE payment_id = 2;

UPDATE Payments SET payment_date = '2026-11-03 12:00:00'
WHERE payment_id = 3;

UPDATE Payments SET payment_date = '2026-11-04 13:00:00'
WHERE payment_id = 6;

UPDATE Payments SET payment_date = '2026-11-05 14:00:00'
WHERE payment_id = 7;

UPDATE Payments SET payment_date = '2026-11-06 15:00:00'
WHERE payment_id = 8;
SELECT
    a1.city AS source_city,
    a2.city AS destination_city,
    DATE(p.payment_date) AS booking_date,
    SUM(p.amount) AS daily_revenue

FROM Payments p
JOIN Bookings b
    ON p.booking_id = b.booking_id
JOIN Flights f
    ON b.flight_id = f.flight_id
JOIN Airports a1
    ON f.source = a1.airport_id
JOIN Airports a2
    ON f.destination = a2.airport_id

WHERE p.payment_status = 'Paid'
AND b.booking_status = 'Confirmed'

GROUP BY
    a1.city,
    a2.city,
    DATE(p.payment_date)

ORDER BY booking_date;
WITH DailyRevenue AS (
    SELECT
        a1.city AS source_city,
        a2.city AS destination_city,
        DATE(p.payment_date) AS revenue_date,
        SUM(p.amount) AS daily_revenue

    FROM Payments p
    JOIN Bookings b
        ON p.booking_id = b.booking_id
    JOIN Flights f
        ON b.flight_id = f.flight_id
    JOIN Airports a1
        ON f.source = a1.airport_id
    JOIN Airports a2
        ON f.destination = a2.airport_id

    WHERE p.payment_status = 'Paid'
    AND b.booking_status = 'Confirmed'

    GROUP BY
        a1.city,
        a2.city,
        DATE(p.payment_date)
)

SELECT
    source_city,
    destination_city,
    revenue_date,
    daily_revenue,

    SUM(daily_revenue) OVER (
        PARTITION BY source_city, destination_city
        ORDER BY revenue_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue

FROM DailyRevenue
ORDER BY source_city, destination_city, revenue_date;
WITH DailyBookings AS (
    SELECT
        f.source,
        f.destination,
        DATE(b.booking_timestamp) AS booking_date,
        COUNT(*) AS total_bookings

    FROM Bookings b
    JOIN Flights f
        ON b.flight_id = f.flight_id

    WHERE b.booking_status IN ('Confirmed', 'Waitlisted')

    GROUP BY
        f.source,
        f.destination,
        DATE(b.booking_timestamp)
)

SELECT
    a1.city AS source_city,
    a2.city AS destination_city,
    booking_date,
    total_bookings,

    LAG(total_bookings) OVER (
        PARTITION BY source, destination
        ORDER BY booking_date
    ) AS previous_day_bookings,

    total_bookings -
    LAG(total_bookings) OVER (
        PARTITION BY source, destination
        ORDER BY booking_date
    ) AS booking_difference

FROM DailyBookings d
JOIN Airports a1
    ON d.source = a1.airport_id
JOIN Airports a2
    ON d.destination = a2.airport_id

ORDER BY source_city, destination_city, booking_date;
SHOW TABLES;

SELECT * FROM Airports;

SELECT * FROM Flights;

SELECT * FROM Passengers;

SELECT * FROM Seats;

SELECT * FROM Bookings;

SELECT * FROM Payments;

SELECT * FROM Flight_Seat_Availability;

SELECT * FROM Waitlisted_Overbooked_Passengers;

SELECT * FROM Confirmed_Bookings;