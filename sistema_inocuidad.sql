-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-06-2022 a las 22:15:32
-- Versión del servidor: 10.4.22-MariaDB
-- Versión de PHP: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_inocuidad`
--
CREATE DATABASE IF NOT EXISTS `sistema_inocuidad` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci;
USE `sistema_inocuidad`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `SP_EDITAR_MOLIENDA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EDITAR_MOLIENDA` (IN `ID` INT, IN `TAMIZADO` VARCHAR(45), IN `POLVO` VARCHAR(45), IN `TE` VARCHAR(45), IN `NOMALLA` VARCHAR(45), IN `MERMA` DOUBLE, IN `RENDIMIENTO` DOUBLE, IN `OBSERVACIONES` VARCHAR(255), IN `RUTA` VARCHAR(250))  BEGIN
UPDATE molienda set 
  molienda_fecha_salida = curdate(),
  molienda_hora_salida = curtime(),
  molienda_tamizado = TAMIZADO,
  molienda_polvo = POLVO,
  molienda_te = TE,
  molienda_no_malla = NOMALLA,
  molienda_merma = MERMA,
  molienda_rendimiento = RENDIMIENTO,
  molienda_observaciones = OBSERVACIONES,
  molienda_img_url = RUTA,
  molienda_status = 'FINALIZADO'
  where 
  id_molienda = ID;
  select 1;
END$$

DROP PROCEDURE IF EXISTS `SP_EDITAR_ROL`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EDITAR_ROL` (IN `ID` INT, IN `ROLACTUAL` VARCHAR(15), IN `ROLNUEVO` VARCHAR(15), IN `ESTATUS` VARCHAR(10))  BEGIN
DECLARE CANTIDAD INT;
IF ROLACTUAL = ROLNUEVO THEN
	UPDATE rol SET
	rol_status= ESTATUS
	where rol_id=ID;
    select 1;
ELSE
	set @CANTIDAD:= (SELECT COUNT(*) FROM rol where rol_nombre = ROLNUEVO);
    IF CANTIDAD = 0 then 
		UPDATE rol SET
        rol_nombre = ROLNUEVO,
		rol_status = ESTATUS
		where rol_id=ID;
        select 1;
    ELSE
    SELECT 2;	
    END IF;
END IF;
END$$

DROP PROCEDURE IF EXISTS `SP_EDITAR_USUARIO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EDITAR_USUARIO` (IN `ID` INT, IN `EMAILNUEVO` VARCHAR(255), IN `IDPERSONA` INT, IN `IDROL` INT, IN `ESTATUS` VARCHAR(18))  BEGIN
DECLARE CANTIDAD INT;
DECLARE MAILACTUAL VARCHAR(50);
SET @USUARIOACTUAL:=(SELECT usuario_nombre from usuario where usuario_id=ID);
SET @MAILACTUAL:=(SELECT usuario_mail from usuario where usuario_id=ID);
IF  @MAILACTUAL = EMAILNUEVO THEN
  UPDATE usuario set 
  id_persona = IDPERSONA,
  rol_id = IDROL,
  usuario_status = ESTATUS
  where 
  usuario_id = ID;
  select 1;
ELSE
  set @CANTIDAD:= (select count(*) from usuario where usuario_mail = EMAILNUEVO);
  IF @CANTIDAD = 0 then
  UPDATE usuario set 
  id_persona = IDPERSONA,
  rol_id = IDROL,
  usuario_status = ESTATUS,
  usuario_mail = EMAILNUEVO
  where 
  usuario_id = ID;
  select 1;
  else
  select 2;
  end if;
 END IF;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_COMBO_MATERIA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_MATERIA` ()  BEGIN
select materia.id_materia,concat_ws( " ",materia.materia_nombre, materia.materia_no_control) as materia
from materia;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_COMBO_PERSONA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_PERSONA` ()  BEGIN
select persona.id_persona,concat_ws( " ",persona.persona_nombre, persona.persona_apepat,persona.persona_apemat)
from persona where persona_estatus = "ACTIVO";
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_COMBO_ROL`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_ROL` ()  BEGIN
select rol.rol_id,rol.rol_nombre
from rol where rol_status = "ACTIVO";
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_DATOS_RESTANTE_PRODUCTO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_DATOS_RESTANTE_PRODUCTO` (IN `IDENTRADA` INT)  BEGIN
select fecha_caducidad,cantidad_disponible 
from prod_ter_entradas
 where id_entrada=IDENTRADA;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_ENTRADA_PRODUCTO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ENTRADA_PRODUCTO` ()  BEGIN
select id_entrada, producto.id_producto, producto.nombre,lote,fecha_caducidad,fecha_entrada,cantidad
from prod_ter_entradas
inner join producto on prod_ter_entradas.id_producto = producto.id_producto
order by (id_entrada) desc;

END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_MOLIENDA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MOLIENDA` ()  BEGIN
select id_molienda,molienda_corte,molienda_fecha_entrada,molienda_hora_entrada,
molienda_kg_ingresados,molienda_no_malla,molienda_no_malla,molienda_fecha_salida,
molienda_hora_salida,molienda_tamizado,molienda_polvo,molienda_te,molienda_merma,
molienda_rendimiento,molienda.id_materia,molienda.id_molino,molienda_observaciones,molienda_img_url,
materia.materia_nombre, materia.materia_no_control
from molienda
inner join materia on molienda.id_materia = materia.id_materia
where molienda_status is null;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_MOLIENDA_HISTORICO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MOLIENDA_HISTORICO` ()  BEGIN
select id_molienda,molienda_corte,molienda_fecha_entrada,molienda_hora_entrada,
molienda_kg_ingresados,molienda_no_malla,molienda_no_malla,molienda_fecha_salida,
molienda_hora_salida,molienda_tamizado,molienda_polvo,molienda_te,molienda_merma,
molienda_rendimiento,molienda.id_materia,molienda.id_molino,molienda_observaciones,molienda_img_url,
materia.materia_nombre, materia.materia_no_control
from molienda
inner join materia on molienda.id_materia = materia.id_materia
where molienda_status='FINALIZADO';
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_MOLIENDA_HISTORICO()`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MOLIENDA_HISTORICO()` ()  BEGIN
select id_molienda,molienda_corte,molienda_fecha_entrada,molienda_hora_entrada,
molienda_kg_ingresados,molienda_no_malla,molienda_no_malla,molienda_fecha_salida,
molienda_hora_salida,molienda_tamizado,molienda_polvo,molienda_te,molienda_merma,
molienda_rendimiento,molienda.id_materia,molienda.id_molino,molienda_observaciones,molienda_img_url,
materia.materia_nombre, materia.materia_no_control
from molienda
inner join materia on molienda.id_materia = materia.id_materia
where molienda_status='FINALIZADO';
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_PERSONA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PERSONA` ()  BEGIN
SELECT concat_ws(' ', persona_nombre,persona_apepat,persona_apemat) as persona, id_persona,persona_nombre,persona_apepat,persona_apemat,persona_sexo,persona_estatus FROM persona ;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_PRODUCTO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO` ()  BEGIN
select  producto.id_producto,nombre, stock 
from prod_ter_inventario inner join producto on prod_ter_inventario.id_producto=producto.id_producto;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_PRODUCTO_DOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO_DOS` ()  BEGIN
select  producto.id_producto AS id,nombre
from producto;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_PRODUCTO_LOTES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO_LOTES` (IN `IDPRODUCTO` INT)  BEGIN
select  id_entrada, lote
from prod_ter_entradas
where id_producto=IDPRODUCTO and estatus is null
order by (fecha_entrada)
limit 3;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_PRODUCTO_LOTES_DOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO_LOTES_DOS` (IN `IDPRODUCTO` INT)  BEGIN
select  id_entrada, lote, cantidad_disponible
from prod_ter_entradas
where id_producto=IDPRODUCTO and estatus is null
order by (fecha_entrada);
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_ROL`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ROL` ()  BEGIN
SELECT rol_id, rol_feregistro,rol_nombre,rol_status FROM rol ;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_SALIDAS_PRODUCTO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SALIDAS_PRODUCTO` ()  BEGIN
select id_prod_ter_salidas, producto.nombre,prod_ter_entradas.lote,prod_ter_salidas.cantidad, prod_ter_entradas.fecha_caducidad, fecha_salida, folio_venta
from prod_ter_salidas
inner join producto on prod_ter_salidas.id_producto = producto.id_producto
left join prod_ter_entradas on prod_ter_salidas.id_entrada = prod_ter_entradas.id_entrada
order by (id_prod_ter_salidas) DESC;
END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_USUARIO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_USUARIO` ()  BEGIN
SELECT usuario_id,
usuario_nombre,
usuario_mail,
usuario_status,
usuario_password,
usuario_img,
usuario.rol_id,
usuario.id_persona,
rol.rol_nombre,
concat_ws( " ",persona.persona_nombre, persona.persona_apepat,persona.persona_apemat) as persona
FROM sistema_inocuidad.usuario
inner join rol on usuario.rol_id = rol.rol_id 
left join persona on usuario.id_persona = persona.id_persona;
END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_ENTRADA_PRODUCTO_TERMINADO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_ENTRADA_PRODUCTO_TERMINADO` (IN `ID_PRODUCTO` INT, IN `LOTE` VARCHAR(50), IN `CANTIDAD` INT, IN `FECHA_CADUCIDAD` DATE)  BEGIN
INSERT INTO prod_ter_entradas(id_producto,lote,fecha_caducidad,fecha_entrada,cantidad,cantidad_disponible)
values (ID_PRODUCTO,LOTE,FECHA_CADUCIDAD,curdate(),CANTIDAD,CANTIDAD);
SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_MOLIENDA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_MOLIENDA` (IN `IDMATERIA` INT, IN `CORTE` VARCHAR(45), IN `KG` DOUBLE, IN `IDMOLINO` INT)  BEGIN
INSERT INTO molienda(molienda_corte,molienda_fecha_entrada,molienda_hora_entrada,molienda_kg_ingresados,id_materia,id_molino)
values (CORTE,curdate(),curtime(),KG,IDMATERIA,IDMOLINO);
SELECT 1;
END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_ROL`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_ROL` (IN `NROL` VARCHAR(15))  BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD := (SELECT COUNT(*) FROM rol where rol_nombre = NROL);
IF (@CANTIDAD = 0) then
	
	INSERT INTO rol (rol_nombre,rol_feregistro, rol_status)VALUES(NROL,CURDATE(),'ACTIVO');
	SELECT 1;
    
		ELSE
			select 2;
END IF;
END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO` (IN `ID_PRODUCTO` INT, IN `IDENTRADA` INT, IN `CANTIDAD` INT, IN `FOLIO_VENTA` VARCHAR(45))  BEGIN
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,IDENTRADA,CANTIDAD,curdate(),FOLIO_VENTA);
SELECT 1;

begin
SET @CANTIDAD_DISPONIBLE := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =IDENTRADA );
SET @CANTIDAD_ACTUAL_DISPONIBLE = (@CANTIDAD_DISPONIBLE - CANTIDAD);

IF @CANTIDAD_ACTUAL_DISPONIBLE = 0 THEN 
        UPDATE prod_ter_entradas set 
		cantidad_disponible = @CANTIDAD_ACTUAL_DISPONIBLE,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= IDENTRADA;
	ELSE
		UPDATE prod_ter_entradas set 
		cantidad_disponible = @CANTIDAD_ACTUAL_DISPONIBLE
		where prod_ter_entradas.id_entrada = IDENTRADA;
END IF;
end;


END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_CUATRO_LOTES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_CUATRO_LOTES` (IN `ID_PRODUCTO` INT, IN `LOTE_UNO` VARCHAR(50), IN `LOTE_DOS` VARCHAR(50), IN `LOTE_TRES` VARCHAR(50), IN `LOTE_CUATRO` VARCHAR(50), IN `CANTIDAD` INT, IN `FOLIO_VENTA` VARCHAR(45))  BEGIN

#DECLARACION DE VARIABLES PARA REALIZAR LAS OPRECIONES 
#NECESARIAS
DECLARE CANTIDAD_FALTANTE INT;
DECLARE CANTIDAD_LOTE_UNO_Y_DOS_TRES INT;
DECLARE CANTIDAD_ACTUAL_lOTE INT;
DECLARE CANTIDAD_DISPONIBLE_LOTE INT;

#SE OBTIENE EL ID DE LA ENTRADA CON EL LOTE INGRESADO
#SE OBTIENE LA CANTIDAD DISPONIBLE DEL LOTE UNO
SET @ID_ENTRADA := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE_UNO);
SET @CANTIDAD_DISPONIBLE_LOTE := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA);

#SE OBTIENE EL ID DE LA ENTRADA CON EL LOTE INGRESADO
#SE OBTIENE LA CANTIDAD DISPONIBLE DEL LOTE DOS
SET @ID_ENTRADA_DOS := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE_DOS);
SET @CANTIDAD_DISPONIBLE_LOTE_DOS := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA_DOS );

#SE OBTIENE EL ID DE LA ENTRADA CON EL LOTE INGRESADO
#SE OBTIENE LA CANTIDAD DISPONIBLE DEL LOTE DOS
SET @ID_ENTRADA_TRES := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote = LOTE_TRES);
SET @CANTIDAD_DISPONIBLE_LOTE_TRES := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA_TRES );

#SUMA DE LA CANTIDAD DE LOTES 1, 2 Y 3, Y SE SACA LA CANTIDAD FALTANTE PARA COMPLETAR LA CANTIDAD REQUEDIDA
SET @CANTIDAD_LOTE_UNO_Y_DOS_TRES =  @CANTIDAD_DISPONIBLE_LOTE_DOS + @CANTIDAD_DISPONIBLE_LOTE + @CANTIDAD_DISPONIBLE_LOTE_TRES;
SET @CANTIDAD_FALTANTE= CANTIDAD - @CANTIDAD_LOTE_UNO_Y_DOS_TRES;

SET @ID_ENTRADA_CUATRO := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote = LOTE_CUATRO);
SET @CANTIDAD_DISPONIBLE_LOTE_CUATRO := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA_CUATRO);
SET @CANTIDAD_ACTUAL_lOTE =  @CANTIDAD_DISPONIBLE_LOTE_CUATRO -@CANTIDAD_FALTANTE;

IF ( (CANTIDAD - @CANTIDAD_LOTE_UNO_Y_DOS_TRES) > 0 ) Then

#SE INGRESA LAS SALIDAS DE LOS 3 LOTES DIFERENTES
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA,@CANTIDAD_DISPONIBLE_LOTE,curdate(),FOLIO_VENTA);
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA_DOS,@CANTIDAD_DISPONIBLE_LOTE_DOS,curdate(),FOLIO_VENTA);
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA_TRES,@CANTIDAD_DISPONIBLE_LOTE_TRES,curdate(),FOLIO_VENTA);
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA_CUATRO,@CANTIDAD_FALTANTE,curdate(),FOLIO_VENTA);
SELECT 1;

END IF;

BEGIN

#SI LA CANTIDAD FALTANTE ES MAYOR A CERO LOS 2 PRIMEROS LOTES NO SON SUFICIENTES
#SE ACTUALIZA EL ESTADO DE LOS LOTES Y SE MODIFICA LA CANTIDAD DISPONIBLE DEL LOTE
IF @CANTIDAD_FALTANTE > 0 THEN 
        UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= @ID_ENTRADA;
        UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= @ID_ENTRADA_DOS;
         UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= @ID_ENTRADA_TRES;
        
#SE LE RESTA LA CANTIDAD DISPOIBLE DE LOTE A LA QUE FALTA PARA COMPLETAR 
#SI ES MAYOR A CERO QUIERE DECIR QUE TODAVIA HAY PIEZAS DISPONIBLE EN EL LOTE
#SE ACTUALIZA LA CANTIDAD DISPONIBLE
# EN CASO DE QUE NO SEA MAYOR A CERO SE ACTUALIZA EL ESTATUS A AGOTADO Y LA CANTIDAD DISPIBLE A CERO
IF  ((@CANTIDAD_DISPONIBLE_LOTE_CUATRO -  @CANTIDAD_FALTANTE) > 0)  THEN
		UPDATE prod_ter_entradas set 
		cantidad_disponible = @CANTIDAD_ACTUAL_lOTE
		where prod_ter_entradas.id_entrada = @ID_ENTRADA_CUATRO;
	ELSE
		UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada = @ID_ENTRADA_CUATRO;
	END IF;
    
    
END IF;


end;



END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_DOS_LOTES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_DOS_LOTES` (IN `ID_PRODUCTO` INT, IN `LOTE_UNO` VARCHAR(50), IN `LOTE_DOS` VARCHAR(50), IN `CANTIDAD` INT, IN `FOLIO_VENTA` VARCHAR(45))  BEGIN

DECLARE CANTIDAD_FALTANTE INT;
DECLARE CANTIDAD_ACTUAL_lOTE INT;
DECLARE CANTIDAD_DISPONIBLE_LOTE INT;


SET @ID_ENTRADA := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE_UNO);
SET @CANTIDAD_DISPONIBLE_LOTE := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA);
SET @CANTIDAD_FALTANTE= CANTIDAD - @CANTIDAD_DISPONIBLE_LOTE;


SET @ID_ENTRADA_DOS := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE_DOS);
SET @CANTIDAD_DISPONIBLE_LOTE_DOS := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA_DOS );
SET @CANTIDAD_ACTUAL_lOTE =  @CANTIDAD_DISPONIBLE_LOTE_DOS -@CANTIDAD_FALTANTE;

IF ( (CANTIDAD - @CANTIDAD_DISPONIBLE_LOTE) > 0 ) Then

INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA,@CANTIDAD_DISPONIBLE_LOTE,curdate(),FOLIO_VENTA);
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA_DOS,@CANTIDAD_FALTANTE,curdate(),FOLIO_VENTA);
SELECT 1;

END IF;


BEGIN

IF @CANTIDAD_FALTANTE > 0 THEN 
        UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= @ID_ENTRADA;
IF  ((@CANTIDAD_DISPONIBLE_LOTE_DOS -  @CANTIDAD_FALTANTE) > 0)  THEN
		UPDATE prod_ter_entradas set 
		cantidad_disponible = @CANTIDAD_ACTUAL_lOTE
		where prod_ter_entradas.id_entrada = @ID_ENTRADA_DOS;
	ELSE
		UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada = @ID_ENTRADA_DOS;
	END IF;
    
    
END IF;


end;

END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_TRES_LOTES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_TRES_LOTES` (IN `ID_PRODUCTO` INT, IN `LOTE_UNO` VARCHAR(50), IN `LOTE_DOS` VARCHAR(50), IN `LOTE_TRES` VARCHAR(50), IN `CANTIDAD` INT, IN `FOLIO_VENTA` VARCHAR(45))  BEGIN

#DECLARACION DE VARIABLES PARA REALIZAR LAS OPRECIONES 
#NECESARIAS
DECLARE CANTIDAD_FALTANTE INT;
DECLARE CANTIDAD_LOTE_UNO_Y_DOS INT;
DECLARE CANTIDAD_ACTUAL_lOTE INT;
DECLARE CANTIDAD_DISPONIBLE_LOTE INT;

#SE OBTIENE EL ID DE LA ENTRADA CON EL LOTE INGRESADO
#SE OBTIENE LA CANTIDAD DISPONIBLE DEL LOTE UNO
SET @ID_ENTRADA := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE_UNO);
SET @CANTIDAD_DISPONIBLE_LOTE := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA);

#SE OBTIENE EL ID DE LA ENTRADA CON EL LOTE INGRESADO
#SE OBTIENE LA CANTIDAD DISPONIBLE DEL LOTE DOS
SET @ID_ENTRADA_DOS := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE_DOS);
SET @CANTIDAD_DISPONIBLE_LOTE_DOS := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA_DOS );

#SUMA DE LA CANTIDAD DE LOTES 1 Y 2 Y SE SACA LA CANTIDAD FALTANTE PARA COMPLETAR LA CANTIDAD REQUEDIDA
SET @CANTIDAD_LOTE_UNO_Y_DOS =  @CANTIDAD_DISPONIBLE_LOTE_DOS + @CANTIDAD_DISPONIBLE_LOTE;
SET @CANTIDAD_FALTANTE= CANTIDAD - @CANTIDAD_LOTE_UNO_Y_DOS;

SET @ID_ENTRADA_TRES := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote = LOTE_TRES);
SET @CANTIDAD_DISPONIBLE_LOTE_TRES := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA_TRES);
SET @CANTIDAD_ACTUAL_lOTE =  @CANTIDAD_DISPONIBLE_LOTE_TRES -@CANTIDAD_FALTANTE;



IF ( (CANTIDAD - @CANTIDAD_LOTE_UNO_Y_DOS) > 0 ) Then

#SE INGRESA LAS SALIDAS DE LOS 3 LOTES DIFERENTES
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA,@CANTIDAD_DISPONIBLE_LOTE,curdate(),FOLIO_VENTA);
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA_DOS,@CANTIDAD_DISPONIBLE_LOTE_DOS,curdate(),FOLIO_VENTA);
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA_TRES,@CANTIDAD_FALTANTE,curdate(),FOLIO_VENTA);
SELECT 1;

END IF;

BEGIN

#SI LA CANTIDAD FALTANTE ES MAYOR A CERO LOS 2 PRIMEROS LOTES NO SON SUFICIENTES
#SE ACTUALIZA EL ESTADO DE LOS LOTES Y SE MODIFICA LA CANTIDAD DISPONIBLE DEL LOTE
IF @CANTIDAD_FALTANTE > 0 THEN 
        UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= @ID_ENTRADA;
        UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= @ID_ENTRADA_DOS;
        
#SE LE RESTA LA CANTIDAD DISPOIBLE DE LOTE A LA QUE FALTA PARA COMPLETAR 
#SI ES MAYOR A CERO QUIERE DECIR QUE TODAVIA HAY PIEZAS DISPONIBLE EN EL LOTE
#SE ACTUALIZA LA CANTIDAD DISPONIBLE
# EN CASO DE QUE NO SEA MAYOR A CERO SE ACTUALIZA EL ESTATUS A AGOTADO Y LA CANTIDAD DISPIBLE A CERO
IF  ((@CANTIDAD_DISPONIBLE_LOTE_TRES -  @CANTIDAD_FALTANTE) > 0)  THEN
		UPDATE prod_ter_entradas set 
		cantidad_disponible = @CANTIDAD_ACTUAL_lOTE
		where prod_ter_entradas.id_entrada = @ID_ENTRADA_TRES;
	ELSE
		UPDATE prod_ter_entradas set 
		cantidad_disponible = 0,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada = @ID_ENTRADA_TRES;
	END IF;
    
    
END IF;


end;


END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_UN_LOTE`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_UN_LOTE` (IN `ID_PRODUCTO` INT, IN `LOTE` VARCHAR(50), IN `CANTIDAD` INT, IN `FOLIO_VENTA` VARCHAR(45))  BEGIN
SET @ID_ENTRADA := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
INSERT INTO prod_ter_salidas(id_producto,id_entrada,cantidad,fecha_salida,folio_venta)
values (ID_PRODUCTO,@ID_ENTRADA,CANTIDAD,curdate(),FOLIO_VENTA);
SELECT 1;

begin
SET @ID_ENTRADA := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
SET @CANTIDAD_DISPONIBLE := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.id_entrada =@ID_ENTRADA );
SET @CANTIDAD_ACTUAL_DISPONIBLE = (@CANTIDAD_DISPONIBLE - CANTIDAD);

IF @CANTIDAD_ACTUAL_DISPONIBLE = 0 THEN 
        UPDATE prod_ter_entradas set 
		cantidad_disponible = @CANTIDAD_ACTUAL_DISPONIBLE,
        estatus = 'AGOTADO'
		where prod_ter_entradas.id_entrada= @ID_ENTRADA;
	ELSE
		UPDATE prod_ter_entradas set 
		cantidad_disponible = @CANTIDAD_ACTUAL_DISPONIBLE
		where prod_ter_entradas.id_entrada = @ID_ENTRADA;
END IF;
end;
END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_USUARIO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_USUARIO` (IN `USUARIO` VARCHAR(15), IN `PASS` VARCHAR(250), IN `MAIL` VARCHAR(250), IN `IDPERSONA` INT, IN `IDROL` INT, IN `RUTA` VARCHAR(250))  BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM usuario where usuario_nombre=USUARIO or usuario_mail = MAIL);
if @CANTIDAD = 0 THEN
INSERT INTO usuario(usuario_nombre,usuario_password,usuario_mail,usuario_intento,usuario_status,rol_id,usuario_img,id_persona)
values (USUARIO,PASS,MAIL,1,'ACTIVO',IDROL,RUTA,IDPERSONA);
SELECT 1;
else
SELECT 2;
END IF;
END$$

DROP PROCEDURE IF EXISTS `SP_TRAER_DATOS_USUARIO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAER_DATOS_USUARIO` (IN `ID` INT)  BEGIN
select usuario.usuario_id,
usuario.usuario_nombre,
usuario.usuario_password,
usuario.usuario_intento,
usuario.usuario_status,
usuario.rol_id,
usuario.usuario_img,
rol.rol_nombre,
persona.persona_nombre,
persona.persona_apepat,
persona.persona_apemat,
persona.persona_sexo,
persona.persona_estatus
FROM usuario
INNER JOIN
rol
on
usuario.rol_id = rol.rol_id
inner join persona
on
usuario.id_persona = persona.id_persona
where usuario_id = ID;
END$$

DROP PROCEDURE IF EXISTS `SP_TRAER_STOCK_PRODUCTO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAER_STOCK_PRODUCTO` (IN `ID` INT)  BEGIN
select stock from prod_ter_inventario where id_producto=ID;
END$$

DROP PROCEDURE IF EXISTS `SP_VERIFICAR_USUARIO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VERIFICAR_USUARIO` (IN `USUARIO` VARCHAR(15))  SELECT * FROM usuario WHERE usuario_nombre = USUARIO$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia`
--

DROP TABLE IF EXISTS `materia`;
CREATE TABLE IF NOT EXISTS `materia` (
  `id_materia` int(11) NOT NULL AUTO_INCREMENT,
  `materia_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `materia_no_control` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `id_molino` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_materia`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `molienda`
--

DROP TABLE IF EXISTS `molienda`;
CREATE TABLE IF NOT EXISTS `molienda` (
  `id_molienda` int(11) NOT NULL AUTO_INCREMENT,
  `molienda_no_control` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_corte` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_fecha_entrada` date DEFAULT NULL,
  `molienda_hora_entrada` time NOT NULL,
  `molienda_kg_ingresados` double DEFAULT NULL,
  `molienda_no_malla` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_fecha_salida` date DEFAULT NULL,
  `molienda_hora_salida` time DEFAULT NULL,
  `molienda_tamizado` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_polvo` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_te` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_merma` double DEFAULT NULL,
  `molienda_rendimiento` double DEFAULT NULL,
  `id_materia` int(11) DEFAULT NULL,
  `id_molino` int(11) DEFAULT NULL,
  `molienda_observaciones` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_img_url` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `molienda_status` enum('FINALIZADO') COLLATE utf8_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id_molienda`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `molinos`
--

DROP TABLE IF EXISTS `molinos`;
CREATE TABLE IF NOT EXISTS `molinos` (
  `id_molino` int(11) NOT NULL AUTO_INCREMENT,
  `molino_no_molino` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id_molino`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

DROP TABLE IF EXISTS `persona`;
CREATE TABLE IF NOT EXISTS `persona` (
  `id_persona` int(11) NOT NULL AUTO_INCREMENT,
  `persona_nombre` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `persona_apepat` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `persona_apemat` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `persona_sexo` enum('MASCULINO','FEMENINO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `persona_fregistro` date DEFAULT NULL,
  `persona_estatus` enum('ACTIVO','INACTIVO') COLLATE utf8_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id_persona`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_persona`, `persona_nombre`, `persona_apepat`, `persona_apemat`, `persona_sexo`, `persona_fregistro`, `persona_estatus`) VALUES
(11, 'Oscar Alexis', 'Rosales', 'Rodrigo', 'MASCULINO', '2022-04-26', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

DROP TABLE IF EXISTS `producto`;
CREATE TABLE IF NOT EXISTS `producto` (
  `id_producto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL,
  `linea` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id_producto`, `nombre`, `linea`) VALUES
(1, 'HSH ALCACHOFA HSH - 60 CAPS 50Omg', 'HS'),
(2, 'HSH ASHWAGANDHA MIX - 60 CAPS 500mg', NULL),
(3, 'HSH CAR-D HERBAL - 60 CAPS 500mg', 'HS'),
(4, 'HSH CHIA SEED FIBER - 60 CAPS 500mg ', 'HS'),
(5, 'HSH CICLO FEMALE - 60 CAPS 50Omg', 'VT'),
(6, 'HSH CIR Q ACTIV - 60CAPS 50Omg', 'HS'),
(7, 'HSH CURCUMA MIX - 60 CAPS 500mg', 'HS'),
(8, 'HSH DB HERBAL - 60 CAPS 500mg', 'HS'),
(9, 'HSH DIGEST CLEAN FIBER - 60 CAPS 500mg', 'HS'),
(10, 'HSH ENER VITAL - 60 CAPS 500mg', NULL),
(11, 'HSH FEMENINE FORMULA - 60 CAPS 500mg', NULL),
(12, 'HSH HERBAL DG-S - 60 CAPS 500mg', NULL),
(13, 'HSH HERBAL FEM - 60 CAPS 500mg', NULL),
(14, 'HSH HERBAL FLX - 60 CAPS 800mg', NULL),
(15, 'HSH HERBAL GAX-3 - 60 CAPS 500mg', NULL),
(16, 'HSH HERBAL PRS - 60 CAPS 500mg', NULL),
(17, 'HSH HERBAL RLX - 60 CAPS 500mg', NULL),
(18, 'HSH HERBAL SKIN - 60 CAPS 500mg', NULL),
(19, 'HSH HERBALINAZA PREMIUM - 90 CAPS 500mg', NULL),
(20, 'HSH HP LIV PLUS - 60 CAPS 500mg', NULL),
(21, 'HSH INULINA DE AGAVE - 60 CAPS 500mg', NULL),
(22, 'HSH KETONE RASPBERRY - 60 CAPS 500mg', NULL),
(23, 'HSH LIVEX PLUS - 60 CAPS 500mg', NULL),
(24, 'HSH MEN\'S PRO - 60 CAPS 500mg', NULL),
(25, 'HSH MORINGA - 60 CAPS 500mg', NULL),
(26, 'HSH MULTICOMPLEX - 60 CAPS 900mg', NULL),
(27, 'HSH NCPU - 60 CAPS 500mg', NULL),
(28, 'HSH PAR SICLEAN - 60 CAPS 500mg', NULL),
(29, 'HSH PENTRE HERBAL - 60 CAPS 500mg', NULL),
(30, 'HSH PIÑA HERBAL - 60 CAPS 500mg', NULL),
(31, 'HSH P-MEN FRASCO 60 CAPS 500mg', NULL),
(32, 'HSH PROCEL OX - 60 CAPS 500mg', NULL),
(33, 'HSH RD FAST - 60 CAPS 500mg', NULL),
(34, 'HSH REU+DOL - 60 CAPS 500mg', NULL),
(35, 'HSH RNA HERBAL - 60 CAPS 500mg', NULL),
(36, 'HSH SUPER CLEANSE PROGRAMA DESINTOXICADOR', NULL),
(37, 'HSH SUPER OMEGA - 60 SOFTGELS 1.4gr', NULL),
(38, 'HSH SUPER VITAL PROGRAMA NUTRICIONAL', NULL),
(39, 'HSH VITAMINA D3 - 60 SOFTGELS 650mg', NULL),
(40, 'HSH VITAMINA E - 30 SOFTGELS 1.2gr', NULL),
(41, 'HSH DMX CAJA - 4 CAPS 500mg', NULL),
(42, 'NV AJO - 50CAPS 500mg ', NULL),
(43, 'NV ALCACHOFA - 50 CAPS 500mg', NULL),
(44, 'NV ALFALFA - 50 CAPS 500mg', NULL),
(45, 'NV ALGA SPIRULINA - 50 CAPS 500mg', NULL),
(46, 'NV ANGELICA - 50 CAPS 500mg', NULL),
(47, 'NV ARNICA - 50 CAPS 500mg', NULL),
(48, 'NV BAYAS DE ENEBRO - 50 CAPS 50Omg', NULL),
(49, 'NV BAYAS DE ESPINO - 50 CAPS 500mg ', NULL),
(50, 'NV BERGAMOTA - 50 CAPS 50Omg', NULL),
(51, 'NV BOLDO - 50 CAPS 50Omg', NULL),
(52, 'NV CABELLO DE MAIZ - 50 CAPS 500mg ', NULL),
(53, 'NV CALCIO DE CORAL - 50 CAPS 500mg ', NULL),
(54, 'NV CANCERINA - 50 CAPS 50Omg ', NULL),
(55, 'NV CARBON ACTIVADO - 50 CAPS 320mg', NULL),
(56, 'NV CARDO MARIANO - 50 CAPS 500mg', NULL),
(57, 'NV CARTILAGO DE TIBURON - 50 CAPS 500mg', NULL),
(58, 'NV CASCARA SAGRADA - 50 CAPS 500mg', NULL),
(59, 'NV CASTAÑO DE INDIAS - 50 CAPS 500mg', NULL),
(60, 'NV CHANCA PIEDRA - 50 CAPS 50Omg', NULL),
(61, 'NV COLA DE CABALLO - 50 CAPS 50Omg ', NULL),
(62, 'NV COLAGENO HIDROLIZADO - 50 CAPS 500mg', NULL),
(63, 'NV CUACHALALATE - 50 CAPS 500mg ', NULL),
(64, 'NV CURCUMA TURMERIC - 50 CAPS 500mg', NULL),
(65, 'NV DAMIANA DE CALIFORNIA - 50 CAPS 500mg', NULL),
(66, 'NV DIENTE DE LEON - 50 CAPS 500mg', NULL),
(67, 'NV EQUINACEA - 50 CAPS 500mg', NULL),
(68, 'NV EUFRASIA - 50 CAPS 500mg', NULL),
(69, 'NV FENOGRECO - 50 CAPS 500mg', NULL),
(70, 'NV FLOR DE AZAHAR - 50 CAPS 500mg', NULL),
(71, 'NV GARCINIA CAMBOGIA - 50 CAPS 500mg', NULL),
(72, 'NV GARRA DEL DIABLO - 50 CAPS 500mg', NULL),
(73, 'NV GINKGO BILOBA - 50 CAPS 500mg', NULL),
(74, 'NV GUANABANA - 50 CAPS 500mg', NULL),
(75, 'NV HIERBA DE SAN JUAN - 50 CAPS 500mg', NULL),
(76, 'NV HIERBA DEL SAPO - 50 CAPS 500mg', NULL),
(77, 'NV HOJA DE GUAYABA - 50 CAPS 500mg', NULL),
(78, 'NV JENGIBRE - 50 CAPS 50Omg', NULL),
(79, 'NV LECITINA DE SOYA - 50 CAPS 500mg', NULL),
(80, 'NV LEVADURA DE CERVEZA - 50 CAPS 500mg', NULL),
(81, 'NV MACA - 50 CAPS 500mg', NULL),
(82, 'NV NEEM - 50 CAPS 500mg', NULL),
(83, 'NV NOPAL - 50 CAPS 500mg ', NULL),
(84, 'NV ORTIGA - 50 CAPS 500mg', NULL),
(85, 'NV PALO AZUL - 50 CAPS 500mg', NULL),
(86, 'NV PALO DE ARCO - 50 CAPS 500mg', NULL),
(87, 'NV PASIFLORA - 50 CAPS 500mg', NULL),
(88, 'NV PATA DE VACA - 50 CAPS 500mg', NULL),
(89, 'NV POLEN - 50 CAPS 500mg', NULL),
(90, 'NV PULMONARIA - 50 CAPS 500mg', NULL),
(91, 'NV SABILA - 50 CAPS 500mg', NULL),
(92, 'NV SANGRE DE DRAGO - 50 CAPS 500mg', NULL),
(93, 'NV TEJOCOTE - 50 CAPS 500mg', NULL),
(94, 'NV TEJOCOTE – 18 PZS', NULL),
(95, 'NV UÑA DE GATO - 50 CAPS 500mg', NULL),
(96, 'NV UVA URSI - 50 CAPS 500mg', NULL),
(97, 'NV VALERIANA - 50 CAPS 500mg', NULL),
(98, 'NV WEREKE - 50 CAPS 500mg', NULL),
(99, 'NV ZARZAPARRILLA - 50 CAPS 500mg', NULL),
(100, 'SF SUPERFIT CAPSULAS ', NULL),
(101, 'HSH TE BAILARINA 25 SOBRES DE 2gr C/U', NULL),
(102, 'HSH TE CHINO 25 SOBRES DE 2gr C/U', NULL),
(103, 'HSH TE CIR-Q HERBAL 25 SOBRES DE 2gr C/U', NULL),
(104, 'HSH TE DB HERBAL 25 SOBRES DE 2gr C/U', NULL),
(105, 'HSH TE DE ALCACHOFA 25 SOBRES DE 2gr C/U', NULL),
(106, 'HSH TE DE BRASIL 25 SOBRES DE 2gr C/U', NULL),
(107, 'HSH TE DE MORINGA 25 SOBRES DE 2gr C/U', NULL),
(108, 'HSH TE DG-S HERBAL 25 SOBRES DE 2gr C/U', NULL),
(109, 'HSH TE DMX HERBAL 25 SOBRES DE 2gr C/U', NULL),
(110, 'HSH TE HERBAL GAX-3 25 SOBRES DE 2gr C/U', NULL),
(111, 'HSH TE HERBAL RLX 25 S0BRES DE 2gr C/U', NULL),
(112, 'HSH TE HERBAL TOX 25 SOBRES DE 2gr C/U', NULL),
(113, 'HSH TE HP-A HERBAL 25 SOBRES DE 2gr C/U', NULL),
(114, 'HSH TE LIVEX PLUS 25 SOBRES 2gr C/U', NULL),
(115, 'HSH TE MEN\'S PRO 25 SOBRES DE 2gr C/U', NULL),
(116, 'HSH TE PIÑA HERBAL 25 SOBRES DE 2gr C/U', NULL),
(117, 'HSH TE P-MEN 25 SOBRES DE 2gr C/U', NULL),
(118, 'HSH TE PULMONAR 25 SOBRES DE 2gr C/U', NULL),
(119, 'HSH TE RNA HERBAL 25 SOBRES DE 2gr C/U', NULL),
(120, 'NV TE DE ARNICA 25 SOBRES 1.5gr C/U', NULL),
(121, 'NV TE DE CARDO MARIANO 25 SOBRES 1.5gr C/U', NULL),
(122, 'NV TE DE CASTAÑO DE INDIAS 25 SOBRES 1.5gr C/U', NULL),
(123, 'NV TE DE CHANCA PIEDRA 25 SOBRES 1.5gr C/U', NULL),
(124, 'NV TE DE COLA DE CABALLO 25 SOBRES 1.5gr C/U', NULL),
(125, 'NV TE DE CUACHALALATE 25 SOBRES 1.5gr C/U', NULL),
(126, 'NV TE DE DAMIANA DE CALIFORNIA 25 SOBRES 1.5gr C/U', NULL),
(127, 'NV TE DE DIENTE DE LEÓN 25 SOBRES 1.5gr C/U', NULL),
(128, 'NV TE DE EUCALIPTO 25 SOBRES 1.5gr C/U', NULL),
(129, 'NV TE DE GINKGO BILOBA 25 SOBRES 1.5gr C/U', NULL),
(130, 'NV TE DE GORDOLOBO 25 SOBRES 1.5gr C/U', NULL),
(131, 'NV TE DE GUANABANA 25 SOBRES DE 2gr C/U', NULL),
(132, 'NV TE DE HIERBA DEL SAPO 25 SOBRES 1.5gr C/U', NULL),
(133, 'NV TE DE HOJA DE GUAYABA 25 SOBRES 2gr C/U', NULL),
(134, 'NV TE DE JENGIBRE 25 SOBRES 1.5gr C/U', NULL),
(135, 'NV TE DE LEVADURA DE CERVEZA 25 SOBRES 1.5gr C/U', NULL),
(136, 'NV TE DE ORTIGA 25 SOBRES 1.5gr C/U', NULL),
(137, 'NV TE DE PALO AZUL 25 SOBRES 1.5gr C/U', NULL),
(138, 'NV TE DE PASIFLORA 25 SOBRES 1.5gr C/U', NULL),
(139, 'NV TE DE PATA DE VACA 25 SOBRES 1.5gr C/U', NULL),
(140, 'NV TE DE PULMONARIA 25 SOBRES 1.5gr C/U', NULL),
(141, 'NV TE DE TEJOCOTE 25 SOBRES 2gr C/U', NULL),
(142, 'NV TE DE SANGRE DE DRAGO 25 SOBRES 1.5gr C/U', NULL),
(143, 'NV TE DE VALERIANA 25 SOBRES 1.5gr C/U', NULL),
(144, 'NV TE DE WEREKE 25 SOBRES 1.5gr C/U', NULL),
(145, 'SF TE CAFE SUPER FIT 25 SOBRES 1.5g C/U', NULL),
(146, 'HSH ALCACHOFA SLIMMING - 454gr', NULL),
(147, 'HSH ALPISCHIA MILK - 500gr', NULL),
(148, 'HSH ALPISTE MILK - 500gr', NULL),
(149, 'HSH CHIA SEED FIBER - 350gr', NULL),
(150, 'HSH DIGEST CLEAN – 450gr', NULL),
(151, 'HSH FIBRA CON PIÑA – 454gr', NULL),
(152, 'HSH GLUKO SOYA CHOCOLATE – 454gr', NULL),
(153, 'HSH GLUKO SOYA FRESA – 454gr', NULL),
(154, 'HSH HERBALINAZA PREMIUM – 454gr', NULL),
(155, 'HSH INULINA DE AGAVE PREMIUM – 200gr', NULL),
(156, 'HSH J-VENESS FRESA – 200gr', NULL),
(157, 'HSH J-VENESS NARANJA - 200gr', NULL),
(158, 'HSH J-VENESS PIÑA 200gr', NULL),
(159, 'HSH ALCACHOFA SLIM SHAKE CAPUCHINO - 454gr', NULL),
(160, 'HSH ALCACHOFA SLIM SHAKE FRESA – 454gr', NULL),
(161, 'HSH DB SHAKE MALTEADA FRESA – 454gr', NULL),
(162, 'HSH GANO SHAKE CHOCOLATE – 454gr', NULL),
(163, 'HSH NUTRI COMPLETE SHAKE – 454gr ', NULL),
(164, 'SF SUPER FIT FIBER MARACUYA – 454gr', NULL),
(165, 'SF SUPER FIT PROTEIN – 454gr', NULL),
(166, 'SF SUPER FIT SHAKE – 454gr', NULL),
(167, 'HSH CLOROFILA C/SABILA Y NOPAL - 500ml', NULL),
(168, 'HSH NONI C/MANGOSTEEN - 500ml', NULL),
(169, 'HSH JARABE AOXICELL KIDS - 250ml', NULL),
(170, 'HSH JARABE HERBAL TOX - 250ml', NULL),
(171, 'HSH JARABE PAR SIKIDS - 250ml', NULL),
(172, 'HSH JARABE PENTRECI KIDS - 250ml', NULL),
(173, 'HSH JARABE STAR KIDS - 250ml', NULL),
(174, 'HSH CREMA CONTRADOL - 250gr', NULL),
(175, 'HSH CREMA PARA PIES - 90gr', NULL),
(176, 'HSH CREMA R+DOL - 90gr', NULL),
(177, 'HSH CREMA ZINEXTRI BODY CREAM - 100gr (3.5 oz)', NULL),
(178, 'HSH GEL ANTIBACTERIAL HERBAL - 120ml', NULL),
(179, 'HSH GEL ANTIBACTERIAL HERBAL - 1L (33.81 oz)', NULL),
(180, 'HSH GEL ANTIBACTERIAL HERBAL - 4L (135.25 oz)', NULL),
(181, 'HSH GEL CALENDULA - 150gr (5.3 oz)', NULL),
(182, 'HSH GEL CIR Q ACTIV BODY GEL - 150gr', NULL),
(183, 'HSH GEL CORPORAL ALGA MARINA - 250gr', NULL),
(184, 'HSH GEL CORPORAL DE PIÑA - 250gr', NULL),
(185, 'HSH GEL CORPORAL DE TORONJA - 250gr', NULL),
(186, 'HSH GEL HERBAL CLEAR FACIAL - 150gr', NULL),
(187, 'HSH GEL LUB V FEMENINE - 100gr (3.5 oz)', NULL),
(188, 'HSH GEL TEPEZCOHUITE - 150gr (5.3 oz)', NULL),
(189, 'HSH POMADA ARNICA BALSAM - 120gr', NULL),
(190, 'HSH LOCION DE UÑAS - 20ml', NULL),
(191, 'HSH LOCION HERBAL SIN MOSKO - 130ml (4.4 oz)', NULL),
(192, 'HSH ACEITE CAPILAR DE BERGAMOTA - 130 ml (4.4 oz)', NULL),
(193, 'HSH ACEITE CAPILAR DE COCO - 130ml (4.4 oz)', NULL),
(194, 'HSH SHAMPOO ACEITE DE COCO - 500ml', NULL),
(195, 'HSH ACONDICIONADOR NATURAL CHANGE - 500ml', NULL),
(196, 'HSH SHAMPOO BERGAMOTA Y MACADAMIA - 500ml', NULL),
(197, 'HSH SHAMPOO C/EXT. CACAHUANANCHE Y S.D. - 500ml', NULL),
(198, 'HSH SHAMPOO C/EXT. CHILE, NOPAL Y ROM - 500ml', NULL),
(199, 'HSH SHAMPOO C/EXT. ESPINOSILLA, AJO Y T - 500ml', NULL),
(200, 'HSH SHAMPOO NATURAL CHANGE - 500ml', NULL),
(201, 'CREMA BABA DE CARACOL - 120gr', NULL),
(202, 'CREMA CONCHA NACAR - 120gr', NULL),
(203, 'CREMA HIDRATANTE CON PEPINO Y SABILA - 120gr', NULL),
(204, 'CREMA J-VENESS CON JALEA REAL 60gr', NULL),
(205, 'NV GUANABANA - 500ml', NULL),
(206, 'NV PROPOLEO EXTRACTO – 40ml', NULL),
(207, 'NV INFUSION DIENTE DE LEON – 65gr', NULL),
(208, 'NV INFUSION EUCALIPTO – 100gr', NULL),
(209, 'NV INFUSION FLOR DE AZAHAR – 95gr', NULL),
(210, 'NV INFUSION GORDOLOBO – 72gr', NULL),
(211, 'NV INFUSION HIERBA DEL SAPO – 70gr', NULL),
(212, 'NV INFUSION HOJA SEN – 110gr', NULL),
(213, 'NV INFUSION PALO AZUL – 200gr', NULL),
(214, 'NV INFUSION PALO DE VIVORA – 150gr', NULL),
(215, 'NV INFUSION PASIFLORA – 100gr', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prod_ter_entradas`
--

DROP TABLE IF EXISTS `prod_ter_entradas`;
CREATE TABLE IF NOT EXISTS `prod_ter_entradas` (
  `id_entrada` int(11) NOT NULL AUTO_INCREMENT,
  `id_producto` int(11) DEFAULT NULL,
  `lote` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha_caducidad` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha_entrada` date DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `cantidad_disponible` int(11) NOT NULL,
  `estatus` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id_entrada`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Disparadores `prod_ter_entradas`
--
DROP TRIGGER IF EXISTS `after_entradas_insert`;
DELIMITER $$
CREATE TRIGGER `after_entradas_insert` AFTER INSERT ON `prod_ter_entradas` FOR EACH ROW BEGIN
DECLARE CANTIDAD_ENTRADA INT;
DECLARE CANTIDAD_SALIDA INT;
DECLARE Stock INT;
DECLARE ID INT;
DECLARE ID_EXIST INT;
DECLARE SALIDAS_EXIST INT;

SET @ID := (SELECT id_prod_ter_inventario FROM prod_ter_inventario where id_producto =new.id_producto);
SET @SALIDAS_EXIST := (SELECT COUNT(id_prod_ter_salidas) FROM prod_ter_salidas WHERE id_producto =new.id_producto);
SET @ID_EXIST := (SELECT COUNT(id_prod_ter_inventario) FROM prod_ter_inventario WHERE id_producto = new.id_producto);
SET @CANTIDAD_ENTRADA:= (SELECT sum(cantidad) FROM prod_ter_entradas where id_producto=new.id_producto);
SET @CANTIDAD_SALIDA:= (SELECT sum(cantidad) FROM prod_ter_salidas where id_producto=new.id_producto);
set @Stock = @CANTIDAD_ENTRADA-@CANTIDAD_SALIDA;

IF @ID_EXIST = 0  THEN
	IF @SALIDAS_EXIST = 0 THEN
    INSERT INTO prod_ter_inventario(id_producto,stock)values(new.id_producto,@CANTIDAD_ENTRADA);
    ELSE
    INSERT INTO prod_ter_inventario(id_producto,stock)values(new.id_producto,@Stock);
    END IF;
ELSE
	IF @SALIDAS_EXIST = 0 THEN
    UPDATE prod_ter_inventario set
    stock=@CANTIDAD_ENTRADA
    where id_prod_ter_inventario=@ID;
    ELSE
    UPDATE prod_ter_inventario set 
	stock= @Stock
	where 
    id_prod_ter_inventario=@ID;
    END IF;
END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prod_ter_inventario`
--

DROP TABLE IF EXISTS `prod_ter_inventario`;
CREATE TABLE IF NOT EXISTS `prod_ter_inventario` (
  `id_prod_ter_inventario` int(11) NOT NULL AUTO_INCREMENT,
  `id_producto` int(11) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_prod_ter_inventario`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prod_ter_salidas`
--

DROP TABLE IF EXISTS `prod_ter_salidas`;
CREATE TABLE IF NOT EXISTS `prod_ter_salidas` (
  `id_prod_ter_salidas` int(11) NOT NULL AUTO_INCREMENT,
  `id_producto` int(11) DEFAULT NULL,
  `id_entrada` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `fecha_salida` date DEFAULT NULL,
  `folio_venta` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id_prod_ter_salidas`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Disparadores `prod_ter_salidas`
--
DROP TRIGGER IF EXISTS `after_salidas_insert`;
DELIMITER $$
CREATE TRIGGER `after_salidas_insert` AFTER INSERT ON `prod_ter_salidas` FOR EACH ROW BEGIN
DECLARE CANTIDAD_ENTRADA INT;
DECLARE CANTIDAD_SALIDA INT;
DECLARE Stock INT;
DECLARE ID INT;

SET @ID := (SELECT id_prod_ter_inventario FROM prod_ter_inventario where id_producto=new.id_producto);
SET @CANTIDAD_ENTRADA:= (SELECT sum(cantidad) FROM prod_ter_entradas where id_producto = new.id_producto);
SET @CANTIDAD_SALIDA:= (SELECT sum(cantidad) FROM prod_ter_salidas where id_producto= new.id_producto);
set @Stock= @CANTIDAD_ENTRADA-@CANTIDAD_SALIDA;

	UPDATE prod_ter_inventario set 
	stock= @Stock
	where 
    id_prod_ter_inventario=@ID;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

DROP TABLE IF EXISTS `rol`;
CREATE TABLE IF NOT EXISTS `rol` (
  `rol_id` int(11) NOT NULL AUTO_INCREMENT,
  `rol_nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `rol_feregistro` date DEFAULT NULL,
  `rol_status` enum('ACTIVO','INACTIVO') COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`rol_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`rol_id`, `rol_nombre`, `rol_feregistro`, `rol_status`) VALUES
(1, 'ADMIN', NULL, 'ACTIVO'),
(2, 'Jefe de sistemas', '2022-01-06', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `usuario_id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_nombre` varchar(15) COLLATE utf8_spanish_ci NOT NULL,
  `usuario_password` varchar(250) COLLATE utf8_spanish_ci NOT NULL,
  `usuario_mail` varchar(250) COLLATE utf8_spanish_ci NOT NULL,
  `usuario_intento` int(11) NOT NULL,
  `usuario_status` enum('ACTIVO','INACTIVO') COLLATE utf8_spanish_ci NOT NULL,
  `rol_id` int(11) NOT NULL,
  `usuario_img` varchar(250) COLLATE utf8_spanish_ci DEFAULT NULL,
  `id_persona` int(11) DEFAULT NULL,
  PRIMARY KEY (`usuario_id`),
  UNIQUE KEY `usuario_nombre` (`usuario_nombre`),
  UNIQUE KEY `usuario_mail` (`usuario_mail`),
  KEY `rol_id` (`rol_id`),
  KEY `fk_usuario_1_idx` (`id_persona`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`usuario_id`, `usuario_nombre`, `usuario_password`, `usuario_mail`, `usuario_intento`, `usuario_status`, `rol_id`, `usuario_img`, `id_persona`) VALUES
(1, 'ADMIN', '$2y$10$ZnbNrKmS0S4aBZbxkfwXCuFGMKX8GJA8t9kX1cv29ngZIJgWZcvbO\n', 'pruebita@hsh.com', 1, 'INACTIVO', 6, 'controlador/usuario/img/IMG1322022121136.png', 10),
(2, 'oscar', '$2y$10$MWYvDl5m8.CMVEdpW.sEg..kgfqLlVb/.UPYa0pet26qH2TmSNOrK', 'oscar@hsh.com', 1, 'ACTIVO', 1, 'controlador/usuario/img/user_defecto.png', 11),
(3, 'Maria', '$2y$10$cQz0Xy9GfYMfX1YGa/RCR..W6fnuvvfGQgytomaisozL2aAKhQBd2', 'maria@gmail.com', 1, 'ACTIVO', 3, 'controlador/usuario/img/IMG1322022121154.png', 2),
(4, 'Pedro', '$2y$10$3Mec.r8yTkX2PKAdbMOki.MoSJPatR7klTmd5reBYZSqF5Ap.iGc2', 'pedro@gmail.com', 1, 'ACTIVO', 3, 'controlador/usuario/img/user_defecto.png', 3),
(5, 'Arturo', '$2y$10$sMFPggiV7nb7SuSch17Xkuu2oismmZjCPMcBul2pZ0Ke5JJiPmEEa', 'arturo@gmail.com', 1, 'ACTIVO', 6, 'controlador/usuario/img/user_defecto.png', 10),
(6, 'Gabriel', '$2y$10$b0wXVse4hHlozVut5JWmYOH.BeTW3MGBhRveVQlUrsqO499sT8Bkq', 'gabriel@gmail.com', 1, 'ACTIVO', 5, 'controlador/usuario/img/IMG72202212345.png', 4);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`),
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`rol_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
