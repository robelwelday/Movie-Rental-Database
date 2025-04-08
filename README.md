# 🎬 Movie Rental Database

This repository contains a Movie Rental Database Schema and related SQL script that sets up the structure for a movie rental service.

---

## 📚 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Structure](#database-structure)
- [Usage](#usage)
- [SQL Script Explanation](#sql-script-explanation)
- [Important Indexes](#important-indexes)
- [Stored Procedures](#stored-procedures)
- [Contributing](#contributing)
- [License](#license)

---

## 📖 Overview

This **Movie Rental Database** is built using MySQL to support a movie rental system. The database allows storage and management of data related to movies, customers, movie rentals, returns, payments, and employees. The goal is to provide an efficient and reliable way to manage inventory, customer transactions, and rental processes for a movie rental business.

---

## ✨ Features

- 🎥 **Movie Information**: Store movie details like title, genre, release year, language, and rental price.
- 👤 **Customer Management**: Store personal details like name, address, email, and phone number.
- 📅 **Rental Transactions**: Record rental date, due date, return date, and price.
- 💳 **Payments**: Track payments made, payment methods, and statuses.
- 👔 **Employee Management**: Store employee details involved in handling transactions.
- 🎭 **Genres and Categories**: Define movie genres for classification.
- 📦 **Return Tracking**: Automatically calculate late fees and track return conditions.

---

## 🗂️ Database Structure

The database schema includes the following tables:

- **movie**: Information about each movie available for rent.
- **customer**: Details about customers renting movies.
- **rental**: Records of each movie rental including dates and pricing.
- **payment**: Records of customer payments and methods used.
- **payment_method**: Stores available payment options (e.g., card, cash).
- **return_movie**: Stores return details and calculates late fees.
- **employee**: Information about employees and their roles.

---

## 🛠️ Usage

### Requirements

- MySQL 8.0+
- MySQL Workbench or command-line access

### Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/movie-rental-db.git
2. Run the SQL script to create the schema:
     SOURCE Movie_Rental_Database.sql;
3. Optional: Execute stored procedures for inserting return info or calculating late fees.
##📄 SQL Script Explanation

The SQL script includes:
    CREATE DATABASE: Initializes the database.
    CREATE TABLE: Defines all necessary tables with constraints.
    ALTER TABLE: Sets up primary and foreign key relationships.
    DELIMITER $$: Enables use of stored procedures.
    Stored Procedures:
        insert_return_movie: Inserts a return record and sets rented to false.
        calculate_late_fee: Automatically calculates and updates late fees.
    VIEWS 
##⚡ Important Indexes
   To improve query performance, these indexes are included:
       CREATE INDEX idx_movie_rented ON movie(Rented);
       CREATE INDEX idx_rental_customer_id ON rental(Customer_ID);
       CREATE INDEX idx_rental_movie_id ON rental(Movie_ID);
       CREATE INDEX idx_return_rental_id ON return_movie(Rental_ID)
##Stored Procedures
1.calculate_late_fee
2.insert_return_movie
3.insert custemer 
4.insert payment 
5.inser rental
##🤝 Contributing

   Feel free to fork this repository and submit pull requests to improve the database or add new features.
  📝 License

This project is licensed under the MIT License. You can use, modify, and distribute it freely for personal or commercial projects.
👨‍💻 Author
    Name: Robel Welday BahtA
    Email: Robelwelday16@gmail.com
