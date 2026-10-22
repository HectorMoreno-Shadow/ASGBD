-- Héctor Moreno Tejero

-- Batería de consultas 1:

-- 1

SELECT nombre_art, precio
FROM articulos a
WHERE precio = (
	SELECT MAX(precio)
	FROM articulos b
	WHERE a.id_fabri = b.id_fabri
)
;

-- 2

SELECT f.nombre_fabri
FROM fabricantes f
WHERE f.id_fabri NOT IN (
	SELECT a.id_fabri
	FROM articulos a
	WHERE a.precio <= (
		SELECT AVG(precio)
		FROM articulos
));

-- 3

SELECT descripcion_averia, coste_reparacion
FROM reparaciones r1
WHERE coste_reparacion > (
	SELECT AVG(coste_reparacion)
	FROM reparaciones r2
	WHERE r1.id_tec = r2.id_tec
)
;

-- 4

SELECT id_tec, especialidad
FROM tecnicos
WHERE 
;

SELECT SUM(coste_reparacion) AS suma_coste
FROM reparaciones
GROUP BY id_tec

