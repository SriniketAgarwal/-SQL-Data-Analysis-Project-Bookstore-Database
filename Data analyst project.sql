Drop table if exists books;
create table books(
       book_id serial primary key,
	   tital varchar(100),
	   author varchar(100),
	   genre varchar(50),
	   published_year int,
	   price numeric(10,2),
	   stock int
);

select * from books;

Drop table if exists customer;
create table customer(
       customer_id serial primary key,
	   name varchar(100),
	   email varchar(100),
	   phone varchar(50),
	   city varchar(50),
	   country varchar(150)
);

select * from customer;


DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    book_id INT REFERENCES books(book_id),
    order_date DATE,
    quantity INT,
    total_amount NUMERIC(10,2)
);

select * from orders;

---For all 3 tables I've directly imported the CSV Files


-- 1st question:- Retrieve all books in fiction genre.

select * from books
where genre = 'Fiction';

--- 2nd Question:- Find books published after the year 1950.

select * from books
where published_year > 1950;

--- 3rd Question:- List all customers from Canada.

select * from customer
where country = 'Canada';

--- 4th question:- Show all orders placed in November 2023.

select * from orders
where order_date between '2023-11-1' and '2023-11-30';

-- 5th Questions:- Retrieve the total stock of books available.

select sum(stock) AS Total_Stock
From books;

--- 6th question:- Extract the details of most expensive book.

select * from books order by price DESC LIMIT 1;

--- 7TH Question:- Show all customer who ordered more than one unit of a book

select * from orders
where quantity > 1;

--- 8th Question:- Retrieve all orders where amount exceeds $ 20.

select * from orders
where total_amount > 20;

-- 9th Question:- List all genre available in books.

Select distinct genre from books;

--- 10th question:- Find the book with the lowest stock.

select * from books order by stock limit 1;

-- 11th question:- Calculate total revenue generated from all orders.

select sum(total_amount) as revenue
from orders;

-- 12th Question:- Retrieve the data for total books sold in each genre.

select b.genre, sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id = b.book_id
group by genre;

--- 13th Question:- Find the average price of book that are in fantacy genre.

Select AVG(Price) as Avg_price
from books
where genre = 'Fantasy';

--- 14th Question:- List the details of customer who have ordered minimum of 2 books.

Select o.customer_id, c.name, count(o.order_id) as order_count
from orders o
Join customer c ON o.customer_id=c.customer_id
group by o.customer_id, c.name
having count(order_id) >= 2;

---- 15th questions:- List the most frequently ordered books.

SELECT o.book_id, b.tital, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.tital
ORDER BY order_count DESC
LIMIT 1;

--- 16th questions:- List the top 3 most expensive books in Fantasy genre.

select * from books
where genre = 'Fantacy'
order by price desc limit 3;

--- 17th question:- Retrieve the data for total quantity of books sold by each author.

select b.author, sum(o.quantity) as total_book_sold
from orders o
join books b on o.book_id = b.book_id
group by b.author;

--- 18th question:- List the cities where customer who spent over $ 30 are located.

select distinct c.city, total_amount
from orders o 
join customer c on o.customer_id = c.customer_id
where o.total_amount > 30;

--- 19th Question:- Find the customer who spent the most on order.

Select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o
join customer c on o.customer_id = c.customer_id
group by c.customer_id, c.name
order by total_spent desc limit 1;

---- 20th question:- Calculate the stock remaining after fulfilling all orders.

SELECT 
    b.book_id, 
    b.tital, 
    b.stock, 
    COALESCE(SUM(o.quantity), 0) AS order_quantity, 
    (b.stock - COALESCE(SUM(o.quantity), 0)) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.tital, b.stock 
ORDER BY b.book_id;

