CREATE DATABASE IF NOT EXISTS CareerHub;
USE CareerHub;

CREATE TABLE IF NOT EXISTS Companies (
    CompanyID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Jobs (
    JobID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT,
    JobTitle VARCHAR(255) NOT NULL,
    JobDescription TEXT NOT NULL,
    JobLocation VARCHAR(255) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary >= 0),
    JobType ENUM('Full-time', 'Part-time', 'Contract') NOT NULL,
    PostedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Applicants (
    ApplicantID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Resume TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Applications (
    ApplicationID INT PRIMARY KEY AUTO_INCREMENT,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    CoverLetter TEXT NOT NULL,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE,
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID) ON DELETE CASCADE
);

INSERT INTO Companies (CompanyName, Location) VALUES
('Hexaware Technologies', 'Chennai'),
('Infosys', 'Bangalore'),
('TCS', 'Mumbai'),
('Google', 'Hyderabad'),
('Microsoft', 'Pune'),
('Amazon', 'Delhi'),
('IBM', 'Kolkata');

INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType) VALUES
(1, 'Software Engineer', 'Develop and maintain applications.', 'Chennai', 80000, 'Full-time'),
(2, 'Data Analyst', 'Analyze company data for insights.', 'Bangalore', 75000, 'Full-time'),
(3, 'Project Manager', 'Lead software development projects.', 'Mumbai', 90000, 'Full-time'),
(4, 'Cloud Engineer', 'Manage cloud infrastructure.', 'Hyderabad', 85000, 'Full-time'),
(5, 'AI Developer', 'Work on AI-driven solutions.', 'Pune', 95000, 'Full-time'),
(6, 'Business Analyst', 'Analyze business needs.', 'Delhi', 70000, 'Full-time'),
(7, 'Cybersecurity Expert', 'Ensure company security.', 'Kolkata', 88000, 'Full-time');


INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume) VALUES
('John', 'Doe', 'john@example.com', '9876543210', 'Resume of John'),
('Alice', 'Smith', 'alice@example.com', '9876543211', 'Resume of Alice'),
('Bob', 'Brown', 'bob@example.com', '9876543212', 'Resume of Bob'),
('Charlie', 'Davis', 'charlie@example.com', '9876543213', 'Resume of Charlie'),
('Eve', 'Wilson', 'eve@example.com', '9876543214', 'Resume of Eve'),
('Frank', 'Thomas', 'frank@example.com', '9876543215', 'Resume of Frank'),
('Grace', 'Harris', 'grace@example.com', '9876543216', 'Resume of Grace');

INSERT INTO Applications (JobID, ApplicantID, CoverLetter) VALUES
(1, 1, 'I am interested in this role.'),
(2, 2, 'Looking forward to this opportunity.'),
(3, 3, 'My skills match this job.'),
(4, 4, 'I have relevant experience.'),
(5, 5, 'Eager to contribute to this company.'),
(6, 6, 'Would love to join your team.'),
(7, 7, 'I am highly interested.');

 /* 5) Job Title with Applicationn Count*/
SELECT j.JobTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
GROUP BY j.JobID, j.JobTitle;

/* 6) jobs within a specified salary range*/
SELECT j.JobTitle, c.CompanyName, j.JobLocation, j.Salary
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary BETWEEN 60000 AND 80000;

/* 7)job application history for a specific applicant */
SELECT j.JobTitle, c.CompanyName, a.ApplicationDate
FROM Applications a
JOIN Jobs j ON a.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE a.ApplicantID =3;

/* 8)Calculate average salary */
SELECT AVG(Salary) AS AverageSalary FROM Jobs WHERE Salary > 0;

/* 9) Company with most job listings */
SELECT c.CompanyName, COUNT(j.JobID) AS JobCount
FROM Companies c
JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyID, c.CompanyName
HAVING COUNT(j.JobID) = (
    SELECT MAX(JobCount)
    FROM (SELECT COUNT(JobID) AS JobCount FROM Jobs GROUP BY CompanyID) AS JobCounts
);

/* 10) Applicants for companies in 'CityX' with 3+ years experience */
SET SQL_SAFE_UPDATES = 0;
UPDATE Applicants
SET Resume = 'Resume of John with 3+ years of experience in Software Engineering'
WHERE FirstName = 'John' AND LastName = 'Doe';

UPDATE Applicants
SET Resume = 'Resume of Frank with 3+ years of experience in Business Analysis'
WHERE FirstName = 'Frank' AND LastName = 'Thomas';

SELECT a.FirstName, a.LastName, j.JobTitle, c.CompanyName
FROM Applications app
JOIN Jobs j ON app.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
JOIN Applicants a ON app.ApplicantID = a.ApplicantID
WHERE c.Location = 'Pune' AND a.Resume LIKE '%3+ years%' OR a.Resume LIKE '%3+ years%' OR a.Resume LIKE '%more than 3 years%';

/* 11) Distinct job titles with salaries between $60,000 and $80,000*/
SELECT DISTINCT JobTitle FROM Jobs WHERE Salary BETWEEN 60000 AND 80000;

/* 12)Jobs Without applications */
DELETE FROM Applications WHERE JobID = 7;
SELECT JobTitle FROM Jobs WHERE JobID NOT IN (SELECT JobID FROM Applications);

/* 13)Applicants with companies and positions applied for */
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM Applications app
JOIN Jobs j ON app.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
JOIN Applicants a ON app.ApplicantID = a.ApplicantID;

/* 14) Companies and count of jobs they posted */
SELECT c.CompanyName, COUNT(j.JobID) AS JobCount
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyID;

/*15) List all applicants along with companies and positions
 they applied for, including those who have not applied */
 SELECT a.FirstName, a.LastName, COALESCE(c.CompanyName, 'No Applications'), COALESCE(j.JobTitle, 'No Applications')
FROM Applicants a
LEFT JOIN Applications app ON a.ApplicantID = app.ApplicantID
LEFT JOIN Jobs j ON app.JobID = j.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID;

/*16)Companies that posted jobs with salary above average*/
SELECT DISTINCT c.CompanyName FROM Companies c
JOIN Jobs j ON c.CompanyID = j.CompanyID
WHERE j.Salary > (SELECT AVG(Salary) FROM Jobs WHERE Salary > 0);

/*17)Display applicants with concatenated city and state*/
ALTER TABLE Applicants ADD COLUMN City VARCHAR(100) DEFAULT 'Unknown';
ALTER TABLE Applicants ADD COLUMN State VARCHAR(100) DEFAULT 'Unknown';

UPDATE Applicants 
SET City = 
    CASE 
        WHEN FirstName = 'John' THEN 'Chennai'
        WHEN FirstName = 'Alice' THEN 'Bangalore'
        WHEN FirstName = 'Bob' THEN 'Mumbai'
        WHEN FirstName = 'Charlie' THEN 'Hyderabad'
        WHEN FirstName = 'Eve' THEN 'Pune'
        WHEN FirstName = 'Frank' THEN 'Delhi'
        ELSE 'Unknown'
    END,
    State = 
    CASE 
        WHEN FirstName = 'John' THEN 'Tamil Nadu'
        WHEN FirstName = 'Alice' THEN 'Karnataka'
        WHEN FirstName = 'Bob' THEN 'Maharashtra'
        WHEN FirstName = 'Charlie' THEN 'Telangana'
        WHEN FirstName = 'Eve' THEN 'Maharashtra'
        WHEN FirstName = 'Frank' THEN 'Delhi'
        ELSE 'Unknown'
    END;

SELECT FirstName, LastName, CONCAT(City, ', ', State) AS Location FROM Applicants;

/*18)jobs with titles containing either 'Developer' or 'Engineer'*/
SELECT JobTitle FROM Jobs WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

/*19) list of applicants and the jobs they have applied for,
 including those who have not applied and jobs without applicants */
 SELECT a.FirstName, a.LastName, j.JobTitle, c.CompanyName
FROM Applicants a
LEFT JOIN Applications app ON a.ApplicantID = app.ApplicantID
LEFT JOIN Jobs j ON app.JobID = j.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID;

/*20) combinations of applicants and companies where the company is in a specific city and
 the applicant has more than 2 years of experience */
 
SELECT a.FirstName, a.LastName, c.CompanyName
FROM Applicants a
CROSS JOIN Companies c
WHERE c.Location = 'Chennai' AND a.Resume LIKE '%3+ years%';
