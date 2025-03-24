-- Create the database bookstore_db
CREATE DATABASE bookstore_db;

-- Create books table
CREATE TABLE books (
    id SERIAL PRIMARY KEY, 
    title VARCHAR(255) NOT NULL, 
    author VARCHAR(255) NOT NULL, 
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), 
    stock INT NOT NULL CHECK (stock >= 0), 
    published_year INT NOT NULL
);

-- Create customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(255) NOT NULL, 
    email VARCHAR(255) UNIQUE NOT NULL, 
    joined_date DATE DEFAULT CURRENT_DATE
);

-- Create orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY, 
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE, 
    book_id INT REFERENCES books(id) ON DELETE CASCADE, 
    quantity INT NOT NULL CHECK (quantity > 0), 
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add dummay data to the books table
INSERT INTO books (id, title, author, price, stock, published_year)
VALUES 
(1, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
(2, 'Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
(3, 'You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014), -- Escaped single quote here
(4, 'Refactoring', 'Martin Fowler', 50.00, 3, 1999),
(5, 'Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

-- Add dummy data to the customers table
INSERT INTO customers (id, name, email, joined_date)
VALUES
(1, 'Alice', 'alice@email.com', '2023-01-10'),
(2, 'Bob', 'bob@email.com', '2022-05-15'),
(3, 'Charlie', 'charlie@email.com', '2023-06-20');

-- Add dummy data to the orders table
INSERT INTO orders (id, customer_id, book_id, quantity, order_date)
VALUES
(1, 1, 2, 1, '2024-03-10'),
(2, 2, 1, 1, '2024-02-20'),
(3, 1, 3, 2, '2024-03-05');


-- 1. Find books that are out of stock.
SELECT title 
FROM books 
WHERE stock = 0;

-- 2. Retrieve the most expensive book in the store.
SELECT *
FROM books
ORDER BY price DESC
LIMIT 1;

-- 3. Find the total number of orders placed by each customer.
SELECT c.name, COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) > 0
ORDER BY total_orders DESC;

-- 4. Calculate the total revenue generated from book sales.
SELECT SUM(o.quantity * b.price) AS total_revenue
FROM orders o
JOIN books b ON o.book_id = b.id;

-- 5. List all customers who have placed more than one order.
SELECT c.name, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) > 1;

-- 6. Find the average price of books in the store.
SELECT ROUND(AVG(price), 2) AS avg_book_price
FROM books;

-- 7. Increase the price of all books published before 2000 by 10%.
UPDATE books
SET price = price * 1.10
WHERE published_year < 2000;

-- 8. Delete customers who haven't placed any orders.
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);