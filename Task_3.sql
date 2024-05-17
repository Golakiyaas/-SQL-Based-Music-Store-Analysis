--Q1. Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent
--here cost we consider is not total cost of invoice but we need no take quantity and Unitprice.
-- 1st we create Common Table Expression (CTE) for store our data that we make using join and we use later.
with best_selling_artist as (
	select artist.artist_id as artist_id, artist.name as artist_name,
	sum (invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
-- select 1 , 2 , 3 from invoice_line // so here i used 1,2,3 for make our Query more shorter and easy 
	join track on track.track_id=invoice_line.track_id
	join album on album.album_id=track.album_id
	join artist on artist.artist_id=album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
	
select customer.customer_id, customer.fullname,
best_selling_artist.artist_name, 
sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
from invoice

join customer on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track  on track.track_id=invoice_line.track_id
join album  on album.album_id=track.album_id
join best_selling_artist on best_selling_artist.artist_id=album.artist_id
	
group by 1,2,3
order by 4 desc;

--Q2.We want to find out the most popular music Genre for each country. We determine the 
--most popular genre as the genre with the highest amount of purchases. Write a query 
--that returns each country along with the top Genre. For countries where the maximum 
--number of purchases is shared return all Genres
with popular_genre as(
	select count(invoice_line.quantity) as purchase, customer.country,genre.name as genre_name, genre.genre_id,
-- row number used because, we have different country and after one country row number starting again from 1
--so from this i find easyly number of genre_name for easy understand run only CTE
row_number()
over(partition by customer.country order by count(invoice_line.quantity) desc) as Rowno
from invoice_line
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 2,3,4
order by 2 asc,1 desc
)
select*from popular_genre where Rowno<=1

--Q3. Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amount
with customer_spent_with_country as (
	select customer.customer_id,customer.fullname,invoice.billing_country,sum(total) as total_money_spending,
	row_number()
	over(partition by billing_country order by sum(total) desc) as Rowno
	from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3
	order by 3 asc, 4 desc
)
select * from customer_spent_with_country where Rowno <= 1

--For my knowledge recall, I also used method 2 with a 'RECURSIVE' function. 
-- so here i will use 'RECURSIVE' fun that is also one of the type of CTE but o/p of query 2 is depend on o/p of query 1.
with RECURSIVE 
            customer_spent_with_country as(
	select customer.customer_id,customer.fullname,invoice.billing_country,sum(total) as total_money_spending
	from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3
	order by 1,4 desc
			),
country_maximum_spending as (
	select billing_country, max(total_money_spending) as max_spending
	from customer_spent_with_country
	group by billing_country
)

select csc.billing_country,csc.total_money_spending,csc.fullname,csc.customer_id
from customer_spent_with_country csc
join country_maximum_spending cms
on csc.billing_country=cms.billing_country
where csc.total_money_spending=cms.max_spending
order by 1;