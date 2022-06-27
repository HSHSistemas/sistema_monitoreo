<?php

    class Modelo_Producto_terminado{
        private $conexion;

        function __construct(){

            require_once 'modelo_conexion.php';
            $this->conexion = new conexion();
            $this->conexion->conectar();
        }
        
        function Listar_Producto()
        {
            $sql = "call SP_LISTAR_PRODUCTO()";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                while($consulta_vu = mysqli_fetch_assoc($consulta))
                {
                   
                    $arreglo["data"][]= $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }


        function Listar_Combo_Producto()
        {
            $sql = "call SP_LISTAR_PRODUCTO_DOS()";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql)) {
                while ($consulta_vu = mysqli_fetch_array($consulta)) {
    
                    $arreglo[] = $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }

        function Listar_Combo_Producto_Lotes($id_producto)
        {
            $sql = "call SP_LISTAR_PRODUCTO_LOTES('$id_producto')";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql)) {
                while ($consulta_vu = mysqli_fetch_array($consulta)) {
    
                    $arreglo[] = $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }

        function Listar_Combo_Producto_Lotes_Dos($id_producto)
        {
            $sql = "call SP_LISTAR_PRODUCTO_LOTES_DOS('$id_producto')";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql)) {
                while ($consulta_vu = mysqli_fetch_array($consulta)) {
    
                    $arreglo[] = $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }

        function Listar_Datos_Restantes_Producto($id_entrada)
        {
            $sql = "call SP_LISTAR_DATOS_RESTANTE_PRODUCTO('$id_entrada')";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql)) {
                while ($consulta_vu = mysqli_fetch_array($consulta)) {
    
                    $arreglo[] = $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }

        function Listar_Entrada_Producto()
        {
            $sql = "call SP_LISTAR_ENTRADA_PRODUCTO()";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                while($consulta_vu = mysqli_fetch_assoc($consulta))
                {
                   
                    $arreglo["data"][]= $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }

        function Listar_Salidas_Producto()
        {
            $sql = "call SP_LISTAR_SALIDAS_PRODUCTO()";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                while($consulta_vu = mysqli_fetch_assoc($consulta))
                {
                   
                    $arreglo["data"][]= $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }

        function Registrar_Entrada_Producto_Terminado($id_producto,$lote,$cantidad,$fecha_caducidad)
        {
            $sql = "call SP_REGISTRAR_ENTRADA_PRODUCTO_TERMINADO('$id_producto','$lote','$cantidad','$fecha_caducidad')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }


        function Registrar_Salida_Producto_Terminado($id_producto,$id_entrada,$cantidad,$folio_venta)
        {
            $sql = "call SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO('$id_producto','$id_entrada','$cantidad','$folio_venta')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }

        function Registrar_Salida_Producto_Terminado_Un_Lote($id_producto,$lote,$cantidad,$folio_venta)
        {
            $sql = "call SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_UN_LOTE('$id_producto','$lote','$cantidad','$folio_venta')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }

        function Registrar_Salida_Producto_Terminado_Dos_Lotes($id_producto,$lote,$lote_dos,$cantidad,$folio_venta)
        {
            $sql = "call SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_DOS_LOTES('$id_producto','$lote','$lote_dos','$cantidad','$folio_venta')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }

        function Registrar_Salida_Producto_Terminado_Tres_Lotes($id_producto,$lote,$lote_dos,$lote_tres,$cantidad,$folio_venta)
        {
            $sql = "call SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_TRES_LOTES('$id_producto','$lote','$lote_dos','$lote_tres','$cantidad','$folio_venta')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }

        function Registrar_Salida_Producto_Terminado_Cuatro_Lotes($id_producto,$lote,$lote_dos,$lote_tres,$lote_cuatro,$cantidad,$folio_venta)
        {
            $sql = "call SP_REGISTRAR_SALIDA_PRODUCTO_TERMINADO_CUATRO_LOTES('$id_producto','$lote','$lote_dos','$lote_tres','$lote_cuatro','$cantidad','$folio_venta')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }
        
}

?>