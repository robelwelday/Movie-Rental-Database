SET SQL_SAFE_UPDATES = 0;
SET autocommit = 0;
commit;
create database Movie_Rental_System;
CREATE TABLE customer (
    customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(100) NOT NULL,
    Last_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone_Number VARCHAR(15) UNIQUE NOT NULL,
    city varchar(15),
    road_num int,
    Date_Of_Birth DATE NOT NULL,
    Membership_Type varchar(20) NOT NULL,
    Join_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE movie (
    Movie_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Release_Year INT NOT NULL,
    Director VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) CHECK (Rating >= 0 AND Rating <= 10),
    movie_Language VARCHAR(50) NOT NULL,
    Duration INT NOT NULL,  
    Rental_Price_Per_Day DECIMAL(10, 2) NOT NULL  
);
CREATE TABLE payment_method (
    Payment_Method_ID INT AUTO_INCREMENT PRIMARY KEY,
    Method_Name VARCHAR(100) NOT NULL,
    Detail_Description TEXT
);
CREATE TABLE rental (
    Rental_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Movie_ID INT,
    Rental_Date DATE NOT NULL,
    Due_Date DATE NOT NULL,
    Return_Date DATE NULL,
    Rental_Price DECIMAL(5, 2) NOT NULL,
    Payment_Method_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
    FOREIGN KEY (Movie_ID) REFERENCES movie(Movie_ID),
    FOREIGN KEY (Payment_Method_ID) REFERENCES payment_method(Payment_Method_ID)
);
CREATE TABLE return_movie (
    Return_ID INT AUTO_INCREMENT PRIMARY KEY,
    Rental_ID INT,
    Return_Date DATE NOT NULL,
    Late_Fee DECIMAL(10, 2) DEFAULT 0.00,
    Return_Condition varchar(20),
    FOREIGN KEY (Rental_ID) REFERENCES rental(Rental_ID)
);
CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(100),
    hire_date DATE NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT TRUE,
    access_level varchar(20) NOT NULL,
    last_login DATETIME
);
CREATE TABLE Payment (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id INT NOT NULL,
  payment_method_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  payment_status varchar(20) NOT NULL DEFAULT 'completed',
  employee_id INT NULL,
  FOREIGN KEY (rental_id) REFERENCES Rental(rental_id),
  FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(payment_method_id),
  FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
commit;






