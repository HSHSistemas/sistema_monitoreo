-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-07-2022 a las 19:02:57
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_MATERIA` ()  BEGIN
select materia.id_materia,concat_ws( " ",materia.materia_nombre, materia.materia_no_control) as materia
from materia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_PERSONA` ()  BEGIN
select persona.id_persona,concat_ws( " ",persona.persona_nombre, persona.persona_apepat,persona.persona_apemat)
from persona where persona_estatus = "ACTIVO";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_ROL` ()  BEGIN
select rol.rol_id,rol.rol_nombre
from rol where rol_status = "ACTIVO";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_DATOS_RESTANTE_PRODUCTO` (IN `IDENTRADA` INT)  BEGIN
select fecha_caducidad,cantidad_disponible 
from prod_ter_entradas
 where id_entrada=IDENTRADA;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_DEVOLUCIONES_PRODUCTO` ()  BEGIN
select id_devolucion, prod_ter_entradas.id_entrada, prod_ter_entradas.lote,prod_ter_devoluciones.cantidad, motivo, nombre, prod_ter_entradas.id_producto, fecha
from prod_ter_devoluciones
inner join prod_ter_entradas on prod_ter_devoluciones.id_entrada = prod_ter_entradas.id_entrada
inner join producto on prod_ter_entradas.id_producto = producto.id_producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ENTRADA_PRODUCTO` ()  BEGIN
select id_entrada, producto.id_producto, producto.nombre,lote,fecha_caducidad,fecha_entrada,cantidad
from prod_ter_entradas
inner join producto on prod_ter_entradas.id_producto = producto.id_producto
order by (id_entrada) desc;

END$$

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PERSONA` ()  BEGIN
SELECT concat_ws(' ', persona_nombre,persona_apepat,persona_apemat) as persona, id_persona,persona_nombre,persona_apepat,persona_apemat,persona_sexo,persona_estatus FROM persona ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO` ()  BEGIN
select  producto.id_producto,nombre, stock 
from prod_ter_inventario inner join producto on prod_ter_inventario.id_producto=producto.id_producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO_DOS` ()  BEGIN
select  producto.id_producto AS id,nombre
from producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO_LOTES` (IN `IDPRODUCTO` INT)  BEGIN
select  id_entrada, lote
from prod_ter_entradas
where id_producto=IDPRODUCTO and estatus is null
order by (fecha_entrada)
limit 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PRODUCTO_LOTES_DOS` (IN `IDPRODUCTO` INT)  BEGIN
select  id_entrada, lote, cantidad_disponible
from prod_ter_entradas
where id_producto=IDPRODUCTO and estatus is null
order by (fecha_entrada);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ROL` ()  BEGIN
SELECT rol_id, rol_feregistro,rol_nombre,rol_status FROM rol ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SALIDAS_PRODUCTO` ()  BEGIN
select id_prod_ter_salidas, producto.nombre,prod_ter_entradas.lote,prod_ter_salidas.cantidad, prod_ter_entradas.fecha_caducidad, fecha_salida, folio_venta
from prod_ter_salidas
inner join producto on prod_ter_salidas.id_producto = producto.id_producto
left join prod_ter_entradas on prod_ter_salidas.id_entrada = prod_ter_entradas.id_entrada
order by (id_prod_ter_salidas) DESC;
END$$

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_DEVOLUCION_PRODUCTO_TERMINADO` (IN `LOTE` VARCHAR(50), IN `CANTIDAD` INT, IN `MOTIVO` VARCHAR(255))  BEGIN

DECLARE STOCK_NUEVO INT;
DECLARE CAN_DIS_NUEVA INT;

SET @ID_Producto := (SELECT id_producto FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
SET @ID_Entrada := (SELECT id_entrada FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
SET @Estatus := (SELECT estatus FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
SET @Cantidad_Disponible := (SELECT cantidad_disponible FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
SET @Stock := (SELECT stock FROM prod_ter_inventario where prod_ter_inventario.id_producto = @ID_Producto);


Insert into prod_ter_devoluciones(id_entrada,cantidad,motivo,fecha)values(@ID_Entrada,CANTIDAD,MOTIVO,curdate());
select 1;

Begin

IF  (@Estatus is null )  THEN
		SET @CAN_DIS_NUEVA = @Cantidad_Disponible + CANTIDAD;
		UPDATE prod_ter_entradas set 
		cantidad_disponible = @CAN_DIS_NUEVA
		where prod_ter_entradas.id_entrada = @ID_Entrada;
	ELSE
		UPDATE prod_ter_entradas set 
		cantidad_disponible = CANTIDAD,
        estatus = null
		where prod_ter_entradas.id_entrada = @ID_Entrada;
	END IF;


end;

BEGIN
SET @STOCK_NUEVO = @Stock + CANTIDAD;
UPDATE prod_ter_inventario set
stock = @STOCK_NUEVO
where id_producto = @ID_Producto;

end;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_ENTRADA_PRODUCTO_TERMINADO` (IN `ID_PRODUCTO` INT, IN `LOTE` VARCHAR(50), IN `CANTIDAD` INT, IN `FECHA_CADUCIDAD` DATE)  BEGIN
INSERT INTO prod_ter_entradas(id_producto,lote,fecha_caducidad,fecha_entrada,cantidad,cantidad_disponible)
values (ID_PRODUCTO,LOTE,FECHA_CADUCIDAD,curdate(),CANTIDAD,CANTIDAD);
SELECT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_MOLIENDA` (IN `IDMATERIA` INT, IN `CORTE` VARCHAR(45), IN `KG` DOUBLE, IN `IDMOLINO` INT)  BEGIN
INSERT INTO molienda(molienda_corte,molienda_fecha_entrada,molienda_hora_entrada,molienda_kg_ingresados,id_materia,id_molino)
values (CORTE,curdate(),curtime(),KG,IDMATERIA,IDMOLINO);
SELECT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_PERSONA` (IN `NOMBRE` VARCHAR(100), IN `APEPAT` VARCHAR(50), IN `APEMAT` VARCHAR(50), IN `SEXO` VARCHAR(10))  BEGIN
INSERT INTO persona (persona_nombre, persona_apepat, persona_apemat,persona_sexo,persona_fregistro,persona_estatus)
VALUES (NOMBRE, APEPAT, APEMAT,SEXO,curdate(),'ACTIVO');
SELECT 1;
END$$

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAER_NOMBRE_PRODUCTO` (IN `LOTE` VARCHAR(50))  BEGIN
SET @ID_Producto := (SELECT id_producto FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
select nombre from producto where id_producto=@ID_Producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAER_STOCK_PRODUCTO` (IN `ID` INT)  BEGIN
select stock from prod_ter_inventario where id_producto=ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VERIFICAR_USUARIO` (IN `USUARIO` VARCHAR(15))  SELECT * FROM usuario WHERE usuario_nombre = USUARIO$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prod_ter_devoluciones`
--

CREATE TABLE IF NOT EXISTS `prod_ter_devoluciones` (
  `id_devolucion` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrada` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `motivo` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`id_devolucion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
