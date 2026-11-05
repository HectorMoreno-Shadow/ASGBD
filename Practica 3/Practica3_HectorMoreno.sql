-- Héctor Moreno Tejero

-- Política de contraseña:

-- Mínimo 1 letra mayúscula, mínimo 1 letra minúscula, 
-- mínimo 1 número y mínimo un carácter especial
-- Mínimo 6 caracteres de longitud 

-- Tarea 1: Creación de usuarios y políticas de conexión y caducidad

-- 1. Creacion de cuentas base:

-- Creación usuario gestor_tienda

CREATE USER 'gestor_tienda'@'172.20.0.3' IDENTIFIED BY 'Gt1234@'

-- Creación usuario auditor_externo

CREATE USER 'auditor_externo'@'%' IDENTIFIED BY 'Ae1234@'

-- 2. Directiva de caducidad de credenciales:

-- Configuración del usuario auditor_externo

ALTER USER 'auditor_externo'@'%' PASSWORD EXPIRE INTERVAL 30 DAY;

-- 3. Directiva de control de sesión

-- Configuración del usuario gestor_tienda

ALTER USER 'gestor_tienda'@'172.20.0.3' wait_timeout = 3600;

-- Tarea 2: Creación y asignación de roles

-- 1 Definición de rol operativo

-- Creacion del rol

CREATE ROLE 'rol_consultor';

-- 2 Concesión de privilegios al rol

-- Añadir permisos al rol "rol_consultor" sobre la base de datos "tienda_informatica" (en mi caso tienda_ir)

GRANT SELECT ON tienda_ir.* TO 'rol_consultor';

-- 3 Asignación y rol por defecto

-- Asignamos el rol al usuario "auditor_externo"

GRANT 'rol_consultor' TO 'auditor_externo'@'%';

-- Tarea 3: Seguridad mediante Vistas y privilegios granulares

-- 1 Creación de la vista de enmascaramiento

CREATE VIEW v_tecnicos_activos AS
SELECT id_tec, nombre_tec, especialidad
FROM tecnicos
;

-- 2 Privilegio granular

GRANT SELECT ON tienda_ir.v_tecnicos_activos TO 'gestor_tienda'@'172.20.0.3';

-- 3 Prueba de denegación

-- Aparece un error diciendo: 
-- SELECT comando negado para usuario: 
-- 'gestor_tienda'@'172.20.0.3' para tabla 'tecnicos'

-- Tarea 4 Consistencia y control con WITH CHECK OPTION

-- 1 Vista con restriccion de dominio

CREATE VIEW v_articulos_gama_baja AS
SELECT *
FROM articulos
WHERE precio <= 50.00
WITH CHECK OPTION
;

-- 2 Demostración técnica

INSERT INTO articulos (nombre_art, precio)
VALUES ('articulo_prueba', 75.00)

-- No deja porque tiene la regla "WITH CHECK OPTION", que impide insercciones.

-- Tarea 5 Auditoría, Resolución de Incidencias y Reflexión Crítica

-- 1. Auditoría de privilegios efectivos: 

SHOW GRANTS FOR 'auditor_externo'@'%';

--2 Reflexión sobre el Principio de mínimo privilegio

-- Porque el usuario tendrá control total para borrar las bases de datos de golpe, crear accesos falsos
-- o tomar el control del servidor

-- 3 Análisis de comportamiento del CHECK OPTION

-- Pues permitiría insertar registros erroneos, ya que el CHECK OPTION impide insercciones y actualizaciones
-- que violen el filtro de la vista