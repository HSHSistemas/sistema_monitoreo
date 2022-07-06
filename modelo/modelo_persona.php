<?php

    class Modelo_Persona{
        private $conexion;

        function __construct(){

            require_once 'modelo_conexion.php';
            $this->conexion = new conexion();
            $this->conexion->conectar();
        }
        
        function Listar_Persona()
        {
            $sql = "call SP_LISTAR_PERSONA()";
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

        function Registrar_Persona($nombre,$appa,$apma,$sexo)
        {
            $sql = "call SP_REGISTRAR_PERSONA('$nombre','$appa','$apma','$sexo')";
            if ($consulta = $this->conexion->conexion->query($sql))
            {
                if ($row = mysqli_fetch_array($consulta)){
                    $respuesta = trim($row[0]);
                    return  $respuesta;
                }
                $this->conexion->cerrar();
            }
        }


        function Editar_Persona($id,$nombre,$appa,$apma,$documentoactual, $documentonuevo,$tdocumento,$sexo,$telefono,$status)
        {
            $sql = "call SP_EDITAR_Persona('$id','$nombre','$appa','$apma','$documentoactual','$documentonuevo','$tdocumento','$sexo','$telefono','$status')";
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