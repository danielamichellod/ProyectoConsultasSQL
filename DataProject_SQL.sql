-- 2. Muestra los nombres de todas las películas con una clasificación por edades de 'R'
SELECT f."title" AS "nombre_películas",
	   f."rating" AS "clasificacion"
FROM film AS f 
WHERE f."rating" = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT a."actor_id" AS "id_actor",
	   a. "first_name" AS "nombre",
	   a. "last_name" AS "apellido"  
FROM actor AS a
WHERE a."actor_id" BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
-- correccion aportada
SELECT f."title" AS "películas",
	   f."original_language_id" AS "idioma_original",
	   f."language_id" AS "idioma"
FROM film AS f 
WHERE f."language_id" = f."original_language_id"
OR f."original_language_id" IS NULL;

-- 5. Ordena las películas por duración de forma ascendente.
SELECT f."title" AS "película",
	   f."length" AS "duración"
FROM film AS f 
ORDER BY f."length" ASC;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido. 
-- correccion aportada
SELECT a."first_name" AS "nombre",
	   a."last_name" AS "apellido"
FROM actor AS a 
WHERE a."last_name" ILIKE '%allen%'; 

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla "film" y muestra la clasificación junto con el recuento. 
SELECT f."rating" AS "clasificación", 
       COUNT("rating") AS "cantidad_total_películas"
FROM film AS f
GROUP BY f."rating";

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT f."title" AS "películas",
	   f."rating" AS "clasificación"
FROM film AS f 
WHERE f."rating" = 'PG-13' OR f."length" > 180; -- rating = 'PG-13': selecciona películas con esa clasificación, length > 180: selecciona películas cuya duración es mayor a 180 minutos (3 horas), OR: se cumple si al menos una de las condiciones es verdadera. 

-- 9.Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT ROUND(VARIANCE("replacement_cost"),2) AS "variabilidad reemplazo películas", -- el resultdo de 36.61 es una medida bastante alta que nos indica que hay bastante dispersión entre los valores de "replacement_cost".
       ROUND(STDDEV("replacement_cost"), 2) AS "desviación estándar" -- si añadimos la desviación estándar a la consulta, podemos ver que los precios de reemplazo se desvían unos 6.05 unidades monetarias de la media.
FROM film AS f;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT MIN("length") AS "menor duración",
	   MAX("length") AS "mayor duración"
FROM film AS f;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
-- correccion aportada
SELECT f."title" AS "película",
	   r."rental_date" AS "fecha alquiler",
	   f."rental_rate" AS "coste alquiler"
FROM rental AS r
JOIN inventory AS i ON r."inventory_id" = i."inventory_id"
JOIN film AS f ON i."film_id" = f."film_id"
ORDER BY r."rental_date" ASC -- para esta consulta, la ordenación por día también podría ser de forma descendente. He decidido seguir adelante con una ordenación ascendente, pero en función de los datos que le interesan al cliente podemos cambiar la consulta.
OFFSET 997 -- he usado una alternativa más simple al saber cuántas películas hay en total, he podido restarle el número correspondiente para llegar al antepenúltimo alquiler.  
LIMIT 1;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
SELECT f."title" AS "película",
	   f."rating" AS "clasificación"
FROM film AS f
WHERE f."rating" NOT IN ('NC-17','G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT f."rating" AS "clasificación",
       ROUND(AVG("length"),2) AS "promedio duración"
FROM film AS f 
GROUP BY f."rating";

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos. 
SELECT f."title" AS "películas",
       f."length" AS "duración"
FROM film AS f
WHERE f."length" > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM("amount") AS "total ingresos"
FROM payment AS p;

-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT c."customer_id" AS "valor id",
       c."first_name" AS "nombre", -- he querido añadir el nombre y apellido del cliente para que se vean más datos. 
       c."last_name" AS "apellido"
FROM customer AS c 
ORDER BY c."customer_id" DESC
LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
-- correccion aportada
SELECT a."first_name" AS "nombre",
	   a."last_name" AS "apellido",
	   f."title" AS "película"
FROM actor AS a 
JOIN film_actor AS fa ON fa.actor_id = a.actor_id -- para realizar esta consulta, es necesario hacer un JOIN entre las tablas "film","film_actor" y "actor".
JOIN film AS f ON f.film_id = fa.film_id
WHERE f."title" ILIKE 'egg igby';

-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT f."title" AS "película"
FROM film AS f
ORDER BY f."title" ASC; -- he decidido añadir una ordenación alfabética para facilitar la lectura. 

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
SELECT f."title" AS "película",
       f."length" AS "duración",
       c."name" AS "tipo película"
FROM film AS f
INNER JOIN film_category AS fc ON fc.film_id = f.film_id -- para realizar esta consulta, es necesario hacer un JOIN entre las tablas "film","film_category" y "category".
INNER JOIN category AS c ON c.category_id = fc.category_id
WHERE c."name" = 'Comedy'
AND f."length" > 180;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c."name" AS "tipo película",
       ROUND(AVG(f."length"),2) AS "promedio duración" -- en esta parte se calcula el promedio de duración (AVG(f."length")) y lo redondeamos a dos decimales.
FROM film AS f
INNER JOIN film_category AS fc ON fc.film_id = f.film_id -- para realizar esta consulta, es necesario hacer un JOIN entre las tablas "film","film_category" y "category".
INNER JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c."name"
HAVING avg(f."length") > 110 -- en esta parte se retoma el promedio de duración (AVG(f."length")) y luego lo filtramos con (>110) las categorías cuyo promedio es mayor a 110 minutos.
ORDER BY "promedio duración" ASC;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT ROUND(AVG("rental_duration"),1) AS "media_duración_alquiler" -- lo hemos redondeado a una decimal ya que hablamos de días de alquiler. 
FROM film AS f;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices. 
SELECT CONCAT("first_name",' ',"last_name") AS "nombre_completo" -- esta línea une el nombre y el apellido con un espacio entre ellos.
FROM actor AS a 
ORDER BY nombre_completo ASC;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT rental_date::date AS "fecha alquiler", -- al hacer rental_date::date, descartamos la parte de la hora en la fecha.
       COUNT(r."rental_id") AS "cantidad de alquiler" -- cuenta cuántos alquileres se hicieron en una fecha determinada. 
FROM rental AS r 
GROUP BY rental_date::date -- agrupamos los alquileres por fecha.
ORDER BY "cantidad de alquiler"  DESC; -- mostramos primero los días con más alquileres.

-- 24. Encuentra las películas con una duración superior al promedio.
SELECT f."title" AS "películas",
	   f."length" AS "duración"
FROM film AS f
WHERE f."length" > (
       SELECT ROUND(AVG("length"),2)
       FROM film AS f
       );

-- 25. Averigua el número de alquileres registrados por mes.
-- correccion aportada
SELECT "mes de alquiler",
	   COUNT(*) AS "número de alquileres" -- en la consulta principal, contamos el resumen de alquileres.
FROM (
       SELECT r."rental_id" AS "alquiler id", -- la subconsulta nos ayuda a determinar todos los alquileres registrados por mes.
	          TO_CHAR(r."rental_date", 'YYYY-MM') AS "mes de alquiler" -- TO_CHAR nos ayuda a convertir la fecha de alquiler a formato AÑO-MES.
       FROM rental AS r 
       INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id -- para realizar esta consulta, es necesario hacer un JOIN entre las tablas "film","inventory_id" y "rental_id".
       INNER JOIN film AS f ON f.film_id = i.film_id
      ) AS "resumen alquileres"
GROUP BY "mes de alquiler" -- agrupa todos los alquileres por cada mes
ORDER BY "mes de alquiler"; -- ordena los resultados cronológicamente

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado. 
SELECT ROUND(AVG(p."amount"),2) AS "promedio pago",
       ROUND(STDDEV(p."amount"),2) AS "desviación estándar pago",
       ROUND(VARIANCE(p."amount"),2) AS "varianza pago"
FROM payment AS p;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
SELECT f."title" AS "películas",
       f."rental_rate" AS "precio alquiler películas"
FROM film AS f 
WHERE f."rental_rate" > (  -- filtramos por las películas que se encuentran por encima del precio medio.   
      SELECT ROUND(AVG(f."rental_rate"),2) -- calculamos el precio medio de alquiler de las películas.
      FROM film AS f 
      )
ORDER BY f."rental_rate" ASC;

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT a."actor_id" AS "id actores",
       a."first_name" AS "nombre",
       a."last_name" AS "apellido",
       COUNT(fa."film_id") AS "número de películas" -- contamos cuántas películas tiene cada actor.
FROM actor AS a 
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id -- necesitamos unir estas dos tablas para relacionar los actores con las películas.
GROUP BY a."actor_id", a."first_name", a."last_name" -- agrupamos por los datos del actor para mostrar su nombre junto con el número de películas.
HAVING COUNT(fa."film_id") > 40 -- filtramos con HAVING para obtener solo los que tengan más de 40 películas.
ORDER BY "número de películas" ASC;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
-- correccion aportada
SELECT f."title" AS "películas",
       COUNT(i."inventory_id") AS "cantidad disponible" -- contamos cuántas copias hay en el inventario de cada película.
FROM film AS f 
LEFT JOIN inventory AS i ON i.film_id = f.film_id -- usamos el INNER JOIN porque nos va a devolver solo películas que tienen al menos una copia en el inventory. 
GROUP BY f."title"
ORDER BY "cantidad disponible" ASC;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT a."first_name" AS "nombre",
       a."last_name" AS "apellido",
       COUNT(fa."film_id") AS "número de películas" -- contamos cuántas películas tiene cada actor.
FROM actor AS a
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id -- unimos actor con film_actor para relacionar actores con películas.
GROUP BY a."first_name", a."last_name"
ORDER BY "número de películas" ASC;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT f. "title" AS "películas",
       a."first_name" AS "nombre",
       a."last_name" AS "apellido"
FROM film AS f 
LEFT JOIN film_actor AS fa ON f.film_id = fa.film_id -- usamos un LEFT JOIN para incluir todas las películas, incluso si no tienen actores asignados. Si la película no tiene actores, las columnas de actor saldrán con NULL. En este caso, vemos que hay tres películas con el valor NULL. 
LEFT JOIN actor AS a ON a.actor_id = fa.actor_id
ORDER BY f."title", a."first_name", a."last_name"; -- ordenamos por título de película, luego por nombre y apellido. 

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT a."first_name" AS "nombre",
       a."last_name" AS "apellido",
       f."title" AS "películas"
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id -- usamos un LEFT JOIN para incluir todas los actores, incluso si no tienen películas asignadas. En este caso, vemos que no hay ningun actor con el valor NULL, eso quiere decir que todos los actores tienen películas asignadas.
LEFT JOIN film AS f ON f.film_id = fa.film_id
ORDER BY a.first_name, a.last_name, f.title; -- ordenamos por nombre, apellido y luego título de película.

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT f."title" AS "películas",
       r."rental_id" AS "id alquiler",
       r."rental_date" AS "fecha alquiler",
       r."return_date" AS "fecha retorno alquiler",
       r."inventory_id" AS "id inventario",
       r."customer_id" AS "id cliente",
       r."staff_id" AS "id trabajador",
       r."last_update" AS "última modificación" -- la consulta nos pide incluir todos los registros de alquiler.
FROM film AS f 
LEFT JOIN inventory AS i ON f.film_id = i.film_id -- usamos un LEFT JOIN para incluir todas las películas y todos los registros de alquiler, incluso los valores NULL.
LEFT JOIN rental AS r ON r.inventory_id = i.inventory_id
ORDER BY f.title;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c."first_name" AS "nombre",
       c."last_name" AS "apellido",
       SUM(p."amount") AS "total gastado" -- calcula la suma total de dinero que ha pagado cada cliente.
FROM payment AS p
INNER JOIN customer AS c ON c.customer_id = p.customer_id -- hacemos un INNER JOIN para obtener los datos del cliente junto con sus pagos.
GROUP BY c.first_name, c.last_name --agrupamos estas columnas para asegurarnos que los dtos de nombre y apelliod correspondan correctamente a cada cliente. 
ORDER BY "total gastado" DESC -- ordenamos de forma descendente para que aparezcan primero los clientes que más dinero han pagado. 
LIMIT 5; -- nos devuelve solo los 5 clientes que más han gastado.

-- 35. Selecciona todos los actores cuyo primer nombre es ' Johnny'.
-- correccion aportada
SELECT a."first_name" AS "nombre",
       a."last_name" AS "apellido"
FROM actor AS a 
WHERE a."first_name" ILIKE  'johnny'
ORDER BY apellido;

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT a."first_name" AS "Nombre",
       a."last_name" AS "Apellido"
FROM actor AS a;

-- en esta consulta no tengo claro si hay que renombrar la columna usando un alias (he estado usándolo desde el principio) o si hay que renombrar la columna en la tabla original. Si es la segunda opción se hace de la forma siguiete:
-- ALTER TABLE actor
-- RENAME COLUMN first_name TO Nombre;

-- ALTER TABLE actore
-- RENAME COLUMN last_name TO Apellido;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN(a."actor_id") AS "actor más bajo",
       MAX(a."actor_id") AS "actor más alto"
FROM actor AS a; 

-- 38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(a."actor_id") AS "total actores" -- primera opción, seleccionamos el actor_id ya que sabemos que es propio a cada actor y no se puede repetir.  
FROM actor AS a;

SELECT COUNT(*) AS total_actores -- segunda opción, seleccionamos todas las filas de la tabla actor para hacer el recuento. 
FROM actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT a."last_name" AS "apellido",
       a."first_name" AS "nombre"
FROM actor AS a 
ORDER BY a."last_name" ASC;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT f."title" AS "películas"
FROM film AS f 
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
-- en este caso hay tres nombres más repetidos: Kenneth, Penelope y Julia (4 veces).  
SELECT a."first_name" AS "nombre",
       COUNT(a."actor_id") AS "cantidad de actores" -- contamos cuántos actores tienen ese nombre.
FROM actor AS a 
GROUP BY a."first_name" -- agrupamos los actores por nombres
ORDER BY "cantidad de actores" DESC;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron. 
SELECT r."rental_id" AS "id alquiler",
       r."rental_date" AS "fecha alquiler",
       c."first_name" AS "nombre",
       c."last_name" AS "apellido"
FROM rental AS r
INNER JOIN customer AS c ON c.customer_id = r.customer_id;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT c."customer_id" AS "id cliente",
       c."first_name" AS "nombre",
       c."last_name" AS "apellido",
       r."rental_id" AS "id alquiler",
       r."rental_date" AS "fecha alquiler"
FROM customer AS c 
LEFT JOIN rental AS r ON r.customer_id = c.customer_id -- usamos un LEFT JOIN para incluir columnas de alquiler que puedan tener el valor NULL porque el cliente no ha realizado ningun alquiler. En este caso, todos los clientes han realizado por lo menos un alquiler. 
ORDER BY "id cliente";

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT *
FROM film AS f
CROSS JOIN category AS c ;

-- El CROSS JOIN muestra todas las combinaciones posibles entre películas y categorías, sin importar su relación real. No considero que aporta valor a la consulta ya que no refleja datos reales, no nos dice qué categoría pertenece a qué película. Genera un volumen enorme de datos y no responde a una necesidad práctica.

-- 45. Encuentra los actores que han participado en películas de la categoría "Action".
SELECT DISTINCT a."first_name" AS "nombre", -- DISTINCT evita que un mismo actor aparezca varias veces si actuó en varias películas de acción.
 				a."last_name" AS "apellido",
 				c."name" AS "categoría"
FROM actor AS a
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id -- esto nos da en qué películas ha participado cada actor.
INNER JOIN film AS f ON f.film_id = fa.film_id -- esto nos da en qué películas específicas ha trabajado cada actor. Obtenemos los datos completos de cada película.
INNER JOIN film_category AS fc ON fc.film_id = f.film_id -- esto nos dice a qué categorías pertenece cada película.
INNER JOIN category AS c ON c.category_id = fc.category_id -- con esto podemos aplicar el WHERE para filtrar la categoía.
WHERE c."name" = 'Action' -- para obtener solo las películas que pertenecen a la categoría "Action".
ORDER BY a."first_name";

-- 46. Encuentra todos los actores que no han participado en películas.
SELECT a."first_name" AS "nombre",
       a."last_name" AS "apellido"
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
WHERE fa."film_id" IS NULL;

-- en esta columna, no obtenemos ningun nombre de actor lo que indica que todos han participado en películas. Esto también coincide con el resultado que tuvimos en la consulta 32.

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT a."first_name" AS "nombre",
       a."last_name" AS "apellido",
       COUNT(fa."film_id") AS "cantidad de películas" -- cuenta cuántas películas tiene ese actor.
FROM actor AS a
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id -- une cada actor con sus películas.
GROUP BY a.first_name, a.last_name -- agrupa por actor para poder contar correctamente. 
ORDER BY nombre;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW "actor num peliculas" AS 
SELECT a."actor_id" AS "id actor",
       CONCAT(a."first_name", ' ', "last_name") AS "actor",
       COUNT(fa."film_id") AS "cantidad de películas"
FROM actor AS a
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

SELECT *
FROM "actor num peliculas" AS anp; -- podemos consultar nuestra query como si fuera una tabla.

-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT c."first_name" AS "nombre",
       c."last_name" AS "apellido",
       COUNT(r."rental_id") AS "total alquileres" -- cuenta cuántos alquileres han realizado.
FROM customer AS c
INNER JOIN rental AS r ON r.customer_id = c.customer_id -- une cada cliente con sus alquileres. 
GROUP BY c.first_name, c.last_name
ORDER BY "total alquileres" DESC;

-- 50. Calcula la duración total de las películas en la categoría "Action".
SELECT SUM(f."length") AS "duración total" -- suma la duración (en minutos) de todas las películas.
FROM film AS f
INNER JOIN film_category AS fc ON fc.film_id = f.film_id -- nos sirve para saber a qué categorías pertenece cada película.
INNER JOIN category AS c ON c.category_id = fc.category_id -- nos sirve para obtener el nombre real de la categoría en lugar de solo el ID.
WHERE c."name" = 'Action'; -- filtra solo las de la categoría "Action".

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
CREATE TEMP TABLE "cliente rentas temporal" AS -- solo vive durante la  durante la sesión actual: se elimina automáticamente cuando cierras la conexión con la base de datos.
SELECT c."first_name" AS "nombre",
       c."last_name" AS "apellido",
       COUNT(r."rental_id") AS "total alquileres"
FROM customer AS c 
INNER JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name;

SELECT *
FROM "cliente rentas temporal" AS crt
ORDER BY "total alquileres" DESC;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
CREATE TEMP TABLE "peliculas alquiladas" AS
SELECT f."title" AS "películas",
       COUNT(r."rental_id") AS "total alquileres" -- cuenta cuántas veces se alquiló cada una.
FROM film AS f 
INNER JOIN inventory AS i ON i.film_id = f.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id -- los JOINs conectan las películas con sus alquileres.
GROUP BY f.title -- agrupa por película.
HAVING COUNT(r."rental_id") >= 10; -- filtra solo las que tienen 10 o más alquileres.

SELECT *
FROM "peliculas alquiladas" AS pa
ORDER BY "total alquileres" DESC;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
-- correccion aportada
SELECT DISTINCT f."title" AS "películas", -- evita títulos duplicados si alquiló la misma película más de una vez sin devolverla.
                CONCAT(c."first_name", ' ', c."last_name") AS "nombre",
                r."return_date" AS "fecha de devolución"
FROM customer AS c
INNER JOIN rental AS r ON r.customer_id = c.customer_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id -- los JOINs conectan el cliente con el alquiler, el inventario y las películas.
WHERE c."first_name" ILIKE  'tammy'
  AND c."last_name" ILIKE 'sanders' -- selecciona al cliente específico.
  AND r."return_date" IS NULL -- filtra los alquileres no devueltos.
ORDER BY f."title";

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a."last_name" AS "apellido", -- evita que un actor aparezca más de una vez si actuó en varias películas Sci-Fi.
                a."first_name" AS "nombre",
                c."name" AS "categoría"
FROM actor AS a
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id
INNER JOIN film AS f ON f.film_id = fa.film_id
INNER JOIN film_category AS fc ON fc.film_id = f.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id -- conecta cada actor con sus películas, y esas películas con sus categorías.
WHERE c."name" = 'Sci-Fi' -- filtra solo las películas de ciencia ficción.
ORDER BY a.last_name, a. first_name;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
WITH "fecha primera renta" AS (
      SELECT MIN(r."rental_date") AS "primera fecha" -- usamos MIN para encontrar la fecha más antigua entre todos los alquileres de esa película.
      FROM film AS f
      INNER JOIN inventory AS i ON f.film_id = i.film_id 
      INNER JOIN rental AS r ON i.inventory_id = r.inventory_id -- tenemos que seguir el camino film → inventory → rental para llegar desde el título hasta la fecha del alquiler.
      WHERE f."title" = 'Spartacus Cheaper'
   ),
   "peliculas despues" AS ( -- aqui queremos encontrar todos los film_id de películas que fueron alquiladas después de la fecha obtenida en el paso anterior. 
      SELECT DISTINCT i."film_id" -- usamos DISTINCT para evitar duplicados si una película fue alquilada varias veces.
      FROM inventory AS i
      INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
      INNER JOIN "fecha primera renta" AS fpr ON r.rental_date > fpr."primera fecha"
    ),
    "actores resultados" AS ( -- queremos unir los actores con la tabla film_actor que relaciona actores con películas. Se filtra solo por películas incluidas en la CTE peliculas_despues, o sea, películas alquiladas después de 'Spartacus Cheaper'.
      SELECT DISTINCT a."first_name" AS "nombre", -- DISTINCT asegura que un actor aparezca solo una vez.
                      a."last_name" AS "apellido"
      FROM actor AS a
      INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
      INNER JOIN "peliculas despues" AS pd ON fa.film_id = pd."film_id"
    )
 SELECT * -- muestra la lista de nombres y apellidos de los actores encontrados. En este caso, no hay ningun actor. Los datos nos indican que no hay actores que hayan actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez.
 FROM "actores resultados" AS ar
 ORDER BY apellido, nombre;
      
-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT a."first_name" AS "nombre",
       a."last_name" AS "apellido"
FROM actor AS a
WHERE a."actor_id" NOT IN ( -- el WHERE ... NOT IN filtra para incluir sólo actores cuyo actor_id no esté dentro del conjunto que devuelve la subconsulta.
      SELECT DISTINCT fa."actor_id" -- DISTINCT elimina actores repetidos si actuaron en varias películas de esa categoría.
      FROM film_actor AS fa
      INNER JOIN film AS f ON fa.film_id = f.film_id -- da información sobre las películas.
      INNER JOIN film_category AS fc ON f.film_id = fc.film_id -- conecta películas con categorías.
      INNER JOIN category AS c ON fc.category_id = c.category_id -- tiene los nombres de las categorías.
      WHERE c."name" = 'Music' -- asegura que sólo consideramos películas de esa categoría.
    ) -- Aquí buscamos todos los actor_id de los actores que han actuado en películas categorizadas como 'Music'.
ORDER BY a.first_name;

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT f."title" AS "películas" -- DISTINCT para que cada título aparezca solo una vez, aunque haya múltiples alquileres largos.
FROM rental AS r
INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
INNER JOIN film AS f ON f.film_id = i.film_id
WHERE (r.return_date - r.rental_date ) > INTERVAL '8 days' -- calculamos la duración del alquiler y luego comparamos si esa duración es mayor a 8 días.
ORDER BY f.title;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT f."title" AS "películas",
       c."name" AS "categoría"
FROM film AS f
INNER JOIN film_category AS fc ON fc.film_id = f.film_id -- relaciona cada película con sus categorías.
INNER JOIN category AS c ON c.category_id = fc.category_id -- tiene los nombres de las categorías.
WHERE c."name" = 'Animation'
ORDER BY f.title;

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
SELECT f."title" AS "películas", -- la consulta principal busca todas las películas con esa misma duración. En este caso, no hay otras películas con esa misma duración.
       f."length" AS "duración"
FROM film AS f
WHERE length = ( -- la subconsulta obtiene la duración de 'Dancing Fever'.
     SELECT f."length"
     FROM film AS f
     WHERE title = 'Dancing Fever'
     LIMIT 1
    )
 ORDER BY f.title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c."last_name" AS "apellido",
       c."first_name" AS "nombre"
FROM customer AS c
INNER JOIN rental AS r ON r.customer_id = c.customer_id
INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c."last_name";

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c."name" AS "categoría",
	   COUNT(r."rental_id") AS "recuento alquileres" -- cuenta cuántos registros de alquiler hay por categoría.
FROM category AS c
INNER JOIN film_category AS fc ON fc.category_id = c.category_id -- relaciona categorías con películas mediante category_id.
INNER JOIN film AS f ON f.film_id = fc.film_id -- relaciona la categoría a las películas que pertenecen a ella.
INNER JOIN inventory AS i ON i.film_id = f.film_id -- relaciona la película a sus copias específicas en las tiendas.
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id -- podemos contar cuántas veces fue alquilada una película (por categoría).
GROUP BY c."name"
ORDER BY "recuento alquileres" ASC;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT c."name" AS "categoría",
       COUNT(f."film_id") AS "cantidad películas",
       f."release_year" AS "año estreno"
FROM film AS f 
INNER JOIN film_category AS fc ON fc.film_id = f.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
WHERE f."release_year" = 2006 -- filtra solo las películas que fueron estrenadas en el año 2006.
GROUP BY c."name", f."release_year"
ORDER BY "cantidad películas" ASC;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT s."first_name" AS "nombre",
       s."last_name" AS "apellido",
       st."store_id" AS "id tienda"
FROM staff AS s 
CROSS JOIN store AS st -- genera todas las combinaciones posibles entre empleados y tiendas. 
ORDER BY st."store_id";

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c."customer_id" AS "id cliente",
       c."first_name" AS "nombre",
       c."last_name" AS "apellido",
       COUNT(r."rental_id") AS "total películas alquiladas" -- cuenta cuántos alquileres hizo cada cliente.
FROM customer AS c 
INNER JOIN rental AS r ON r.customer_id = c.customer_id -- une los clientes con sus alquileres.
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "total películas alquiladas" ASC;

