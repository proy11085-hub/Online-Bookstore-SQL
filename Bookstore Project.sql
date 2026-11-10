-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

Select * from Books
where genre='Fiction';--retrieve all books from fiction genre

Select * from Books
where published_year>= 1950;--retrieve all books published after 1950

Select * from Customers
where country='Canada';--retrieve customer names from Cananda

Select * from Orders
where order_date between '2023-11-01' and '2023-11-30';--orders placed in november 2023

Select SUM(stock) as total_stock
from Books;--total stock of the books

Select * from Books Order by Price desc
limit 1;--most expensive book

Select * from Orders
Where quantity>1;--books ordered atleast once

Select * from Orders
where total_amount>20;--total orders of the books

Select Distinct genre from books;--all the genres given 

Select * from Books
order by stock asc
limit 1;--book with lowest stock

Select Sum(total_amount) as total_revenue from Orders;--total revenue

------------------------------------------------------------------------------------------------------------------
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

Select b.genre, Sum(o.quantity) as total_sold
from Orders o
join Books b on o.book_id=b.book_id
Group by b.genre;--totl sale of each genre

Select avg(price) as Avg_price
from Books
where genre='Fantasy';-- average price of fantasy genre

Select o.customer_id,c.name, Count(o.order_id) as order_count
from Orders o
join Customers c on o.customer_id=c.customer_id
Group by o.customer_id, c.name
Having Count(o.order_id)>=2;--customer name who ordered more than one book

Select o.book_id,b.title, Sum(o.order_id) as frequent_order_count
From Orders o
Join Books b on o.book_id=b.book_id
Group by o.book_id,b.title
Order by frequent_order_count desc limit 1;--frequently ordered book

Select * from Books
Where genre='Fantasy'
Order by price desc limit 3;--most expensive fantasy book

Select b.author,Sum(o.quantity) as total_quantity
From Orders o
Join Books b on o.book_id=b.book_id
Group by b.author;--total books sold by each order

SELECT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30
Group by c.city,total_amount;--cities where customers who spent over $30 are located

Select c.name,Sum(o.total_amount) as Total_spent
From Orders o
Join Customers c on o.customer_id=c.customer_id
Group by c.name
order by Total_spent desc limit 1;--customer who spent the most

Select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,
		b.stock-coalesce(sum(o.quantity),0) as remaining_stock
From Books b
Left Join Orders o on b.book_id=o.book_id
Group by b.book_id order by b.book_id;--remaining stock of each book

