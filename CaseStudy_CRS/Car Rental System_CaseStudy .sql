CREATE DATABASE IF NOT EXISTS CarRentalSystem;
USE CarRentalSystem;

CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY AUTO_INCREMENT,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL CHECK (year >= 1900),
    dailyRate DECIMAL(10,2) NOT NULL,
    status ENUM('available', 'notAvailable') NOT NULL,
    passengerCapacity INT NOT NULL,
    engineCapacity FLOAT NOT NULL
);
select * from Payment;
select * from Customer;
USE CarRentalSystem;


ALTER TABLE Lease ADD COLUMN returnDate DATE;

ALTER TABLE Lease ADD COLUMN totalAmount DOUBLE;

CREATE TABLE Customer (
    customerID INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phoneNumber VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE Lease (
    leaseID INT PRIMARY KEY AUTO_INCREMENT,
    vehicleID INT NOT NULL,
    customerID INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    type ENUM('Daily', 'Monthly') NOT NULL,
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payment (
    paymentID INT PRIMARY KEY AUTO_INCREMENT,
    leaseID INT NOT NULL,
    paymentDate DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity) VALUES
('Toyota', 'Corolla', 2020, 40.00, 'available', 5, 1.8),
('Honda', 'Civic', 2019, 45.00, 'available', 5, 2.0),
('Ford', 'Focus', 2021, 50.00, 'notAvailable', 5, 1.6),
('BMW', 'X5', 2022, 100.00, 'available', 7, 3.0),
('Audi', 'A4', 2021, 90.00, 'available', 5, 2.0),
('Mercedes', 'C-Class', 2023, 110.00, 'available', 5, 2.5),
('Hyundai', 'Elantra', 2020, 35.00, 'available', 5, 1.6),
('Kia', 'Seltos', 2021, 38.00, 'available', 5, 1.5),
('Nissan', 'Altima', 2018, 42.00, 'notAvailable', 5, 2.5),
('Volkswagen', 'Jetta', 2022, 47.00, 'available', 5, 1.4);

INSERT INTO Customer (firstName, lastName, email, phoneNumber) VALUES
('John', 'Doe', 'john.doe@example.com', '9876543210'),
('Jane', 'Smith', 'jane.smith@example.com', '9876543211'),
('Alice', 'Brown', 'alice.brown@example.com', '9876543212'),
('Bob', 'Johnson', 'bob.johnson@example.com', '9876543213'),
('Charlie', 'Davis', 'charlie.davis@example.com', '9876543214'),
('David', 'Wilson', 'david.wilson@example.com', '9876543215'),
('Emily', 'Moore', 'emily.moore@example.com', '9876543216'),
('Frank', 'Anderson', 'frank.anderson@example.com', '9876543217'),
('Grace', 'Thomas', 'grace.thomas@example.com', '9876543218'),
('Henry', 'White', 'henry.white@example.com', '9876543219');

ALTER TABLE Lease CHANGE type leaseType ENUM('DailyLease', 'MonthlyLease') NOT NULL;
INSERT INTO Lease (vehicleID, customerID, startDate, endDate, leaseType) VALUES
(1, 1, '2025-03-01', '2025-03-10', 'DailyLease'),
(2, 2, '2025-03-05', '2025-04-05', 'MonthlyLease'),
(3, 3, '2025-03-10', '2025-03-20', 'DailyLease'),
(4, 4, '2025-03-15', '2025-04-15', 'MonthlyLease'),
(5, 5, '2025-03-20', '2025-03-25', 'DailyLease'),
(6, 6, '2025-03-25', '2025-04-25', 'MonthlyLease'),
(7, 7, '2025-04-01', '2025-04-10', 'DailyLease'),
(8, 8, '2025-04-05', '2025-05-05', 'MonthlyLease'),
(9, 9, '2025-04-10', '2025-04-20', 'DailyLease'),
(10, 10, '2025-04-15', '2025-05-15', 'MonthlyLease');

INSERT INTO Payment (leaseID, paymentDate, amount) VALUES
(1, '2025-03-01', 400.00),
(2, '2025-03-05', 1350.00),
(3, '2025-03-10', 500.00),
(4, '2025-03-15', 1500.00),
(5, '2025-03-20', 250.00),
(6, '2025-03-25', 1400.00),
(7, '2025-04-01', 350.00),
(8, '2025-04-05', 1200.00),
(9, '2025-04-10', 450.00),
(10, '2025-04-15', 1550.00);
