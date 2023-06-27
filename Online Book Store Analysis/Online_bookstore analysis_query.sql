create database Online_Bookstore;

use Online_Bookstore;
CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100),
    birth_date DATE,
    country VARCHAR(50)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200),
    publication_date DATE,
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    book_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

INSERT INTO Authors (author_id, author_name, birth_date, country)
VALUES
    (1, 'John Smith', '1978-05-10', 'USA'),
    (2, 'Emily Johnson', '1985-09-15', 'Canada'),
    (3, 'Sarah Johnson', '1990-06-20', 'USA'),
    (4, 'Michael Wilson', '1975-03-12', 'Australia');

INSERT INTO Books (book_id, title, publication_date, author_id)
VALUES
    (1, 'The Great Adventure', '2020-03-15', 1),
    (2, 'Mystery Unveiled', '2018-07-01', 1),
    (3, 'Journey to the Unknown', '2022-01-10', 2),
    (4, 'The Hidden Truth', '2021-09-05', 1),
    (5, 'Secrets of the Past', '2023-04-18', 3),
    (6, 'Beyond the Horizon', '2022-11-30', 4);
    
INSERT INTO Customers (customer_id, first_name, last_name, email)
VALUES
    (1, 'Alice', 'Brown', 'alice@example.com'),
    (2, 'Bob', 'Smith', 'bob@example.com'),
    (3, 'Charlie', 'Davis', 'charlie@example.com'),
    (4, 'Eve', 'Anderson', 'eve@example.com'),
    (5, 'Frank', 'Miller', 'frank@example.com'),
    (6, 'Grace', 'Thomas', 'grace@example.com');

INSERT INTO Orders (order_id, customer_id, book_id, order_date)
VALUES
    (1, 1, 1, '2022-05-20'),
    (2, 1, 2, '2023-01-05'),
    (3, 2, 3, '2023-06-15'),
    (4, 2, 4, '2023-03-10'),
    (5, 3, 5, '2023-06-20'),
    (6, 4, 6, '2023-06-25');
    
    
    
    
select * from authors;
select * from books;
select * from customers;
select * from orders;

/* Q1: Retrieve all books and their authors:*/

select b.title as book_title, a.author_name
from books b
join authors a on b.author_id = a.author_id;

/* Retrieve the total number of books published by each author:*/ 

select a.author_name, count(*) as book_count
from books b
join authors a on b.author_id = a.author_id
group by author_name;

/* Retrieve the list of customers who have placed orders:*/

select c.customer_id, c.first_name, c.last_name
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name;

/* Retrieve the number of books ordered by each customer: */

select c.customer_id, c.first_name, c.last_name, count(*) as book_count
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name;

/* Retrieve the customers who have ordered a specific book: 'Beyond the Horizon' */

select c.customer_id, c.first_name, c.last_name
from customers c
join orders o on c.customer_id = o.customer_id
join books b on b.book_id = o.book_id
where b.title like 'Beyond the Horizon';

/* Retrieve the authors who have not published any books: */

select a.author_name, b.author_id
from authors a
left join books b on a.author_id = b.author_id
where b.book_id is null;

/* Retrieve the books published in a specific year and their authors: where year is 2022 */ 

select a.author_id, b.title as book_title, a.author_name
from authors a
join books b on a.author_id = b.author_id
where year(publication_date) = '2022';

/* Retrieve the books ordered by a specific customer: where customer is Alice Brown*/

select c.customer_id, c.first_name, c.last_name, b.title as book_title
from books b
join orders o on o.book_id = b.book_id
join customers c  on o.customer_id = c.customer_id
where c.first_name = 'Alice' AND c.last_name = 'Brown';


/* Retrieve the customers who have placed more than one orders: */ 

select c.customer_id, c.first_name, c.last_name
from customers c
join orders o on o.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
having count(*) > 1;


/* Retrieve the books with their authors and the customers who have ordered them: */

select b.title as book_title, a.author_name, c.first_name, c.last_name
from books b
join authors a on a.author_id = b.author_id
join orders o on b.book_id = o.book_id
join customers c on c.customer_id = o.customer_id;
