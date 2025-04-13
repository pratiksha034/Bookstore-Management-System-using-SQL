-- create database
create database sqlproject;

-- create table 

create table books(
Book_ID serial primary key,
Title varchar(100),	
Author varchar(100),	
Genre varchar(50),	
Published_Year int,	
Price numeric(10,2),	
Stock int 	
);

select * from books;

create table customers(
   Customer_ID	serial primary key,
	Name varchar(100),
	Email varchar(100),	
	Phone varchar(15),	
	City varchar(50),
	Country	varchar(50)	
);

select * from customers;

create table orders(
    Order_ID serial	primary key,
	Customer_ID	int references customers(customer_id),	
	Book_ID	int references books(book_id),	
	Order_Date date,
	Quantity int ,	
	Total_Amount numeric(10,2)	
);

select * from orders;

-- 1] retrive all books in  the 'Fiction' genre

select * from books 
where genre='fiction';

-- 2] find books published after the year 1950

select * from books 
where Published_Year>1950;

-- 3] list of all customers from the Canada

select * from customers 
where country='canada';

-- 4] show orders placed in November 2023
select * from orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5] Retrive the total stock of books available 
select sum(stock) as total_stock 
from books;

-- 6] Find the details of the expansive book
select * from books
where price=(select max(price) from books);

select * from books order by price desc limit 1;

-- 7] show all customers who ordered more than 1 quantity of a book
select * from orders
where quantity>1;
 
 -- 8] Retrive all orders where the total amount exceeds $20
 select * from orders
where Total_Amount>20;
 
-- 9] List of all genres available in the books table
select distinct(genre) from books;

-- 10] Find the book with lowest stock
select * from books
order by stock 
limit 1;

select * from books
where stock=(select min(stock) from books);

-- calculate the total revenue generated from all orders
select sum(total_amount) as total_revenue from orders;

-- Advance Queries

-- 1] Retrive the total number of books sold for each genre
select  sum(o.quantity) as total_book, b.genre
from books b
join orders o on b.book_id=o.book_id 
group by b.genre;

-- 2] Find the average price of books in the "Fantasy" genre
select avg(price) as avg_price from books
where genre='Fantasy';

-- 3] List customers who have placed at least 2 orders
select c.customer_id,c.name,count(order_id) as orders_count
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id
having count(order_id)>=2;

-- 4] Find the most frequently ordered book
select b.book_id,b.title, count(o.order_date) as order_count
from orders o
join books b on b.book_id=o.book_id
group by b.book_id
order by count(o.order_id) desc limit 1;

-- 5] show the top 3 most expansive books of 'Fantasy' Genre
select title,price,genre 
from books
where genre='fantasy'
order by price desc
limit 3;

-- 6] Retrive the total quantity of books sold by each author
select b.author,sum(o.quantity) as total_quantity
from books b
join  orders o on b.book_id=o.Book_ID
group by b.author;

-- 7] List the cities where customers who spent over $30 are loc
select distinct c.city,o.total_amount
from customers c
join orders o on c.Customer_ID=o.Order_ID
where o.Total_Amount>30;

-- 8] Find the customer who spent the most on orders
select c.customer_id,c.name,sum(o.total_amount) as total_spent
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_id , c.name
order by total_spent desc limit 1; 

-- 9] calculate the stock remaining after fulfilling all orfers
select b.book_id,b.title,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id;


