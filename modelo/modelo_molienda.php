<?php

    class Modelo_Molienda{
        private $conexion;

        function __construct(){

            require_once 'modelo_conexion.php';
            $this->conexion = new conexion();
            $this->conexion->conectar();
        }
        
        function Listar_Molienda()
        {
            $sql = "call SP_LISTAR_MOLIENDA()";
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

        function Listar_Molienda_Historico()
        {
            $sql = "call SP_LISTAR_MOLIENDA_HISTORICO()";
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

        function Listar_combo_materia()
        {
            $sql = "call SP_LISTAR_COMBO_MATERIA()";
            $arreglo = array();
            if ($consulta = $this->conexion->conexion->query($sql)) {
                while ($consulta_vu = mysqli_fetch_array($consulta)) {
    
                    $arreglo[] = $consulta_vu;
                }
                return $arreglo;
                $this->conexion->cerrar();
            }
        }

        function Registrar_Molienda($materia,$corte,$kg,$molino)
        {
            $sql = "call SP_REGISTRAR_MOLIENDA('$materia','$corte','$kg','$molino')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }


        function Editar_Molienda($id,$tamizado, $polvo, $te, $nromalla, $status, $observaciones,$merma,$rendimiento,$ruta)
        {
            $sql = "call SP_EDITAR_MOLIENDA('$id','$tamizado','$polvo','$te','$nromalla','$merma','$rendimiento','$observaciones','$ruta')";
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