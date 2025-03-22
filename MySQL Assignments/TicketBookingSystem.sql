#TASK 1

create database TicketBookingSystem;
use TicketBookingSystem;
CREATE TABLE Venue (
    venue_id INT PRIMARY KEY AUTO_INCREMENT,
    venue_name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE Event (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(255) NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME NOT NULL,
    venue_id INT NOT NULL,
    total_seats INT CHECK(total_seats > 0),
    available_seats INT CHECK(available_seats >= 0),
    ticket_price DECIMAL(10,2) CHECK(ticket_price >= 0),
    event_type ENUM('Movie', 'Sports', 'Concert') NOT NULL,
    FOREIGN KEY (venue_id) REFERENCES Venue(venue_id) ON DELETE CASCADE
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL
    
    
);


CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    event_id INT NOT NULL,
    num_tickets INT CHECK(num_tickets > 0),
    total_cost DECIMAL(10,2) NOT NULL,
    booking_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE CASCADE
);

#TASK 2

/*Write a SQL query to insert at least 10 sample records into each table.*/
INSERT INTO Venue (venue_name, address) VALUES
('Madison Square Garden', 'New York, USA'),
('Wembley Stadium', 'London, UK'),
('Sydney Opera House', 'Sydney, Australia'),
('Tokyo Dome', 'Tokyo, Japan'),
('National Stadium', 'Delhi, India'),
('Staples Center', 'Los Angeles, USA'),
('Maracanã', 'Rio de Janeiro, Brazil'),
('O2 Arena', 'London, UK'),
('Circuit of the Americas', 'Austin, USA'),
('Etihad Arena', 'Abu Dhabi, UAE');


INSERT INTO Event (event_name, event_date, event_time, venue_id, total_seats, available_seats, ticket_price, event_type) VALUES
('Rock Concert', '2025-04-10', '19:30:00', 1, 20000, 15000, 1500, 'Concert'),
('Champions Cup', '2025-06-15', '18:00:00', 2, 80000, 50000, 2500, 'Sports'),
('Broadway Show', '2025-05-01', '20:00:00', 3, 3000, 2000, 2000, 'Movie'),
('Tokyo Tech Expo', '2025-07-20', '10:00:00', 4, 10000, 7000, 1800, 'Movie'),
('IPL Final', '2025-04-29', '19:00:00', 5, 60000, 40000, 2200, 'Sports'),
('NBA Finals', '2025-06-10', '20:30:00', 6, 25000, 5000, 3000, 'Sports'),
('World Cup Final', '2025-12-18', '20:00:00', 7, 90000, 45000, 5000, 'Sports'),
('Music Festival', '2025-08-15', '17:00:00', 8, 50000, 35000, 1800, 'Concert'),
('Formula 1 GP', '2025-11-07', '15:00:00', 9, 200000, 150000, 3000, 'Sports'),
('WWE SmackDown', '2025-10-25', '19:00:00', 10, 15000, 10000, 1200, 'Sports');

INSERT INTO Customer (customer_name, email, phone_number) VALUES
('Harini', 'hari@example.com', '9876543210'),
('Vignesh', 'vignesh@example.com', '8765432109'),
('Dhanya', 'dhanya@example.com', '7654321098'),
('Anjana', 'anjana@example.com', '6543210987'),
('Arthi', 'arthi@example.com', '5432109876'),
('Akshaya', 'akshaya@example.com', '4321098765'),
('Divya', 'divya@example.com', '3210987654'),
('Gayathri', 'gayathri@example.com', '2109876543'),
('John', 'john@example.com', '1098765432'),
('Alice', 'alice@example.com', '9988776655');


INSERT INTO Booking (customer_id, event_id, num_tickets, total_cost) VALUES
(1, 1, 2, 3000),
(2, 2, 5, 12500),
(3, 3, 1, 2000),
(4, 4, 4, 7200),
(5, 5, 3, 6600),
(6, 6, 2, 6000),
(7, 7, 6, 30000),
(8, 8, 2, 3600),
(9, 9, 4, 12000),
(10, 10, 3, 3600);

/*Write a SQL query to list all Events. */
SELECT * FROM Event;

/*Write a SQL query to select events with available tickets*/ 
SELECT * FROM Event WHERE available_seats>0;

/*Write a SQL query to select events name partial match with ‘cup’*/
SELECT * FROM Event WHERE event_name LIKE '%Cup%';

/*Write a SQL query to select events with ticket price range 
is between 1000 to 2500*/
SELECT * FROM Event WHERE ticket_price BETWEEN 1000 AND 2500;

/*Write a SQL query to retrieve events with dates falling within a specific range.*/
SELECT * FROM Event WHERE event_date BETWEEN '2025-04-01' AND '2025-06-30';

/*Write a SQL query to retrieve events with available tickets that also have "Concert" in their 
name.*/
SELECT * FROM Event WHERE available_seats > 0 AND event_name LIKE '%Concert%';

/*Write a SQL query to retrieve users in batches of 5, starting from the 6th user. */
SELECT * FROM Customer LIMIT 5 OFFSET 5;

/*Write a SQL query to retrieve bookings details contains booked no of ticket more than 4.*/
SELECT * FROM Booking WHERE num_tickets > 4;

/*Write a SQL query to retrieve customer information whose phone number end with ‘000’*/
SELECT * FROM Customer WHERE phone_number LIKE '%000';

/*Write a SQL query to retrieve the events in order whose seat capacity more than 15000.*/
SELECT * FROM Event WHERE total_seats > 15000 ORDER BY total_seats DESC;

/* Write a SQL query to select events name not start with ‘x’, ‘y’, ‘z’ */
SELECT * FROM Event WHERE event_name NOT LIKE 'X%' AND event_name NOT LIKE 'Y%' AND event_name NOT LIKE 'Z%';

#TASK 3

/* List Events and Their Average Ticket Prices*/
SELECT event_type, AVG(ticket_price) AS avg_ticket_price FROM Event GROUP BY event_type;

/*Calculate the Total Revenue Generated by Events*/
SELECT e.event_name, SUM(b.total_cost) AS total_revenue FROM Booking b
JOIN Event e ON b.event_id = e.event_id GROUP BY e.event_name;

/* Find the Event with the Highest Ticket Sales*/
SELECT e.event_name, SUM(b.num_tickets) AS total_tickets_sold
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_name
ORDER BY total_tickets_sold DESC
LIMIT 1;

/*Calculate the Total Number of Tickets Sold for Each Even*/
SELECT e.event_name, SUM(b.num_tickets) AS total_tickets_sold
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_name;

/*Find Events with No Ticket Sales*/
SELECT e.event_name
FROM Event e
LEFT JOIN Booking b ON e.event_id = b.event_id
WHERE b.booking_id IS NULL;

/*Find the User Who Has Booked the Most Tickets*/
SELECT c.customer_name, SUM(b.num_tickets) AS total_tickets
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_tickets DESC
LIMIT 1;

/*List Events and the Total Number of Tickets Sold for Each Month*/
SELECT MONTHNAME(b.booking_date) AS month, e.event_name, SUM(b.num_tickets) AS total_tickets
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY month, e.event_name
ORDER BY month;

/*Calculate the Average Ticket Price for Events in Each Venue*/
SELECT v.venue_name, AVG(e.ticket_price) AS avg_ticket_price
FROM Event e
JOIN Venue v ON e.venue_id = v.venue_id
GROUP BY v.venue_name;

/* Calculate the Total Number of Tickets Sold for Each Event Type*/
SELECT e.event_type, SUM(b.num_tickets) AS total_tickets_sold
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_type;

/*Calculate the Total Revenue Generated by Events in Each Year*/
SELECT YEAR(e.event_date) AS event_year, SUM(b.total_cost) AS total_revenue
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY event_year
ORDER BY event_year;

/* List Users Who Have Booked Tickets for Multiple Events*/
SELECT c.customer_name, COUNT(DISTINCT b.event_id) AS event_count
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING event_count > 1;

/* Calculate the Total Revenue Generated by Events for Each User*/
SELECT c.customer_name, SUM(b.total_cost) AS total_spent
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

/*Calculate the Average Ticket Price for Events in Each Category and Venue*/
SELECT e.event_type, v.venue_name, AVG(e.ticket_price) AS avg_ticket_price
FROM Event e
JOIN Venue v ON e.venue_id = v.venue_id
GROUP BY e.event_type, v.venue_name;

/*List Users and the Total Number of Tickets They've Purchased in the Last 30 Days*/
SELECT c.customer_name, SUM(b.num_tickets) AS total_tickets
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
WHERE b.booking_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY c.customer_name;

#TASK 4

/*Calculate the Average Ticket Price for Events in Each Venue Using a Subquery.*/
SELECT venue_id, 
       (SELECT AVG(ticket_price) FROM Event e WHERE e.venue_id = v.venue_id) AS avg_ticket_price
FROM Venue v;

/*Find Events with More Than 50% of Tickets Sold Using a Subquery*/
SELECT * FROM Event 
WHERE total_seats / 2 < (SELECT SUM(num_tickets) FROM Booking WHERE Booking.event_id = Event.event_id);

/*Calculate the Total Number of Tickets Sold for Each Event */
SELECT event_id, 
       (SELECT SUM(num_tickets) FROM Booking WHERE Booking.event_id = Event.event_id) AS total_tickets_sold
FROM Event;

/* Find Users Who Have Not Booked Any Tickets Using a NOT EXISTS Subquery*/
SELECT * FROM Customer c
WHERE NOT EXISTS (SELECT 1 FROM Booking b WHERE b.customer_id = c.customer_id);

/*List Events with No Ticket Sales Using a NOT IN Subquery*/
SELECT * FROM Event WHERE event_id NOT IN (SELECT event_id FROM Booking);

/*Calculate the Total Number of Tickets Sold for Each Event Type Using a Subquery in the FROM Clause*/
SELECT e.event_type, SUM(b.num_tickets) AS total_tickets_sold
FROM (SELECT event_id, num_tickets FROM Booking) b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_type;

/*Find Events with Ticket Prices Higher Than the Average Ticket Price Using a Subquery in the WHERE Clause*/
SELECT * FROM Event WHERE ticket_price > (SELECT AVG(ticket_price) FROM Event);

/*Calculate the Total Revenue Generated by Events for Each User Using a Correlated Subquery*/
SELECT c.customer_id, c.customer_name, 
       (SELECT SUM(b.total_cost) FROM Booking b WHERE b.customer_id = c.customer_id) AS total_revenue
FROM Customer c;

/*List Users Who Have Booked Tickets for Events in a Given Venue Using a Subquery in the WHERE Clause*/
SELECT DISTINCT c.*
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
WHERE b.event_id IN (SELECT event_id FROM Event WHERE venue_id = 1);

/* Calculate the Total Number of Tickets Sold for Each Event Category Using a Subquery with GROUP BY*/
SELECT event_type, 
       (SELECT SUM(b.num_tickets) FROM Booking b WHERE b.event_id = e.event_id) AS total_tickets_sold
FROM Event e
GROUP BY event_type;

/*Find Users Who Have Booked Tickets for Events in Each Month Using a Subquery with DATE_FORMAT*/
SELECT DISTINCT c.customer_id, c.customer_name
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
WHERE DATE_FORMAT(b.booking_date, '%Y-%m') IN 
      (SELECT DISTINCT DATE_FORMAT(booking_date, '%Y-%m') FROM Booking);

/*Calculate the Average Ticket Price for Events in Each Venue Using a Subquery*/
SELECT venue_id, 
       (SELECT AVG(ticket_price) FROM Event e WHERE e.venue_id = v.venue_id) AS avg_ticket_price
FROM Venue v;



