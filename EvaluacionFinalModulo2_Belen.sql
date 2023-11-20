/* 1.Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/
USE SAKILA;

SELECT DISTINCT 
title AS Título
FROM film;

/* 2.Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/
SELECT 
title as Título
FROM film 
WHERE rating = 'PG-13';

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/

SELECT 
title AS Título,
description AS Descripción
FROM film f
WHERE f.description LIKE "%amazing%";

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT 
title AS Título
FROM film
WHERE length >120;

/* 5. Recupera los nombres de todos los actores.*/
SELECT 
first_name AS Nombre,
last_name as Apellido
FROM actor;

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT 
	first_name AS Nombre,
    last_name AS Apellido
FROM actor
WHERE last_name LIKE '%Gibson%';

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

SELECT 
first_name AS Nombre,
actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/
SELECT 
	title AS Título,
    rating AS Clasificacion
FROM film
WHERE rating NOT IN('R','PG-13');

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.*/

SELECT 
	c.name AS Categoria,
    COUNT(film_id)AS Cantidad_Total
FROM film_category fc
INNER JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas. */

SELECT
	c.customer_id AS ID_Cliente,
    c.first_name AS Nombre,
    c.last_name AS Apellido,
    COUNT(r.rental_id) AS Cantidad_Peliculas_Alquiladas
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY Cantidad_Peliculas_Alquiladas DESC;

/* 11. Encuentra la cantidad total de películas alquiladas por categoría 
y muestra el nombre de la categoría junto con el recuento de alquileres.*/

SELECT 
	ct.name AS Categoria,
    count(*) AS Numero_alquileres
FROM rental r
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
INNER JOIN film f
ON i.film_id = f.film_id
INNER JOIN film_category fc
ON F.film_id = fc.film_id
INNER JOIN category ct
ON fc.category_id = ct.category_id
GROUP BY ct.name 
ORDER BY Numero_alquileres DESC;

/* 12. Encuentra el promedio de duración de las películas para cada clasificación 
de la tabla film y muestra la clasificación junto con el promedio de duración.*/

SELECT 
	rating AS Clasificacion,
    AVG(length) as Promedio_duracion
FROM film
GROUP BY rating
ORDER BY Promedio_duracion DESC;

/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/

SELECT 
	first_name AS Nombre,
    last_name AS Apellido
FROM actor
WHERE actor_id IN(
	SELECT actor_id
	FROM film_actor
	WHERE film_id = (
		SELECT film_id
		FROM film 
		WHERE title='Indian Love'));

/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

SELECT 
	title AS Título
FROM film 
WHERE description LIKE '% dog %' OR description LIKE '% cat %';

/* 15.Hay algún actor que no aparecen en ninguna película en la tabla film_actor.*/


SELECT 
	a.first_name AS Nombre,
    a.last_name AS Apellido
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
	WHERE a.actor_id  NOT IN( fa.actor_id);
    
/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/

SELECT 
	title AS Título,
	release_year as Año_Lanzamiento
FROM film
WHERE release_year BETWEEN 2005 AND 2010
ORDER BY release_year;

/*17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/
WITH categoria_family AS (
	SELECT category_id
	FROM category
	WHERE name = 'Family')
    
SELECT 
	title AS Titulo
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
WHERE fc.category_id = (
	SELECT category_id FROM categoria_family
    ) ;


/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

SELECT 
	ac.first_name AS Nombre,
    ac.last_name AS Apellido,
    COUNT(fac.film_id) AS Numero_Peliculas
FROM actor as ac
INNER JOIN film_actor fac
ON ac.actor_id = fac.actor_id
GROUP BY
    ac.actor_id, ac.first_name, ac.last_name
HAVING COUNT(fac.film_id) > 10
ORDER BY Numero_Peliculas DESC;

/*19. Encuentra el título de todas las películas que son "R" y 
tienen una duración mayor a 2 horas en la tabla film.*/

SELECT 
	title AS Titulo
FROM film 
WHERE rating = 'R' AND length >120;

/*20 Encuentra las categorías de películas que tienen un promedio de duración 
superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración. */

SELECT
	category_id
FROM film_category
WHERE film_id in(
	SELECT 
		film_id 
	FROM film 
    WHERE length > 120
    );

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra 
el nombre del actor junto con la cantidad de películas en las que han actuado.*/

SELECT 
	ac.first_name AS Nombre,
    ac.last_name AS Apellido,
    COUNT(fac.film_id) AS Numero_Peliculas
FROM actor as ac
INNER JOIN film_actor fac
ON ac.actor_id = fac.actor_id
GROUP BY
    ac.actor_id, ac.first_name, ac.last_name
HAVING COUNT(fac.film_id) > 5
ORDER BY Numero_Peliculas ASC;

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
y luego selecciona las películas correspondientes.*/


SELECT DISTINCT
    film.title AS Titulo
FROM
    film
    INNER JOIN inventory ON film.film_id = inventory.film_id
    INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE
    rental.rental_id IN (
        SELECT
            rental_id
        FROM
            rental
        WHERE
            rental_duration > 5
    );


/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna 
película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores 
que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/


SELECT DISTINCT 
first_name AS Nombre,
last_name AS Apellido
FROM actor ac
INNER JOIN film_actor fac
ON ac.actor_id = fac.actor_id
WHERE fac.actor_id NOT IN(
	SELECT category_id
	FROM category
	WHERE name = 'Horror');

/*24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.*/

WITH cat_comedy AS (
    SELECT category_id
    FROM category
    WHERE name = 'Comedy'
),
duracion AS (
    SELECT *
    FROM film
    WHERE length > 180
)
SELECT
    title AS Titulo,
    length AS Duracion
FROM
    film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
WHERE
    fc.category_id = (SELECT category_id FROM cat_comedy)
HAVING
    Duracion in (SELECT length FROM duracion);

/*25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
La consulta debe mostrar el nombre y apellido de los actores y el número de películas en 
las que han actuado juntos. */

-- NOTA: Se que se resuelve con self join porque lo he visto en internet pero prefiero no copiarlo.




