-- Héctor Moreno Tejero

-- Batería de consultas 1:

-- 1 Muestra el nombre y el precio de aquellos artículos que sean, exactamente, el artículo más caro de su respectivo fabricante.

SELECT nombre_art, precio -
FROM articulos a
WHERE precio = (
	SELECT MAX(precio) 
	FROM articulos b
	WHERE a.id_fabri = b.id_fabri
)
;

-- 2 Muestra el nombre de los fabricantes que no tienen ningún 
-- artículo con un precio inferior o igual a la media general de precios de toda la tienda.

SELECT f.nombre_fabri
FROM fabricantes f
WHERE f.id_fabri NOT IN (
	SELECT a.id_fabri
	FROM articulos a
	WHERE a.precio <= (
		SELECT AVG(precio) 
		FROM articulos
));

-- 3 Muestra la descripción y el coste de aquellas reparaciones cuyo coste sea
-- estrictamente superior a la media de las reparaciones realizadas por su propio
-- técnico.

SELECT descripcion_averia, coste_reparacion
FROM reparaciones r1
WHERE coste_reparacion > (
	SELECT AVG(coste_reparacion)
	FROM reparaciones r2
	WHERE r1.id_tec = r2.id_tec
)
;

-- 4 Muestra el identificador y la especialidad de los técnicos cuya suma total del coste de
-- las reparaciones que han realizado supere el doble de su propio salario.

SELECT id_tec, especialidad
FROM tecnicos t
WHERE (salario * 2) < (
	SELECT SUM(coste_reparacion)
	FROM reparaciones r
	WHERE r.id_tec = t.id_tec
);

-- 5 Muestra el nombre del fabricante (o fabricantes) que posee el mayor número de 
-- artículos registrados en la base de datos.

SELECT f.nombre_fabri, COUNT(a.nombre_art)
FROM fabricantes f, articulos a
WHERE f.id_fabri = a.id_fabri
GROUP BY f.nombre_fabri
;

-- Me falta poner el máximo, no sé como hacerlo
 
-- 6 Muestra el nombre de los técnicos que han realizado alguna reparación, pero que
-- nunca han realizado ninguna reparación cuyo coste haya superado los 100.00 euros.

SELECT t.nombre_tec
FROM tecnicos t, reparaciones r
WHERE t.id_tec = r.id_tec
WHERE r.coste_reparacion < 100.00

-- 7 Muestra el nombre y el salario de los técnicos cuyo salario sea inferior a la media
-- salarial de su propia especialidad.

SELECT nombre_tec, salario
FROM tecnicos t1
WHERE salario < (
	SELECT AVG(salario)
	FROM tecnicos t2
	WHERE t2.especialidad = t1.especialidad
);

-- 8 Muestra el nombre de los fabricantes cuyo país coincide con el país del fabricante
-- que produce el artículo más caro de toda la tienda.
	
SELECT nombre_fabri
FROM fabricantes f
WHERE pais IN (
	SELECT pais
	FROM fabricantes
	WHERE id_fabri IN (
		SELECT id_fabri
		FROM articulos
		WHERE precio = (
			SELECT MAX(precio)
			FROM articulos
		)
	)
);

-- 9 Muestra el nombre y el precio del artículo más barato de entre todos los fabricantes
-- que son originarios de 'Estados Unidos'.

SELECT nombre_art, precio
FROM articulos
WHERE id_fabri IN (
    SELECT id_fabri
    FROM fabricantes
    WHERE pais LIKE 'Estados Unidos'
)
AND precio = (
    SELECT MIN(precio)
    FROM articulos
    WHERE id_fabri IN (
        SELECT id_fabri
        FROM fabricantes
        WHERE pais LIKE 'Estados Unidos'
    )
);

-- 10 Muestra el identificador del técnico (tecnico_id) que ha acumulado el mayor
-- coste total en reparaciones.

SELECT id_tec
FROM tecnicos
WHERE id_tec IN (
	SELECT MAX(coste_reparacion)
	FROM reparaciones
);

-- Bateria de ejercicios 2

-- 1 Muestra el nombre de cada artículo junto con el nombre de su fabricante, pero
-- únicamente para aquellos artículos cuyo precio sea superior a 100.00 euros

SELECT a.nombre_art, f.nombre_fabri
FROM articulos a
INNER JOIN fabricantes f ON f.id_fabri = a.id_fabri
WHERE a.precio > 100.00

-- 2 Muestra el nombre de todos los fabricantes de la base de datos y, al lado, el nombre
-- de sus artículos. Asegúrate de que aparezcan los fabricantes que no tienen ningún
-- artículo registrado.

SELECT a.nombre_art, f.nombre_fabri
FROM fabricantes f
LEFT JOIN articulos a ON a.id_fabri = f.id_fabri

-- También se puede hacer así:

SELECT a.nombre_art, f.nombre_fabri
FROM articulos a
RIGHT JOIN fabricantes f ON f.id_fabri = a.id_fabri

-- 3 Muestra el nombre del fabricante y la media de los precios de sus artículos, pero solo
-- para aquellos fabricantes cuya media de precios supere los 150.00 euros.

SELECT f.nombre_fabri, AVG(a.precio)
FROM fabricantes f
INNER JOIN articulos a ON a.id_fabri = f.id_fabri
GROUP BY f.nombre_fabri
HAVING (a.precio) > 150.00

-- 4 Muestra la descripción de la avería, el coste de la reparación y el nombre del técnico
-- que la ha llevado a cabo, ordenado por el coste de mayor a menor.

SELECT t.nombre_tec, r.descripcion_averia, r.coste_reparacion
FROM reparaciones r
INNER JOIN tecnicos t ON t.id_tec = r.id_tec
ORDER BY r.coste_reparacion DESC

-- 5 Muestra el nombre de aquellos técnicos que no han realizado ninguna reparación,
-- utilizando obligatoriamente un cruce externo de tablas.

SELECT t.nombre_tec
FROM tecnicos t
LEFT JOIN reparaciones r ON r.id_tec = t.id_tec
WHERE r.id_tec IS NULL

-- 6 Muestra el nombre del técnico y la suma total del dinero recaudado con sus
-- reparaciones, filtrando únicamente aquellos técnicos cuya recaudación total supere
-- los 100.00 euros.

SELECT t.nombre_tec, SUM(coste_reparacion)
FROM tecnicos t
LEFT JOIN reparaciones r ON r.id_tec = t.id_tec
GROUP BY t.nombre_tec
HAVING SUM(coste_reparacion) > 100.00

-- 7 Muestra el nombre de los artículos y el nombre de su respectivo fabricante, pero
-- filtrando exclusivamente aquellos artículos cuyos fabricantes sean originarios de
-- 'Estados Unidos' o 'Taiwán' .

SELECT a.nombre_art, f.nombre_fabri
FROM articulos a
INNER JOIN fabricantes f ON f.id_fabri = a.id_fabri
WHERE UPPER(f.pais) = 'Estados unidos' OR UPPER(f.pais) = 'Taiwán' 

-- 8 Muestra el nombre de todos los técnicos y, al lado, el número total de reparaciones
-- que ha realizado cada uno de ellos.

SELECT t. nombre_tec, COUNT(id_repac)
FROM tecnicos t
LEFT JOIN reparaciones r ON r.id_tec = t.id_tec
GROUP BY t.nombre_tec

-- 9 Muestra el nombre del fabricante y el número total de artículos que produce, pero
-- solo de aquellos fabricantes que tengan un número de artículos mayor o igual a 2.

SELECT f.nombre_fabri, COUNT(a.id_art)
FROM fabricantes f
LEFT JOIN articulos a ON a.id_fabri = f.id_fabri
GROUP BY f.nombre_fabri
HAVING COUNT(a.id_art) >= 2

-- 10 Muestra el nombre del técnico, su especialidad y la descripción de la reparación más
-- costosa que ha realizado cada uno de ellos.

SELECT t.nombre_tec, t.especialidad, r.descripcion_averia
FROM tecnicos t
LEFT JOIN reparaciones r ON r.id_tec = t.id_tec
GROUP BY t.nombre_tec

-- Ejercicio 10 bateria 2 incompleto