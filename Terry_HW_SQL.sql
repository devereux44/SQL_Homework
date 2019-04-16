USE Sakila;

/* 1a */

SELECT first_name, last_name
FROM actor;

/* 1b */

SELECT concat(first_name, " ",last_name) as 'Actor Name'
FROM actor;

/* 2a */

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

/* 2b */

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

/* 2c */

SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%';

/* 2d */

 SELECT country_id, country
 FROM country
 WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
 
 /* 3a */
 
 ALTER TABLE actor 
	ADD  description  BLOB;

 /* 3b */

ALTER TABLE actor
	DROP description;
    
/* 4a */

SELECT last_name, COUNT(*) as 'Last Name'
FROM actor
GROUP BY last_name;

/* 4b */

SELECT last_name, COUNT(*) as 'Last Name'
FROM actor
GROUP BY last_name
HAVING `Last Name` > 1;

/* 4c */

SET SQL_SAFE_UPDATES = 0;

UPDATE actor
SET first_name = REPLACE(first_name, 'GROUCHO', 'Harpo')
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SET SQL_SAFE_UPDATES = 1;

/* 4d */

SET SQL_SAFE_UPDATES = 0;

UPDATE actor
SET first_name = REPLACE(first_name, 'Harpo', 'GROUCHO')
WHERE first_name = 'Harpo' AND last_name = 'WILLIAMS';

SET SQL_SAFE_UPDATES = 1;

/* 5a */

SHOW CREATE TABLE address;

/* 6a */

create view `Staff_addresses` as 
select first_name, last_name, address, district, postal_code, city, country
from	staff
		INNER JOIN address USING (address_id)
        INNER JOIN city USING (city_id)
        INNER JOIN country USING (country_id);

select * from Staff_addresses;

/* 6b */
drop view `Staff_payment_collected`;
create view `Staff_payment_collected` as
select staff_id, first_name, last_name, amount
from	staff
		INNER JOIN payment USING (staff_id)
WHERE payment_date like '2005-08%';
SELECT * from staff_payment_collected;


 /* 6c */ 

CREATE VIEW `Actors_per_movie` as
SELECT  film_id, title
FROM film
INNER JOIN film_actor USING (film_id);

Select Title, count(title) as 'Num_Actors'
from Actors_per_movie
GROUP BY Title;

 /* 6d */ 

CREATE VIEW `Inventory_Count` as
SELECT  film_id, title
FROM film
INNER JOIN inventory USING (film_id);

Select Title, count(title)
from Inventory_Count
WHERE title = 'Hunchback Impossible';

 /* 6e */
 
CREATE VIEW `Customer_Spend` as
SELECT  customer_id, first_name, last_name, amount
FROM customer
INNER JOIN payment USING (customer_id);

SELECT first_name, last_name, SUM(amount) as 'Total Amount Paid'
FROM Customer_spend
GROUP BY first_name, last_name;

 /* 7a */
 
SELECT title, name as 'Language'
FROM film
INNER JOIN language USING (language_id)
WHERE title like 'Q%' or title like 'K%' AND name = 'English';

 /* 7b */
 
SELECT first_name, last_name
FROM actor act
WHERE actor_id in
(
  SELECT actor_id
  FROM film_actor 
  WHERE film_id in
  (
   SELECT film_id
   FROM film
   WHERE Title = 'Alone Trip'
  )
);

 /* 7c */
drop view customer_addresses;
create view `customer_addresses` as 
select first_name, last_name, address, district, postal_code, city, country
from	customer
		INNER JOIN address USING (address_id)
        INNER JOIN city USING (city_id)
        INNER JOIN country USING (country_id);

SELECT * 
From customer_addresses
WHERE country = 'Canada';

 /* 7d */
 
SELECT title
FROM film
WHERE film_id in
(
  SELECT film_id
  FROM film_category 
  WHERE category_id in
  (
   SELECT category_id
   FROM category
   WHERE name LIKE '%Family%'
  )
);

/* 7e */

drop view number_of_rentals;
create view `number_of_rentals` as 
select title, rental_date
FROM	film
		LEFT JOIN inventory USING (film_id)
        INNER JOIN rental USING (inventory_id);
        
SELECT title, COUNT(rental_date) as 'Number of Rentals'
FROM `number_of_rentals`
GROUP BY title
ORDER BY COUNT(*) Desc;


/* 7f */

CREATE VIEW `Rev_per_store` as 
select store_id, location, city, country, amount
FROM customer
	INNER JOIN payment USING (customer_id)
    INNER JOIN store USING (store_id)
	INNER JOIN address ON (address.address_id = store.address_id)
	INNER JOIN city USING (city_id)
	INNER JOIN country USING (country_id);
    
SELECT store_id, sum(amount)
FROM Rev_per_store
GROUP BY store_id;

/* 7g */

SELECT store_id, city, country
FROM Rev_per_store
GROUP BY store_id;

/* 7h + 8a + 8b + 8c */
CREATE VIEW `Rev_per_genre` as 
select name, amount
FROM category
	INNER JOIN film_category USING (category_id)
    INNER JOIN inventory USING (film_id)
	INNER JOIN rental USING (inventory_id)
	INNER JOIN payment USING (rental_id);
    
SELECT name, sum(amount)
FROM Rev_per_genre
GROUP BY name  
ORDER BY sum(amount) DESC
LIMIT 5;  

DROP VIEW `Rev_per_genre`;	