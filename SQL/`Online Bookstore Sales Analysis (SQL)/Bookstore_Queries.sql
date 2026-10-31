CREATE DATABASE OnlineBookstore;

USE OnlineBookstore;

-- Create Books Table
CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10, 2),
    Stock INT
);
-- Create Customers Table
CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
-- Create Orders Table
CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2),

    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);
-- Create Orders Table
CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2),

    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);
LOAD DATA LOCAL INFILE
'D:/5. DATA ANALYST/3. SQL/PROJECT/SATISH DHAWALE SQL PROJECT/WORKING FILES/Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Book_ID, Title, Author, Genre, Published_Year, Price, Stock);

LOAD DATA LOCAL INFILE
'D:/5. DATA ANALYST/3. SQL/PROJECT/SATISH DHAWALE SQL PROJECT/WORKING FILES/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Customer_ID, Name, Email, Phone, City, Country);

LOAD DATA LOCAL INFILE
'D:/5. DATA ANALYST/3. SQL/PROJECT/SATISH DHAWALE SQL PROJECT/WORKING FILES/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount);

SELECT COUNT(*) FROM Orders;
-- Display Books Table
SELECT * FROM Books;

-- Display Customers Table
SELECT * FROM Customers;

-- Display Orders Table
SELECT * FROM Orders;

-- ===========================
-- Basic Queries
-- ===========================

-- 1) Retrieve all books in the "Fiction" genre
SELECT * FROM Books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950
SELECT * FROM Books
WHERE Published_Year > 1950;

-- 3) List all customers from Canada
SELECT *
FROM Customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6) Find the details of the most expensive book
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT *
FROM Orders
WHERE Total_Amount > 20;

-- 9) List all genres available in the Books table
SELECT DISTINCT Genre
FROM Books;

-- 10) Find the book with the lowest stock
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;


-- ===========================
-- Advance Queries
-- ===========================

-- 1) Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders
SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 4) Find the most frequently ordered book
SELECT o.Book_ID, b.Title, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY Order_Count DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of the "Fantasy" genre
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author
SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author;

-- 7) List the cities where customers who spent over $30 are located
SELECT DISTINCT c.City
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30;

-- 8) Find the customer who spent the most on orders
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID, b.Title, b.Stock,
       COALESCE(SUM(o.Quantity), 0) AS Order_Quantity,
       b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;