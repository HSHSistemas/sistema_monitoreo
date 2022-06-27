<?php
require '../../modelo/modelo_usuario.php';

//se instancia el modelu usuario
$modelo_Usu = new Modelo_Usuario();

$error="";
$contador = 0;

$id =  htmlspecialchars($_POST['id'], ENT_QUOTES, 'UTF-8');
$nombre = htmlspecialchars(strtoupper($_POST['nombre']),ENT_QUOTES,'UTF-8');
$appa = htmlspecialchars(strtoupper($_POST['apepa']),ENT_QUOTES,'UTF-8');
$apma = htmlspecialchars(strtoupper($_POST['apema']),ENT_QUOTES,'UTF-8');
$documento = htmlspecialchars(strtoupper($_POST['nrodocumento']),ENT_QUOTES,'UTF-8');
$tdocumento = htmlspecialchars(strtoupper($_POST['tipodoc']),ENT_QUOTES,'UTF-8');
$sexo = htmlspecialchars(strtoupper($_POST['sexo']),ENT_QUOTES,'UTF-8');
$telefono = htmlspecialchars(strtoupper($_POST['telefono']),ENT_QUOTES,'UTF-8');


if ((!preg_match("/^(?!-+)[a-zA-Z-ñáéíóú\s]*$/", $nombre)))
{
    $contador ++;
    $error.="El nombre debe contener solo letras.<br>";
}
if ((!preg_match("/^(?!-+)[a-zA-Z-ñáéíóú\s]*$/",$appa)))
{
    $contador ++;
    $error.="El apellido paterno debe contener solo letras.<br>";
}

if ((!preg_match("/^(?!-+)[a-zA-Z-ñáéíóú\s]*$/",$apma)))
{
    $contador ++;
    $error.="El apellido materno debe contener solo letras. <br>";
}

if (!is_numeric($documento))
{
    $contador ++;
    $error.="El nro de documento debe contener solo numeros. <br>";
}

if (!preg_match("/^[[:digit:]\s]*$/", $telefono)){ 
    $contador ++;
    $error.="El telefono debe contener solo numeros. <br>";
}


if($contador>0)
{
    echo $error;
}
else 
{
    $consulta = $modelo_Usu->Actualizar_Datos_Profile($id,$nombre,$appa,$apma,$documento,$tdocumento,$sexo,$telefono);
    echo $consulta;
}

?>