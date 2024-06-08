USE SAKILA;
-- Q1: How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(film_id)
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible')
;

-- Q2: List all films whose length is longer than the average of all the films.
SELECT 
    title, length
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film)
ORDER BY length
LIMIT 10
;

-- Q3: Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'))
;

-- Q4: Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'family'));
                    
-- Q5: Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT 
    first_name, last_name, email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')));
                            
-- Q6: Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_actor AS fa
                INNER JOIN
            (SELECT 
                actor_id, COUNT(film_id) AS film_total
            FROM
                film_actor
            GROUP BY actor_id
            ORDER BY film_total DESC
            LIMIT 1) AS sub ON sub.actor_id = fa.actor_id)
;

-- Q7:Películas alquiladas por el cliente más rentable. Puedes usar la tabla de clientes y la tabla de pagos para encontrar al cliente más rentable, es decir, el cliente que ha realizado la mayor suma de pagos.
-- inner join = usamos este join para buscar los valores que coinciden en la tabla de payments y la nueva table que estamos creando con la subconuslta.

SELECT title
FROM film
WHERE film_id IN
(SELECT film_id 
FROM inventory
WHERE inventory_id IN
(SELECT inventory_id FROM rental AS t3 
INNER JOIN 
(SELECT T2.customer_id, T2.rental_id AS rental_id ,T2.payment_id as payment_id
FROM payment AS T2
INNER JOIN (SELECT customer_id ,SUM(amount) AS total_amount, RANK() OVER(ORDER BY sum(amount) DESC) AS ranking FROM payment
GROUP BY customer_id
ORDER BY ranking
LIMIT 1) AS T1 ON T1.customer_id = T2.customer_id) as t4 on T4.rental_id = T3.rental_id))
;

-- Q8: Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT AVG(amount)
From payment;

 



