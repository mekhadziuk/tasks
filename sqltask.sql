-- first
SELECT category.name AS category,
COUNT(*) AS count
FROM film_category
INNER JOIN category USING(category_id)
GROUP BY category
ORDER BY count DESC;


-- second
SELECT actor.first_name, actor.last_name
FROM rental
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
GROUP BY actor.first_name, actor.last_name
ORDER BY COUNT(*) DESC
LIMIT 10;


-- third
SELECT category.name AS category
FROM payment
INNER JOIN rental USING (rental_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
GROUP BY category
ORDER BY SUM(amount) DESC
LIMIT 1;


-- fourth
SELECT title
FROM film
LEFT JOIN inventory USING (film_id)
WHERE inventory.film_id IS NULL;


-- fifth
SELECT first_name, last_name
FROM (SELECT actor.first_name, actor.last_name,
RANK() OVER(PARTITION BY category.name
ORDER BY COUNT(*) DESC) AS num
FROM actor
INNER JOIN film_actor USING (actor_id)
INNER JOIN film USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
GROUP BY first_name, last_name, category.name
HAVING category.name = 'Children') AS res
WHERE num <= 3;


-- sixth
SELECT city,
COUNT(CASE WHEN active = 1 THEN active ELSE NULL END) AS active_count,
COUNT(CASE WHEN active = 0 THEN active ELSE NULL END) AS no_active_count
FROM city
INNER JOIN address USING (city_id)
INNER JOIN customer USING (address_id)
GROUP BY city
ORDER BY no_active_count DESC;


-- seventh
SELECT city, category_name
FROM (SELECT city, category.name AS category_name, ROW_NUMBER()
OVER(PARTITION BY city ORDER BY SUM(rental_duration) DESC) AS num
FROM customer
INNER JOIN address USING (address_id)
INNER JOIN city USING (city_id)
INNER JOIN inventory USING (store_id)
INNER JOIN film USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE city LIKE 'A%'
   OR city LIKE 'a%'
   OR city LIKE '%-%'
GROUP BY city, category_name) AS task
WHERE num = 1;
