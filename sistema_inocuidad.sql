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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_DEVOLUCIONES_PRODUCTO` ()  BEGIN
select id_devolucion, prod_ter_entradas.id_entrada, prod_ter_entradas.lote,prod_ter_devoluciones.cantidad, motivo, nombre, prod_ter_entradas.id_producto, fecha
from prod_ter_devoluciones
inner join prod_ter_entradas on prod_ter_devoluciones.id_entrada = prod_ter_entradas.id_entrada
inner join producto on prod_ter_entradas.id_producto = producto.id_producto;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAER_NOMBRE_PRODUCTO` (IN `LOTE` VARCHAR(50))  BEGIN
SET @ID_Producto := (SELECT id_producto FROM prod_ter_entradas where prod_ter_entradas.lote =LOTE);
select nombre from producto where id_producto=@ID_Producto;
END$$


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
