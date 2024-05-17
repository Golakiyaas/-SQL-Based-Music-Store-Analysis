--Q1.Who is the senior most employee based on job title?

--ALTER TABLE employee
--ADD COLUMN fullname VARCHAR(255);
--add one coloumn that give full name
--UPDATE employee
--SET fullname = concat(TRIM(first_name), ' ', TRIM(last_name));
--used trim fun for remove white space and add first and last name in coloumn

SELECT * FROM employee
order by levels desc
	--arranged in descending order
limit 1

--Q2.Which countries have the most Invoices?
--select*from invoice
select count(*) as c,billing_country from invoice
--do count of all invoice but need this count based in country so do grouping by countries
group by billing_country
order by c desc

--Q3.What are top 3 values of total invoice?
select invoice_id,customer_id,total from invoice
order by total desc
limit 3

--Q4.Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
select sum(customer_id) as customer_total,sum(total) as invoice_total,billing_city from invoice
group by billing_city
order by invoice_total desc

--Q5.Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most mone
--alter table customer ADD COLUMN fullname VARCHAR(255);
--update customer set fullname=concat(trim(first_name),' ',trim(last_name));
select customer.customer_id,customer.fullname, sum(invoice.total) as total from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1
