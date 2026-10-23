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
