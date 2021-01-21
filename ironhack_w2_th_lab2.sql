/* LAB-SQL-8*/
/*
1. Rank films by length (filter out the rows that have nulls or 0s in length column). 
In your output, only select the columns title, length, and the rank.
2. Rank films by length within the rating category (filter out the rows that have nulls or 0s in length column). 
In your output, only select the columns title, length, rating and the rank.
3. How many films are there for each of the categories in the category table. Use appropriate join to write this query
4. Which actor has appeared in the most films?
5. Most active customer (the customer that has rented the most number of films)
Bonus: Which is the most rented film? The answer is Bucket Brotherhood This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.
*/
Use sakila;
-- 1
SELECT film_id, title, DENSE_RANK() OVER (ORDER BY length) rank_length_movies
FROM film
WHERE length <> '' OR length IS NOT NULL;

-- 2
/*
2. Rank films by length within the rating category (filter out the rows that have nulls or 0s in length column). 
In your output, only select the columns title, length, rating and the rank.
*/
SELECT title, length, rating, RANK() OVER (ORDER BY length,rating) rank_length
FROM film
WHERE length <> '' OR length IS NOT NULL;

-- 3
/*
How many films are there for each of the categories in the category table. Use appropriate join to write this query
*/
SELECT c.category_id, c.name category_name, COUNT(i.film_id) n_films_x_cat
FROM category AS c
JOIN film_category AS fc
ON c.category_id = fc.category_id
JOIN inventory i
ON i.film_id = fc.film_id
JOIN film f
ON f.film_id = i.film_id
GROUP BY c.category_id, c.name
ORDER BY n_films_x_cat DESC;

-- 4
/*
Which actor has appeared in the most films?
*/
SELECT COUNT(fa.actor_id) actor_n_movies, a.first_name, a.last_name
FROM film_actor fa
JOIN actor a
ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id 
ORDER BY 1 DESC
LIMIT 1;

-- 5
/* 
Most active customer (the customer that has rented the most number of films)
*/
SELECT r.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) n_rentals
FROM rental r 
JOIN customer c
ON c.customer_id = r.customer_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 1;


-- 6
/*
Bonus: Which is the most rented film? 
The answer is Bucket Brotherhood 
This query might require using more than one join statement. 
Give it a try. We will talk about queries with multiple join statements later in the lessons.
*/ 
SELECT COUNT(r.rental_id),i.film_id, f.title
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
GROUP BY 2
ORDER BY 1 DESC
LIMIT 1;