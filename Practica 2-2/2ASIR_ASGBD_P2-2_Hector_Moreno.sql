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
FROM fabricantes f, articulos a
WHERE id_fabri NOT IN (
	SELECT id_fabri
	FROM articulos
	WHERE precio <= (
		SELECT AVG(precio)
		FROM articulos
		)
)
;

