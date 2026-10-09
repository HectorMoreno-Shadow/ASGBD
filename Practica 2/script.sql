-- Héctor Moreno Tejero

-- Creo la base de datos y la uso "USE tienda_ir" para especificar donde ejecutar los comandos SQL posteriores

CREATE DATABASE tienda_ir;
USE tienda_ir;

-- Creo las tablas con sus columnas

-- Creo las tabla fabricantes

CREATE TABLE fabricantes (
	id_fabri INT PRIMARY KEY AUTO_INCREMENT,
	nombre_fabri VARCHAR(50) UNIQUE,
	pais VARCHAR(50)
);

-- Creo las tabla articulos

CREATE TABLE articulos (
	id_art INT PRIMARY KEY AUTO_INCREMENT,
	nombre_art VARCHAR(50),
	precio DECIMAL(6, 2),
	id_fabri INT,
	
	CONSTRAINT fk_articulos_fabricantes
		FOREIGN KEY (id_fabri)
		REFERENCES fabricantes(id_fabri)
		ON DELETE CASCADE
);

-- Creo las tabla tecnicos

CREATE TABLE tecnicos (
	id_tec INT PRIMARY KEY AUTO_INCREMENT,
	nombre_tec VARCHAR(50),
	especialidad VARCHAR(50),
	salario DECIMAL(6, 2)
);

-- Creo las tabla reparaciones

CREATE TABLE reparaciones (
	id_repac INT PRIMARY KEY AUTO_INCREMENT,
	descripcion_averia VARCHAR(200),
	coste_reparacion DECIMAL(6 , 2),
	id_tec INT,
	
	CONSTRAINT fk_reparaciones_tecnicos
		FOREIGN KEY (id_tec)
		REFERENCES tecnicos(id_tec)
		ON DELETE CASCADE
);
	
-- Añadimos los datos a las tablas

-- Añado datos de la tabla fabricantes

INSERT INTO fabricantes (nombre_fabri, pais)
VALUES
				('Kingston', 'Estados Unidos'),
				('Asus', 'Taiwán'),
				('Samsung', 'Corea del Sur'),
				('Logithec', 'Suiza'),
				('Intel', 'Estados Unidos');
				
-- Añado datos de la tabla articulos

INSERT INTO articulos (nombre_art, precio, id_fabri)
VALUES
				('Memoria RAM 16GB DDR4', '45.50', '1'),
				('SSD NVMe 1TB', '79.99', '1'),
				('Placa Base ROG Strix', '185.00', '2'),
				('Monitor 27" IPS 144Hz', '249.00', '2'),
				('Monitor 32" Curved', '320.00', '3'),
				('Ratón Óptico Inalámbrico', '29.99', '4'),
				('Teclado Mecánico RGB', '89.90', '4'),
				('Procesador Core i7', '310.00', '5');
				
-- Añado datos de la tabla tecnicos

INSERT INTO tecnicos (nombre_tec, especialidad, salario)
VALUES
				('Carlos Pérez', 'Hardware', '1800.00'),
				('Ana Gómez', 'Redes y Servidores', '2100.00'),
				('Luis Martínez', 'Portátiles', '1650.00'),
				('Marta Ruiz', 'Movilidad y Tablets', '1750.00');
				
-- Añado datos de la tabla reparaciones
				
INSERT INTO reparaciones (descripcion_averia, coste_reparacion, id_tec)
VALUES
				('Sustitución de pantalla rota', '120.50', '3'),
				('Cambio de fuente de alimentación', '65.00', '1'),
				('Recuperación de datos en disco dañado', '150.00', '2'),
				('Limpieza interna y cambio de pasta térmica', '45.00', '1'),
				('Sustitución de conector de carga', '50.00', '3'),
				('Ampliación de RAM y formateo', '80.00', '4');
				
-- CONSULTAS

-- 1.

SELECT nombre_art, precio
FROM articulos
ORDER BY precio ASC
;

-- 2

SELECT * FROM fabricantes
WHERE UPPER(pais) = 'estados unidos'
;

-- 3

SELECT * FROM articulos
WHERE precio >= 100
AND precio <= 300
;

-- 4

SELECT AVG(precio) FROM articulos
;

-- 5

SELECT id_fabri, COUNT(*) FROM articulos
GROUP BY id_fabri
;
-- 6

SELECT id_tec, COUNT(*) FROM reparaciones
GROUP BY id_tec
HAVING COUNT(*) > 1
;

-- 7

