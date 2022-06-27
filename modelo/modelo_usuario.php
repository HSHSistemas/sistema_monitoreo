<?php

class Modelo_Usuario
{
    private $conexion;

    function __construct()
    {

        require_once 'modelo_conexion.php';
        $this->conexion = new conexion();
        $this->conexion->conectar();
    }

    function Listar_Usuario()
    {
        $sql = "call SP_LISTAR_USUARIO()";
        $arreglo = array();
        if ($consulta = $this->conexion->conexion->query($sql)) {
            while ($consulta_vu = mysqli_fetch_assoc($consulta)) {

                $arreglo["data"][] = $consulta_vu;
            }
            return $arreglo;
            $this->conexion->cerrar();
        }
    }

    function Verificar_Usuario($usuario, $password)
    {
        $sql = "call SP_VERIFICAR_USUARIO('$usuario')";
        $arreglo = array();
        if ($consulta = $this->conexion->conexion->query($sql)) {
            while ($consulta_vu = mysqli_fetch_array($consulta)) {
                if (password_verify($password, $consulta_vu['usuario_password'])) {
                    $arreglo[] = $consulta_vu;
                }
            }
            return $arreglo;
            $this->conexion->cerrar();
        }
    }

    function Listar_combo_persona()
    {
        $sql = "call SP_LISTAR_COMBO_PERSONA()";
        $arreglo = array();
        if ($consulta = $this->conexion->conexion->query($sql)) {
            while ($consulta_vu = mysqli_fetch_array($consulta)) {

                $arreglo[] = $consulta_vu;
            }
            return $arreglo;
            $this->conexion->cerrar();
        }
    }

    function Listar_combo_rol()
    {
        $sql = "call SP_LISTAR_COMBO_ROL()";
        $arreglo = array();
        if ($consulta = $this->conexion->conexion->query($sql)) {
            while ($consulta_vu = mysqli_fetch_array($consulta)) {

                $arreglo[] = $consulta_vu;
            }
            return $arreglo;
            $this->conexion->cerrar();
        }
    }


    function Registar_Usuario($usuario, $pass, $mail, $idpersona, $idrol, $ruta)
    {
        $sql = "call SP_REGISTRAR_USUARIO('$usuario','$pass','$mail','$idpersona','$idrol','$ruta')";
        if ($consulta = $this->conexion->conexion->query($sql)) {
            if ($row = mysqli_fetch_array($consulta)) {
                $respuesta = trim($row[0]);
                return  $respuesta;
            }
            $this->conexion->cerrar();
        }
    }

    function Traer_datos_usuario($id)
    {
        $sql = "call SP_TRAER_DATOS_USUARIO('$id')";
        if ($consulta = $this->conexion->conexion->query($sql)) {
            while ($consulta_vu = mysqli_fetch_array($consulta)) {

                $arreglo[] = $consulta_vu;
            }
            return $arreglo;
            $this->conexion->cerrar();
        }
    }

    function Editar_Usuario($id,$mail, $idpersona, $idrol, $status)
    {
        $sql = "call SP_EDITAR_USUARIO('$id','$mail','$idpersona','$idrol','$status')";
        if ($consulta = $this->conexion->conexion->query($sql)) {
            if ($row = mysqli_fetch_array($consulta)) {
                $respuesta = trim($row[0]);
                return  $respuesta;
            }
            $this->conexion->cerrar();
        }
    }


    function Editar_Foto($id,$ruta)
    {
        $sql = "call SP_MODIFICAR_USUARIO_IMG('$id','$ruta')";
        if ($consulta = $this->conexion->conexion->query($sql)) {
            if ($row = mysqli_fetch_array($consulta)) {
                $respuesta = trim($row[0]);
                return  $respuesta;
            }
            $this->conexion->cerrar();
        }
    }
}
