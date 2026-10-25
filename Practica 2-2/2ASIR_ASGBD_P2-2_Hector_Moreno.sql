-- Héctor Moreno Tejero

-- Batería de consultas 1:

-- 1 Muestra el nombre y el precio de aquellos artículos que sean, exactamente, el artículo más caro de su respectivo fabricante.

SELECT nombre_art, precio -- Selecciona nombre_art y precio de la tabla ARTICULOS.
FROM articulos a
WHERE precio = (
	SELECT MAX(precio) -- Selecciona el máximo precio de cada farbricante
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
		SELECT AVG(precio) -- Calcula la media de los precios de los articulos
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