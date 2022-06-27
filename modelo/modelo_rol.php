<?php

    class Modelo_Rol{
        private $conexion;

        function __construct(){

            require_once 'modelo_conexion.php';
            $this->conexion = new conexion();
            $this->conexion->conectar();
        }
        
        function Listar_Rol()
        {
            $sql = "call SP_LISTAR_ROL()";
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

        function Registrar_Rol($rol)
        {
            $sql = "call SP_REGISTRAR_ROL('$rol')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }


        function Modificar_Rol($id,$rolactual,$rolnuevo,$status)
        {
            $sql = "call SP_EDITAR_ROL('$id','$rolactual','$rolnuevo','$status')";
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