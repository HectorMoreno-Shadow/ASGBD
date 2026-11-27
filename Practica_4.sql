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

-- Ejercicio 12. Realiza un procedimiento que tenga un parámetro de entrada y otro de salida. El parámetro de
-- entrada será un número de 1 a 12. Y el de salida será una cadena que indique el trimestre al que pertenece el
-- mes correspondiente de ese número. Ejemplo: Si el número es 1, la salida será: ‘Primer trimestre’. 

DELIMITER //
CREATE PROCEDURE ej12(IN mes INT, OUT trimestre VARCHAR(30))
BEGIN
    CASE mes
        WHEN 1 THEN SET trimestre = 'Primer trimestre';
        WHEN 2 THEN SET trimestre = 'Primer trimestre';
        WHEN 3 THEN SET trimestre = 'Primer trimestre';
        WHEN 4 THEN SET trimestre = 'Segundo trimestre';
        WHEN 5 THEN SET trimestre = 'Segundo trimestre';
        WHEN 6 THEN SET trimestre = 'Segundo trimestre';
        WHEN 7 THEN SET trimestre = 'Tercer trimestre';
        WHEN 8 THEN SET trimestre = 'Tercer trimestre';
        WHEN 9 THEN SET trimestre = 'Tercer trimestre';
        WHEN 10 THEN SET trimestre = 'Cuarto trimestre';
        WHEN 11 THEN SET trimestre = 'Cuarto trimestre';
        WHEN 12 THEN SET trimestre = 'Cuarto trimestre';
    END CASE;
END //
DELIMITER ;
-- Ejercicio 13. Crear un procedimiento que tenga dos parámetros de entrada y uno de salida. Uno de los
-- parámetros de entrada será el nombre de un desarrollador y el otro el nombre de una plataforma. El
-- parámetro de salida debe contener un texto que indique el número de juegos realizados por dicho
-- desarrollador para esa plataforma. Si no hay ninguno, debe devolver ‘No ha desarrollado ninguno’.

DELIMITER //
CREATE PROCEDURE ej13(IN nom_dev VARCHAR(100), IN nom_plat VARCHAR(50), OUT salida VARCHAR(150))
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM desarrollador d
    JOIN desarrollador_juego dj ON d.id_desarrollador = dj.id_desarrollador
    JOIN plataforma_juego pj ON dj.id_des_juego = pj.id_desarrollador_juego
    JOIN plataforma p ON pj.id_plataforma = p.id_plataforma
    WHERE d.nombre_desarrollador = nom_dev
      AND p.nombre_plataforma = nom_plat;

    IF total = 0 THEN
        SET salida = 'No ha desarrollado ninguno';
    ELSE
        SET salida = CONCAT('Juegos desarrollados: ', total);
    END IF;
END //
DELIMITER ;

-- Ejercicio 14. Crea un procedimiento que tenga como parámetro de entrada el nombre de un juego y devuelva
-- en un parámetro de salida la edad recomendada del juego en función del género. Si el género es ‘Estrategia’, la
-- edad recomendada será 7; para ‘MOBA’ será 13; para ‘ARPG’, 16 y para ‘Mundo abierto’, 18. Realiza el
-- procedimiento de dos formas, con IF y con SWITCH.

DELIMITER //
CREATE PROCEDURE ej14_if(IN nom_juego VARCHAR(200), OUT edad INT)
BEGIN
    DECLARE gen VARCHAR(50);

    SELECT g.nombre_genero INTO gen
    FROM juego j
    JOIN genero g ON j.id_genero = g.id_genero
    WHERE j.nombre_juego = nom_juego;

    IF gen = 'Estrategia' THEN
        SET edad = 7;
    ELSEIF gen = 'MOBA' THEN
        SET edad = 13;
    ELSEIF gen = 'ARPG' THEN
        SET edad = 16;
    ELSEIF gen = 'Mundo abierto' THEN
        SET edad = 18;
    END IF;
END //
DELIMITER ;

-- Ejercicio 15. Crea un procedimiento que reciba por parámetro el nombre de una plataforma y un año y
-- devuelva el número de juegos que se han desarrollado para esa plataforma hasta ese año. Si no hay ninguno,
-- devolver ‘No hay juegos para la plataforma X antes del año Y’.

DELIMITER //
CREATE PROCEDURE ej15(IN nom_plat VARCHAR(50), IN anio INT, OUT salida VARCHAR(200))
BEGIN
    DECLARE total INT;

    SELECT COUNT(DISTINCT dj.id_juego) INTO total
    FROM plataforma_juego pj
    JOIN plataforma p ON pj.id_plataforma = p.id_plataforma
    JOIN desarrollador_juego dj ON pj.id_desarrollador_juego = dj.id_des_juego
    WHERE p.nombre_plataforma = nom_plat
      AND pj.anio_lanzamiento <= anio;

    IF total = 0 THEN
        SET salida = CONCAT('No hay juegos para la plataforma ', nom_plat, ' antes del año ', anio);
    ELSE
        SET salida = total;
    END IF;
END //
DELIMITER ;

-- Ejercicio 16. Crea un procedimiento que reciba por parámetro el nombre de un juego y devuelva en un
-- parámetro de salida un mensaje en función del número de plataformas en las que se ha publicado. Si es en 1 o
-- menos mostrar ‘Pocas’, si es en 2 ‘Algunas’ y si es en 3 o más ‘Muchas’. Realiza el procedimiento de dos formas,
-- con IF y con SWITCH.

DELIMITER //
CREATE PROCEDURE ej16_if(IN nom_juego VARCHAR(200), OUT msg VARCHAR(20))
BEGIN
    DECLARE num_plat INT;

    SELECT COUNT(*) INTO num_plat
    FROM juego j
    JOIN desarrollador_juego dj ON j.id_juego = dj.id_juego
    JOIN plataforma_juego pj ON dj.id_des_juego = pj.id_desarrollador_juego
    WHERE j.nombre_juego = nom_juego;

    IF num_plat <= 1 THEN
        SET msg = 'Pocas';
    ELSEIF num_plat = 2 THEN
        SET msg = 'Algunas';
    ELSE
        SET msg = 'Muchas';
    END IF;
END //
DELIMITER ;

-- Ejercicio 17. Añade a la tabla juego el campo ‘edad_recomendada’ de tipo INT. Crea un procedimiento que
-- tenga como parámetro de entrada el nombre de un juego. Dicho procedimiento debe actualizar el valor de
-- edad_recomendada según el género del juego introducido: si el género es ‘Estrategia’, la edad recomendada
-- será 7; para ‘MOBA’ será 13; para ‘ARPG’, 16 y para ‘Mundo abierto’, 18.

ALTER TABLE juego ADD COLUMN edad_recomendada INT;

DELIMITER //
CREATE PROCEDURE ej17(IN nom_juego VARCHAR(200))
BEGIN
    DECLARE gen VARCHAR(50);
    DECLARE edad INT;

    SELECT g.nombre_genero INTO gen
    FROM juego j
    JOIN genero g ON j.id_genero = g.id_genero
    WHERE j.nombre_juego = nom_juego;

    CASE gen
        WHEN 'Estrategia' THEN SET edad = 7;
        WHEN 'MOBA' THEN SET edad = 13;
        WHEN 'ARPG' THEN SET edad = 16;
        WHEN 'Mundo abierto' THEN SET edad = 18;
    END CASE;

    UPDATE juego SET edad_recomendada = edad WHERE nombre_juego = nom_juego;
END //
DELIMITER ;

--Ejercicio 18. Crea un procedimiento que muestre el nombre de todos los videojuegos junto con su edad
--recomendada y un mensaje textual que indique ‘Adultos’ si el juego es para mayores de 18 u ‘Otros’ en caso
--contrario. Ejemplo de salida:

DELIMITER //
CREATE PROCEDURE ej18()
BEGIN
    SELECT
        nombre_juego,
        edad_recomendada,
        IF(edad_recomendada >= 18, 'Adultos', 'Otros') AS tipo
    FROM juego;
END //
DELIMITER ;

-- Ejercicio 19. Realiza un procedimiento que muestre el nombre de los juegos, su desarrollador, la plataforma
-- para la que se ha lanzado y un mensaje textual que indique ‘Antiguo’ si se lanzó en 2015 o antes, ‘Moderno’ si se
-- lanzó entre 2016 y 2020 o ‘Nuevo’ si se lanzó a partir de 2021 (incluido). Ejemplo de salida:

DELIMITER //
CREATE PROCEDURE ej19()
BEGIN
    SELECT
        j.nombre_juego,
        d.nombre_desarrollador,
        p.nombre_plataforma,
        CASE
            WHEN pj.anio_lanzamiento <= 2015 THEN 'Antiguo'
            WHEN pj.anio_lanzamiento BETWEEN 2016 AND 2020 THEN 'Moderno'
            ELSE 'Nuevo'
        END AS epoca
    FROM plataforma_juego pj
    JOIN desarrollador_juego dj ON pj.id_desarrollador_juego = dj.id_des_juego
    JOIN juego j ON dj.id_juego = j.id_juego
    JOIN desarrollador d ON dj.id_desarrollador = d.id_desarrollador
    JOIN plataforma p ON pj.id_plataforma = p.id_plataforma;
END //
DELIMITER ;

--Ejercicio 20. Crea un procedimiento que reciba dos parámetros de entrada y uno de salida. Los parámetro de
--entrada serán el nombre de un desarrollador y el nombre de un género. El parámetro de salida debe devolver
--una cadena de texto que indique ‘El desarrollador X ha creado ‘num_juegos’ juegos del género Y’ o ‘El
--desarrollador X no ha desarrollado ningún juego del género Y’

DELIMITER //
CREATE PROCEDURE ej20(IN nom_dev VARCHAR(100), IN nom_gen VARCHAR(50), OUT salida VARCHAR(255))
BEGIN
    DECLARE num_juegos INT;

    SELECT COUNT(*) INTO num_juegos
    FROM desarrollador d
    JOIN desarrollador_juego dj ON d.id_desarrollador = dj.id_desarrollador
    JOIN juego j ON dj.id_juego = j.id_juego
    JOIN genero g ON j.id_genero = g.id_genero
    WHERE d.nombre_desarrollador = nom_dev
      AND g.nombre_genero = nom_gen;

    IF num_juegos = 0 THEN
        SET salida = CONCAT('El desarrollador ', nom_dev, ' no ha desarrollado ningún juego del género ', nom_gen);
    ELSE
        SET salida = CONCAT('El desarrollador ', nom_dev, ' ha creado ', num_juegos, ' juegos del género ', nom_gen);
    END IF;
END //
DELIMITER ;

--Ejercicio 21. Crea un procedimiento muestre el nombre de todos los juegos y la edad recomendada. Si algún
--juego no tiene informado el campo edad recomendada, debe indicar el valor 99.

DELIMITER //
CREATE PROCEDURE ej21()
BEGIN
    SELECT nombre_juego, IFNULL(edad_recomendada, 99) AS edad_recomendada
    FROM juego;
END //
DELIMITER ;

--Ejercicio 22. Crea un procedimiento que tenga como parámetro de entrada el nombre de un juego. Dicho
--procedimiento debe actualizar el valor de edad_recomendada según el género del juego introducido: si el
--género es ‘Estrategia’, la edad recomendada será 7; para ‘MOBA’ será 13; para ‘ARPG’, 16 y para ‘Mundo abierto’,
--18. Haz uso de la sentencia CASE dentro del UPDATE.

DELIMITER //
CREATE PROCEDURE ej22(IN nom_juego VARCHAR(200))
BEGIN
    UPDATE juego j
    JOIN genero g ON j.id_genero = g.id_genero
    SET j.edad_recomendada = CASE g.nombre_genero
        WHEN 'Estrategia' THEN 7
        WHEN 'MOBA' THEN 13
        WHEN 'ARPG' THEN 16
        WHEN 'Mundo abierto' THEN 18
    END
    WHERE j.nombre_juego = nom_juego;
END //
DELIMITER ;

--Ejercicio 23. Crea un procedimiento reciba por el nombre de un juego y una edad recomendada. Si el juego
--indicado no tiene informado el campo edad_recomendada, debe actualizarse esa tupla para establecer la
--edad indicada por parámetro.

DELIMITER //
CREATE PROCEDURE ej23(IN nom_juego VARCHAR(200), IN edad INT)
BEGIN
    UPDATE juego
    SET edad_recomendada = edad
    WHERE nombre_juego = nom_juego
      AND edad_recomendada IS NULL;
END //
DELIMITER ;
DELIMITER ;

--Ejercicio 22. Crea un procedimiento que tenga como parámetro de entrada el nombre de un juego. Dicho
--procedimiento debe actualizar el valor de edad_recomendada según el género del juego introducido: si el
--género es ‘Estrategia’, la edad recomendada será 7; para ‘MOBA’ será 13; para ‘ARPG’, 16 y para ‘Mundo abierto’,
--18. Haz uso de la sentencia CASE dentro del UPDATE.

DELIMITER //
CREATE PROCEDURE ej22(IN nom_juego VARCHAR(200))
BEGIN
    UPDATE juego j
    JOIN genero g ON j.id_genero = g.id_genero
    SET j.edad_recomendada = CASE g.nombre_genero
        WHEN 'Estrategia' THEN 7
        WHEN 'MOBA' THEN 13
        WHEN 'ARPG' THEN 16
        WHEN 'Mundo abierto' THEN 18
    END
    WHERE j.nombre_juego = nom_juego;
END //
DELIMITER ;

--Ejercicio 23. Crea un procedimiento reciba por el nombre de un juego y una edad recomendada. Si el juego
--indicado no tiene informado el campo edad_recomendada, debe actualizarse esa tupla para establecer la
--edad indicada por parámetro.

DELIMITER //
CREATE PROCEDURE ej23(IN nom_juego VARCHAR(200), IN edad INT)
BEGIN
    UPDATE juego
    SET edad_recomendada = edad
    WHERE nombre_juego = nom_juego
      AND edad_recomendada IS NULL;
END //
DELIMITER ;

-- Ejercicio 24. Crea un procedimiento que reciba por parámetro el nombre de un género. Dicho procedimiento
-- debe mostrar el nombre de todos los juegos y su género. En caso de que el género sea igual al introducido por
-- parámetro, se mostrará NULL.

DELIMITER //
CREATE PROCEDURE ej24(IN nom_gen VARCHAR(50))
BEGIN
    SELECT
        j.nombre_juego,
        IF(g.nombre_genero = nom_gen, NULL, g.nombre_genero) AS nombre_genero
    FROM juego j
    JOIN genero g ON j.id_genero = g.id_genero;
END //
DELIMITER ;

-- Enlace github: https://github.com/HectorMoreno-Shadow/ASGBD