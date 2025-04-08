SET SQL_SAFE_UPDATES = off;
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
    Rental_Price_Per_Day DECIMAL(10, 2) NOT NULL,
    Rented BOOLEAN DEFAULT false
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
    FOREIGN KEY (Payment_Method_ID) REFERENCES payment_method(Payment_Method_ID),
    CONSTRAINT chk_due_date CHECK (Due_Date > Rental_Date),
    CONSTRAINT chk_return_date CHECK (
        Return_Date IS NULL OR 
        (Return_Date >= Rental_Date))
);
CREATE TABLE return_movie (
    
    Return_ID INT AUTO_INCREMENT PRIMARY KEY,
    Rental_ID INT,
    Movie_ID  INT,
    Return_Date DATE NOT NULL,
    Late_Fee DECIMAL(10, 2) DEFAULT 0.00,
    Return_Condition varchar(20),
    FOREIGN KEY (Rental_ID) REFERENCES rental(Rental_ID),
    FOREIGN KEY (Movie_ID)  REFERENCES movie(Movie_ID)
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
  employee_id INT NOT NULL,
  FOREIGN KEY (rental_id) REFERENCES Rental(rental_id),
  FOREIGN KEY (payment_method_id) REFERENCES Payment_Method(payment_method_id),
  FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
commit;
DELIMITER $$

CREATE PROCEDURE AddMovie(
    IN p_Title VARCHAR(255),
    IN p_Genre VARCHAR(100),
    IN p_Release_Year INT,
    IN p_Director VARCHAR(100),
    IN p_Rating DECIMAL(3, 1),
    IN p_Movie_Language VARCHAR(50),
    IN p_Duration INT,
    IN p_Rental_Price_Per_Day DECIMAL(10, 2)
)
BEGIN
    DECLARE current_max INT;
    SELECT MAX(Movie_ID) INTO current_max FROM Movies;
    IF current_max IS NULL THEN
        ALTER TABLE Movies AUTO_INCREMENT = 1000;
    END IF;
    INSERT INTO Movies (
        Title, Genre, Release_Year, Director, Rating,
        movie_Language, Duration, Rental_Price_Per_Day
    )
    VALUES (
        p_Title, p_Genre, p_Release_Year, p_Director, p_Rating,
        p_Movie_Language, p_Duration, p_Rental_Price_Per_Day
    );
END $$
DELIMITER ;
DELIMITER $$

CREATE PROCEDURE AddCustomer(
    IN p_First_Name VARCHAR(100),
    IN p_Last_Name VARCHAR(100),
    IN p_Email VARCHAR(255),
    IN p_Phone_Number VARCHAR(15),
    IN p_City VARCHAR(15),
    IN p_Road_Num INT,
    IN p_Date_Of_Birth DATE,
    IN p_Membership_Type VARCHAR(20)
)
BEGIN
    DECLARE current_max INT;
    SELECT MAX(customer_ID) INTO current_max FROM customer;
    IF current_max IS NULL THEN
        ALTER TABLE customer AUTO_INCREMENT = 1000;
    END IF;
    INSERT INTO customer (
        First_Name,
        Last_Name,
        Email,
        Phone_Number,
        city,
        road_num,
        Date_Of_Birth,
        Membership_Type
    )
    VALUES (
        p_First_Name,
        p_Last_Name,
        p_Email,
        p_Phone_Number,
        p_City,
        p_Road_Num,
        p_Date_Of_Birth,
        p_Membership_Type
    );
END $$
DELIMITER ;
DELIMITER $$

CREATE PROCEDURE InsertRental (
    IN p_Customer_ID INT,
    IN p_Movie_ID INT,
    IN p_Rental_Date DATE,
    IN p_Due_Date DATE,
    IN p_Return_Date DATE,
    IN p_Rental_Price DECIMAL(5,2),
    IN p_Payment_Method_ID INT
)
BEGIN
 DECLARE current_max INT;
    SELECT MAX(rental_ID) INTO current_max FROM Rental;
    IF current_max IS NULL THEN
        ALTER TABLE Rental AUTO_INCREMENT = 1000;
    END IF;
    INSERT INTO rental (
        Customer_ID,
        Movie_ID,
        Rental_Date,
        Due_Date,
        Return_Date,
        Rental_Price,
        Payment_Method_ID
    ) VALUES (
        p_Customer_ID,
        p_Movie_ID,
        p_Rental_Date,
        p_Due_Date,
        p_Return_Date,
        p_Rental_Price,
        p_Payment_Method_ID
    );
   UPDATE movie
    SET Rented=true
    WHERE Movie_ID=p_Movie_ID;
END$$
DELIMITER ;
commit;
DELIMITER $$

CREATE PROCEDURE insert_return_movie (
    IN p_Rental_ID INT,
    IN p_Movie_ID INT,
    IN p_Return_Date DATE,
    IN p_Return_Condition VARCHAR(20)
)
BEGIN
    DECLARE current_max INT;
    SELECT MAX(Return_ID) INTO current_max FROM return_movie;
    IF current_max IS NULL THEN
        ALTER TABLE return_movie AUTO_INCREMENT = 1000;
    END IF;
    INSERT INTO return_movie (
        Rental_ID,
        Movie_ID,
        Return_Date,
        Late_Fee, 
        Return_Condition
    ) VALUES (
        p_Rental_ID,
        p_Movie_ID,
        p_Return_Date,
        0.00,
        p_Return_Condition
    );

    CALL calculate_late_fee(p_Rental_ID);
    UPDATE movie
    SET Rented = FALSE
    WHERE Movie_ID = p_Movie_ID;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE insert_payment (
    IN p_rental_id INT,
    IN p_payment_method_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_payment_status VARCHAR(20),
    IN p_employee_id INT
)
BEGIN
    DECLARE current_max INT;
    SELECT MAX(payment_ID) INTO current_max FROM payment;
    IF current_max IS NULL THEN
        ALTER TABLE payment AUTO_INCREMENT = 1000;
    END IF;
    INSERT INTO Payment (
        rental_id,
        payment_method_id,
        amount,
        payment_status,
        employee_id
    ) VALUES (
        p_rental_id,
        p_payment_method_id,
        p_amount,
        COALESCE(p_payment_status, 'completed'),
        p_employee_id
    );
END$$
DELIMITER ;
commit;
CREATE VIEW rented_movies AS
SELECT *
FROM movies
WHERE Rented = TRUE;
commit;
DELIMITER $$

CREATE PROCEDURE calculate_late_fee(IN p_rental_id INT)
BEGIN
    DECLARE v_due_date DATE;
    DECLARE v_return_date DATE;
    DECLARE v_days_late INT;
    DECLARE v_late_fee DECIMAL(10,2);

    SELECT Due_Date INTO v_due_date
    FROM rental
    WHERE Rental_ID = p_rental_id;
    SELECT Return_Date INTO v_return_date
    FROM return_movie
    WHERE Rental_ID = p_rental_id;
    SET v_days_late = DATEDIFF(v_return_date, v_due_date);

    IF v_days_late > 0 THEN
        SET v_late_fee = v_days_late * 5.00;
    ELSE
        SET v_late_fee = 0.00;
    END IF;
    UPDATE return_movie
    SET Late_Fee = v_late_fee
    WHERE Rental_ID = p_rental_id;
END$$
DELIMITER ;
commit;
CREATE INDEX idx_movie_rented ON movie(Rented);
CREATE INDEX idx_rental_customer_id ON rental(Customer_ID);
CREATE INDEX idx_rental_movie_id ON rental(Movie_ID);
CREATE INDEX idx_return_rental_id ON return_movie(Rental_ID);
commit;