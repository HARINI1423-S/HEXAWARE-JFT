 #Task 1
create database CourierManagementSystem;
use CourierManagementSystem;
CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    Password VARCHAR(255),
    ContactNumber VARCHAR(20),
    Address TEXT
);
CREATE TABLE Courier (
    CourierID INT PRIMARY KEY,
    SenderName VARCHAR(255),
    SenderAddress TEXT,
    ReceiverName VARCHAR(255),
    ReceiverAddress TEXT,
    Weight DECIMAL(5,2),
    Status VARCHAR(50),
    TrackingNumber VARCHAR(20) UNIQUE,
    DeliveryDate DATE
);

/*
CREATE TABLE Courier (
    CourierID INT PRIMARY KEY AUTO_INCREMENT,
    SenderID INT,
    ReceiverID INT,
    Weight DECIMAL(5,2) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    TrackingNumber VARCHAR(20) UNIQUE NOT NULL,
    DeliveryDate DATE NOT NULL,
    ServiceID INT,
    EmployeeID INT,
    FOREIGN KEY (SenderID) REFERENCES User(UserID),
    FOREIGN KEY (ReceiverID) REFERENCES User(UserID),
    FOREIGN KEY (ServiceID) REFERENCES CourierServices(ServiceID),
    FOREIGN KEY (EmployeeID) REFERENCES EmployeeTable(EmployeeID)
);
*/

CREATE TABLE CourierServices (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100),
    Cost DECIMAL(8,2)
);

CREATE TABLE EmployeeTable (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    ContactNumber VARCHAR(20),
    Role VARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE LocationTable (
    LocationID INT PRIMARY KEY,
    LocationName VARCHAR(100),
    Address TEXT
);
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    CourierID INT,
    LocationID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (CourierID) REFERENCES Courier(CourierID),
    FOREIGN KEY (LocationID) REFERENCES LocationTable(LocationID)
);
INSERT INTO User (UserID, Name, Email, Password, ContactNumber, Address) VALUES
(1, 'Harini', 'harini@example.com', 'password123', '9876543210', '123 Main St, Tamilnadu'),
(2, 'Vignesh', 'vignesh@example.com', 'password456', '8765432109', '456 Lean St, Karnataka'),
(3, 'Vihan', 'vihan@example.com', 'password789', '9876543211', '123 Anna St, Tamilnadu'),
(4, 'Viharika', 'viharika@example.com', 'password001', '8765432199', '456 Dean St, Kerala');

INSERT INTO Courier (CourierID, SenderName, SenderAddress, ReceiverName, ReceiverAddress, Weight, Status, TrackingNumber, DeliveryDate) VALUES
(1, 'Harini', '123 Main St, Tamilnadu', 'Alice', '789 Oak St, Chennai', 2.5, 'In Transit', 'TRK12345', '2025-04-01'),
(2, 'Vignesh', '456 Lean St, Karnataka', 'Bob', '321 Pine St, Bangalore', 1.2, 'Pending', 'TRK67890', '2025-04-05'),
(3, 'Vihan', '123 Anna St, Tamilnadu', 'Esha', '987 Lake St, Coimbatore', 3.0, 'Delivered', 'TRK54321', '2025-03-29'),
(4, 'Viharika', '456 Dean St, Kerala', 'Raj', '654 Beach Rd, Kochi', 2.0, 'Shipped', 'TRK98765', '2025-04-10');

INSERT INTO CourierServices (ServiceID, ServiceName, Cost) VALUES
(1, 'Standard Shipping', 50.00),
(2, 'Express Shipping', 100.00),
(3, 'Overnight Shipping', 150.00),
(4, 'Same-Day Delivery', 200.00);

INSERT INTO EmployeeTable (EmployeeID, Name, Email, ContactNumber, Role, Salary) VALUES
(1, 'Michael', 'michael@example.com', '7654321098', 'Manager', 75000.00),
(2, 'John', 'John@example.com', '6543210987', 'Customer Support', 50000.00),
(3, 'Jimmy', 'jimmy@example.com', '7432109876', 'Courier', 40000.00),
(4, 'Diwan', 'diwan@example.com', '9876543212', 'Logistics', 55000.00);

INSERT INTO LocationTable (LocationID, LocationName, Address) VALUES
(1, 'Warehouse A', '500 Industrial Road, Chennai'),
(2, 'Warehouse B', '700 Logistics Blvd, Bangalore'),
(3, 'Warehouse C', '300 Trade Center, Coimbatore'),
(4, 'Warehouse D', '900 Shipping Lane, Kochi');

INSERT INTO Payment (PaymentID, CourierID, LocationID, Amount, PaymentDate) VALUES
(1, 1, 1, 50.00, '2025-03-15'),
(2, 2, 2, 100.00, '2025-03-16'),
(3, 3, 3, 150.00, '2025-03-20'),
(4, 4, 4, 200.00, '2025-03-22');

#Task 2

/*List all Customers */
SELECT * FROM User;

/*List all orders for a specific customer*/
SELECT * FROM Courier WHERE SenderName = 'Harini';

/*List all couriers*/
SELECT * FROM Courier;

/*List all packages for specific order*/
SELECT * FROM Courier WHERE CourierID = 1;

/*List all deliveries for a specific courier*/
SELECT * FROM Courier WHERE CourierID=3 AND Status = 'Delivered';

/*list all undelivered Packages */
SELECT * FROM Courier WHERE Status != 'Delivered';

/*List all the packages that are scheduled for delivery today*/
SELECT * FROM Courier WHERE DeliveryDate = CURDATE();

/* List all packages with a specific status*/
SELECT * FROM Courier WHERE Status = 'In Transit';

/*Calculate the total number of packages for each courier*/
SELECT SenderName, COUNT(*) AS TotalPackages FROM Courier GROUP BY SenderName;

/*Find the average delivery time for each courier*/
SELECT SenderName, AVG(DATEDIFF(DeliveryDate, NOW())) AS AvgDeliveryTime FROM Courier GROUP BY SenderName;

/*List all packages with a specific weight range*/
SELECT * FROM Courier WHERE Weight BETWEEN 1.0 AND 3.0;

/*Retrieve employees whose names contain 'John'  */
SELECT * FROM EmployeeTable WHERE Name LIKE '%John%';

/* Retrieve all courier records with payments greater than $50 */
SELECT * FROM Payment WHERE Amount > 50;


#TASK 3


ALTER table Courier ADD EmployeeId INT;
ALTER table courier ADD foreign key(EmployeeId) REFERENCES employeetable(EmployeeID);

SET SQL_SAFE_UPDATES=0;

UPDATE Courier 
SET EmployeeID = (SELECT EmployeeID FROM EmployeeTable ORDER BY RAND() LIMIT 1) 
WHERE EmployeeID IS NULL;

/* Find the total number of couriers handled by each employee*/
SELECT EmployeeId,count(CourierID) as TotalNumberOfCouriers from  courier group by EmployeeID;

/*Calculate the total revenue generated by each location */
SELECT LocationID ,sum(Amount)as Total_revenue from payment group by locationID;

/* Find the total number of couriers delivered to each location */
SELECT LocationID, COUNT(CourierID) AS TotalDeliveredCouriers 
FROM Payment 
WHERE CourierID IN (SELECT CourierID FROM Courier WHERE Status = 'Delivered') 
GROUP BY LocationID;

/* Find the courier with the highest average delivery time*/
SELECT CourierID ,AVG(datediff(DeliveryDate,now())) as AvgDeliveryTime from courier group by CourierID  order by AvgDeliveryTime DESC LIMIT 1;

/* Find Locations with Total Payments Less Than a Certain Amount */
SELECT LocationID,SUM(Amount) as TotalPayments from Payment  group by LocationID HAVING TotalPayments <150;

/* Calculate Total Payments per Location*/
SELECT LocationID,SUM(Amount) as TotalPayments from Payment group by LocationID;

/* Retrieve couriers who have received payments totaling more than $1000 in a specific location 
(LocationID = X):*/
SELECT CourierID, SUM(Amount) AS TotalPayments 
FROM Payment 
WHERE LocationID = 2
GROUP BY CourierID 
HAVING TotalPayments > 1000;

/* Retrieve couriers who have received payments totaling more than $1000 after a certain date 
(PaymentDate > 'YYYY-MM-DD')*/
SELECT CourierID, SUM(Amount) AS TotalPayments 
FROM Payment 
WHERE PaymentDate > '2025-03-15' 
GROUP BY CourierID 
HAVING TotalPayments > 1000;

/*Retrieve locations where the total amount received is more than $5000 before a certain date 
(PaymentDate > 'YYYY-MM-DD'*/
SELECT LocationID, SUM(Amount) AS TotalPayments 
FROM Payment 
WHERE PaymentDate < '2025-03-20' 
GROUP BY LocationID 
HAVING TotalPayments > 5000;

#TASK 4

/* Retrieve Payments with Courier Information */
SELECT P.PaymentID, P.Amount, P.PaymentDate, C.CourierID, C.SenderName, C.ReceiverName, C.Status  
FROM Payment P  
INNER JOIN Courier C ON P.CourierID = C.CourierID;

/*Retrieve Payments with Location Information */
SELECT P.PaymentID, P.Amount, P.PaymentDate, L.LocationID, L.LocationName, L.Address  
FROM Payment P  
INNER JOIN LocationTable L ON P.LocationID = L.LocationID;

/*Retrieve Payments with Courier and Location Information */
SELECT P.PaymentID, P.Amount, P.PaymentDate,  
       C.CourierID, C.SenderName, C.ReceiverName, C.Status,  
       L.LocationID, L.LocationName, L.Address  
FROM Payment P  
INNER JOIN Courier C ON P.CourierID = C.CourierID  
INNER JOIN LocationTable L ON P.LocationID = L.LocationID;

/*List all payments with courier details  */

SELECT P.PaymentID, P.Amount, P.PaymentDate, C.CourierID, C.SenderName, C.ReceiverName, C.Status  
FROM Payment P  
LEFT JOIN Courier C ON P.CourierID = C.CourierID;

/*total payments received for each courier */
SELECT C.CourierID, C.SenderName, SUM(P.Amount) AS TotalPayment  
FROM Courier C  
INNER JOIN Payment P ON C.CourierID = P.CourierID  
GROUP BY C.CourierID, C.SenderName;

 /*List payments made on a specific date*/
SELECT * FROM Payment WHERE PaymentDate = '2025-03-15';

/*Get Courier Information for Each Payment  */
SELECT P.PaymentID, C.CourierID, C.SenderName, C.Status  
FROM Payment P  
INNER JOIN Courier C ON P.CourierID = C.CourierID;

/*Get Payment Details with Location */
SELECT P.PaymentID, P.Amount, L.LocationName  
FROM Payment P  
INNER JOIN LocationTable L ON P.LocationID = L.LocationID;

/*Calculating Total Payments for Each Courier */
SELECT CourierID, SUM(Amount) AS TotalPayment  
FROM Payment  
GROUP BY CourierID;

/*List Payments Within a Date Range */
SELECT * FROM Payment WHERE PaymentDate BETWEEN '2025-03-01' AND '2025-03-31';

/* Retrieve a list of all users and their corresponding courier records, including cases where there are 
no matches on either side */
SELECT U.UserID, U.Name, C.CourierID, C.TrackingNumber  
FROM User U  
LEFT JOIN Courier C ON U.Name = C.SenderName  
UNION  
SELECT U.UserID, U.Name, C.CourierID, C.TrackingNumber  
FROM User U  
RIGHT JOIN Courier C ON U.Name = C.SenderName;

/* Retrieve a list of all couriers and their corresponding services, including cases where there are no 
matches on either side  */
SELECT C.CourierID, C.SenderName, CS.ServiceName, CS.Cost  
FROM Courier C  
LEFT JOIN CourierServices CS ON C.CourierID = CS.ServiceID  
UNION  
SELECT C.CourierID, C.SenderName, CS.ServiceName, CS.Cost  
FROM Courier C  
RIGHT JOIN CourierServices CS ON C.CourierID = CS.ServiceID;

/* Retrieve a list of all employees and their corresponding payments, including cases where there are 
no matches on either side  */
SELECT E.EmployeeID, E.Name, P.Amount  
FROM EmployeeTable E  
LEFT JOIN Payment P ON E.EmployeeID = P.PaymentID  
UNION  
SELECT E.EmployeeID, E.Name, P.Amount  
FROM EmployeeTable E  
RIGHT JOIN Payment P ON E.EmployeeID = P.PaymentID;

/*. List all users and all courier services, showing all possible combinations*/
SELECT U.Name, CS.ServiceName  
FROM User U  
CROSS JOIN CourierServices CS;

/*. List all employees and all locations, showing all possible combinations*/
SELECT E.Name, L.LocationName  
FROM EmployeeTable E  
CROSS JOIN LocationTable L;

/*Retrieve a list of couriers and their corresponding sender information (if available) */
SELECT C.CourierID, C.SenderName, U.Address  
FROM Courier C  
LEFT JOIN User U ON C.SenderName = U.Name;

/*Retrieve a list of couriers and their corresponding receiver information */
SELECT C.CourierID, C.ReceiverName, U.Address  
FROM Courier C  
LEFT JOIN User U ON C.ReceiverName = U.Name;

/*Retrieve Couriers Along with Their Service Details */
SELECT C.CourierID, C.SenderName, CS.ServiceName, CS.Cost  
FROM Courier C  
LEFT JOIN CourierServices CS ON C.CourierID = CS.ServiceID;

/*Retrieve Employees and the Number of Couriers Assigned to each employee*/
SELECT E.EmployeeID, E.Name, COUNT(C.CourierID) AS TotalCouriers  
FROM EmployeeTable E  
LEFT JOIN Courier C ON E.EmployeeID = C.CourierID  
GROUP BY E.EmployeeID, E.Name;

/*. Retrieve a list of locations and the total payment amount received at each location*/
SELECT L.LocationID, L.LocationName, SUM(P.Amount) AS TotalPayments  
FROM LocationTable L  
LEFT JOIN Payment P ON L.LocationID = P.LocationID  
GROUP BY L.LocationID, L.LocationName;

/*Retrieve All Couriers Sent by the Same Sender*/
SELECT A.CourierID, A.SenderName, B.CourierID AS RelatedCourierID  
FROM Courier A  
JOIN Courier B ON A.SenderName = B.SenderName AND A.CourierID <> B.CourierID;

/*List Employees Who Share the Same Role*/
SELECT A.Name, A.Role, B.Name AS ColleagueName  
FROM EmployeeTable A  
JOIN EmployeeTable B ON A.Role = B.Role AND A.EmployeeID <> B.EmployeeID;

/* Retrieve All Payments for Couriers Sent from the Same Location*/
SELECT P.*  
FROM Payment P  
JOIN Courier C ON P.CourierID = C.CourierID  
WHERE C.SenderAddress = '123 Main St, Tamilnadu';

/*Retrieve all couriers sent from the same location (based on SenderAddress)*/
SELECT A.CourierID, A.SenderName, A.SenderAddress, B.CourierID AS RelatedCourierID, B.SenderName AS RelatedSender
FROM Courier A
JOIN Courier B ON A.SenderAddress = B.SenderAddress AND A.CourierID <> B.CourierID;

/*List employees and the number of couriers they have delivered*/
SELECT E.EmployeeID, E.Name, COUNT(C.CourierID) AS TotalDelivered
FROM EmployeeTable E
JOIN Courier C ON E.EmployeeID = C.AssignedEmployeeID  -- Assuming this column exists
WHERE C.Status = 'Delivered'
GROUP BY E.EmployeeID, E.Name;


/*Find Couriers Paid More Than Their Service Cost*/
SELECT C.CourierID, C.SenderName, CS.ServiceName, P.Amount, CS.Cost  
FROM Payment P  
JOIN Courier C ON P.CourierID = C.CourierID  
JOIN CourierServices CS ON C.CourierID = CS.ServiceID  
WHERE P.Amount > CS.Cost;

/* Find couriers that have a weight greater than the average weight of all couriers*/
SELECT CourierID, SenderName, ReceiverName, Weight  
FROM Courier  
WHERE Weight > (SELECT AVG(Weight) FROM Courier);

/*Find the names of all employees who have a salary greater than the average salary*/
SELECT EmployeeID, Name, Salary  
FROM EmployeeTable  
WHERE Salary > (SELECT AVG(Salary) FROM EmployeeTable);

/*Find the total cost of all courier services where the cost is less than the maximum cost*/
SELECT SUM(Cost) AS TotalCost  
FROM CourierServices  
WHERE Cost < (SELECT MAX(Cost) FROM CourierServices);

/*Find all couriers that have been paid for*/
SELECT CourierID, SenderName, ReceiverName, Status  
FROM Courier  
WHERE EXISTS (SELECT 1 FROM Payment WHERE Payment.CourierID = Courier.CourierID);

/*Find the locations where the maximum payment amount was made*/
SELECT LocationID, LocationName  
FROM LocationTable  
WHERE LocationID IN (SELECT LocationID FROM Payment WHERE Amount = (SELECT MAX(Amount) FROM Payment));

/*Find all couriers whose weight is greater than the weight of all couriers sent by a specific sender ('SenderName')*/
SELECT CourierID, SenderName, ReceiverName, Weight  
FROM Courier  
WHERE Weight > ALL (SELECT Weight FROM Courier WHERE SenderName = 'Harini');













