-- Bases de datos VIDEOJUEGOS

CREATE DATABASE IF NOT EXISTS VIDEOJUEGOS;
USE VIDEOJUEGOS;

CREATE TABLE plataforma (
    id_plataforma INT NOT NULL,
    nombre_plataforma VARCHAR(50),
    PRIMARY KEY (id_plataforma)
);

CREATE TABLE genero (
    id_genero INT NOT NULL,
    nombre_genero VARCHAR(50),
    PRIMARY KEY (id_genero)
);

CREATE TABLE juego (
    id_juego INT NOT NULL,
    id_genero INT,
    nombre_juego VARCHAR(200),
    PRIMARY KEY (id_juego),
    CONSTRAINT fk_juego_genero
        FOREIGN KEY (id_genero) REFERENCES genero (id_genero)
);

CREATE TABLE desarrollador (
    id_desarrollador INT NOT NULL,
    nombre_desarrollador VARCHAR(100),
    PRIMARY KEY (id_desarrollador)
);

CREATE TABLE desarrollador_juego (
    id_des_juego INT NOT NULL,
    id_juego INT,
    id_desarrollador INT,
    PRIMARY KEY (id_des_juego),
    CONSTRAINT fk_des_juego_juego
        FOREIGN KEY (id_juego) REFERENCES juego (id_juego),
    CONSTRAINT fk_des_juego_desarrollador
        FOREIGN KEY (id_desarrollador) REFERENCES desarrollador (id_desarrollador)
);

CREATE TABLE plataforma_juego (
    id_plat_juego INT NOT NULL,
    id_desarrollador_juego INT,
    id_plataforma INT,
    anio_lanzamiento INT,
    PRIMARY KEY (id_plat_juego),
    CONSTRAINT fk_plat_juego_des_juego
        FOREIGN KEY (id_desarrollador_juego) REFERENCES desarrollador_juego (id_des_juego),
    CONSTRAINT fk_plat_juego_plataforma
        FOREIGN KEY (id_plataforma) REFERENCES plataforma (id_plataforma)
);

--
-- Añadir datos a la tabla 'genero'
--

INSERT INTO `genero` VALUES (1,'Estrategia'),(2,'MOBA'),(3,'ARPG'),(4,'Mundo abierto');


INSERT INTO `juego` VALUES 
	(1,1, 'Hearthstone'),(2,1,'Clash Royale'),
	(3,2, 'League of Legends'),(4,2,'Brawl Stars'),
    (5,3, 'Elden Ring'),(6,3,'Sekiro: Shadows Die Twice'),
    (7,4, 'Horizon Forbidden West'),(8,4,'The legend of Zelda: Breath of the wild');


--
-- Estructura de la tabla desarrollador
--


INSERT INTO `desarrollador` VALUES 
	(1,'Blizzard'),(2,'Supercell'),(3,'Riot Games'),(4,'FromSoftware'),(5, 'Guerrilla Games'), (6, 'Nintendo EPD'), (7, 'Monolith Soft');


--
-- Estructura de la tabla desarrollador_juego
--

INSERT INTO `desarrollador_juego` VALUES 
	(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 2), (5, 5, 4), (6, 6, 4), (7, 7, 5), (8, 8, 6);


--
--  Estructura de la tabla plataforma
--

INSERT INTO `plataforma` VALUES 
	(1, 'PC'), (2, 'PlayStation'), (3, 'Xbox'), (4, 'Mobile'), (5, 'Nintendo');


--
-- Estructura de la tabla plataforma_juego
--


INSERT INTO `plataforma_juego` VALUES 
	(1, 1, 1, 2014), (2, 1, 4, 2015), (3, 2, 4, 2016), (4, 3, 1, 2009),
    (5, 4, 4, 2017), (6, 5, 3, 2022), (7, 5, 1, 2022), (8, 5, 2, 2022),
    (9, 6, 3, 2019), (10, 6, 1, 2019), (11, 6, 2, 2019),
    (12, 7, 2, 2022), (13, 8, 5, 2017);
	




-- PROCEDIMIENTOS

CREATE PROCEDURE
BEGIN

END$

--EJ 1 Crear un procedimiento que obtenga los videojuegos que pertenecen al género MOBA

DELIMITER $

CREATE PROCEDURE obtenerVideojuegosMOBA()
BEGIN
SELECT j.nombre_juego
FROM juego j
INNER JOIN genero g ON g.id_genero = j.id_genero
WHERE g.nombre_genero = 'MOBA'
;
END$

DELIMITER ;

--EJ 2 Crear un procedimiento que obtenga los videojuegos desarrollados por Supercell.

DELIMITER $

CREATE PROCEDURE obtenerVideojuegosSupercell()
BEGIN
SELECT j.nombre_juego
FROM juego j
INNER JOIN desarrollador_juego dj ON dj.id_juego = j.id_juego
INNER JOIN desarrollador d ON d.id_desarrollador = dj.id_desarrollador
WHERE d.nombre_desarrollador = 'Supercell'
;
END$

DELIMITER ;

--EJ 3 Crear un procedimiento que obtenga el nombre de los videojuegos y el género de los juegos
--publicados en la plataforma ‘PlayStation’


DELIMITER $

CREATE PROCEDURE obtenerVideojuegosGeneroPlaystation()
BEGIN
SELECT j.nombre_juego
FROM juego j
INNER JOIN desarrollador_juego dj ON dj.id_juego = j.id_juego
INNER JOIN plataforma_juego pj ON pj.id_desarrollador_juego = dj.id_des_juego
INNER JOIN plataforma p ON p.id_plataforma = pj.id_plataforma
WHERE p.nombre_plataforma = 'PlayStation'
;
END$

--EJ 4 Crear un procedimiento que obtenga el número de videojuegos lanzados en el año 2022.

DELIMITER $

CREATE PROCEDURE obtenerVideojuegosGeneroPlaystation()
BEGIN
SELECT count(nombre_juego) AS Número_juegos
FROM juego j
INNER JOIN desarrollador_juego dj ON dj.id_juego = j.id_juego
INNER JOIN plataforma_juego pj ON pj.id_desarrollador_juego = dj.id_des_juego
WHERE pj.anio_lanzamiento = 2022
;
END$

--EJ5 Crear un procedimiento que obtenga el porcentaje de videojuegos lanzados en 2022 llamando al
--ejercicio 4 dentro del procedimiento y utilizando el resultado que devuelve para hacer el cálculo. (Damos por
--hecho que cada juego solo se lanza una vez, independientemente de que se lance en tres plataformas
--diferentes)

DELIMITER //
CREATE PROCEDURE ej5(OUT porcentaje DECIMAL(5,2))
BEGIN
    DECLARE juegos_2022 INT;
    DECLARE total_juegos INT;

    CALL ej4(juegos_2022);
    SELECT COUNT(*) INTO total_juegos FROM juego;

    SET porcentaje = (juegos_2022 / total_juegos) * 100;
END //
DELIMITER ;

-- Ejercicio 6. Crear un procedimiento que tenga dos parámetros de entrada y uno de salida. Los dos de entrada
-- serán dos cadenas de caracteres y el de salida será una cadena formada por las dos cadenas de entrada
-- concatenadas.

DELIMITER //
CREATE PROCEDURE ej6(IN cad1 VARCHAR(255), IN cad2 VARCHAR(255), OUT res VARCHAR(510))
BEGIN
    SET res = CONCAT(cad1, cad2);
END //
DELIMITER ;

--Ejercicio 7. Crear un procedimiento que tenga de parámetro el nombre de un género y retorne en una
--parámetro de salida el número de juegos que existen de ese género.

DELIMITER //
CREATE PROCEDURE ej7(IN nom_genero VARCHAR(50), OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM juego j
    JOIN genero g ON j.id_genero = g.id_genero
    WHERE g.nombre_genero = nom_genero;
END //
DELIMITER ;

-- Ejercicio 8. Crear un procedimiento que reciba como parámetro el nombre de un juego y retorne en ese
-- mismo parámetro el nombre del juego concatenado con el nombre del género al que corresponde.

DELIMITER //
CREATE PROCEDURE ej8(INOUT juego_genero VARCHAR(300))
BEGIN
    DECLARE nom_genero VARCHAR(50);

    SELECT g.nombre_genero INTO nom_genero
    FROM juego j
    JOIN genero g ON j.id_genero = g.id_genero
    WHERE j.nombre_juego = juego_genero;

    SET juego_genero = CONCAT(juego_genero, ' - ', nom_genero);
END //
DELIMITER ;

--Ejercicio 9. Crear un procedimiento que reciba como parámetros el nombre de una plataforma, un año de
-- inicio y un año de fin y retorne el número de juegos que se publicaron para esa plataforma y entre el año de
-- inicio y el año de fin

DELIMITER //
CREATE PROCEDURE ej9(IN nom_plat VARCHAR(50), IN anio_ini INT, IN anio_fin INT, OUT total INT)
BEGIN
    SELECT COUNT(DISTINCT dj.id_juego) INTO total
    FROM plataforma_juego pj
    JOIN plataforma p ON pj.id_plataforma = p.id_plataforma
    JOIN desarrollador_juego dj ON pj.id_desarrollador_juego = dj.id_des_juego
    WHERE p.nombre_plataforma = nom_plat
      AND pj.anio_lanzamiento BETWEEN anio_ini AND anio_fin;
END //
DELIMITER ;

-- Ejercicio 10. Crear un procedimiento que tenga de parámetro el nombre de un desarrollador y que devuelva el
-- número de juegos que han creado.

DELIMITER //
CREATE PROCEDURE ej10(IN nom_dev VARCHAR(100), OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM desarrollador d
    JOIN desarrollador_juego dj ON d.id_desarrollador = dj.id_desarrollador
    WHERE d.nombre_desarrollador = nom_dev;
END //
DELIMITER ;

-- Ejercicio 11. Crear un procedimiento que tenga dos parámetros de entrada, uno será el identificador de un
-- desarrollador y el otro el nuevo nombre que se le debe asignar en la base de datos a ese desarrollador.

DELIMITER //
CREATE PROCEDURE ej11(IN id_dev INT, IN nuevo_nombre VARCHAR(100))
BEGIN
    UPDATE desarrollador
    SET nombre_desarrollador = nuevo_nombre
    WHERE id_desarrollador = id_dev;
END //
DELIMITER ;