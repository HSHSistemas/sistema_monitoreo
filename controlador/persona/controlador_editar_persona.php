<?php

require('../../modelo/modelo_persona.php');


$modelo_per = new Modelo_Persona();

$error="";
$contador = 0;

$id = htmlspecialchars(strtoupper($_POST['id']),ENT_QUOTES,'UTF-8');
$nombre = htmlspecialchars(strtoupper($_POST['nombre']),ENT_QUOTES,'UTF-8');
$appa = htmlspecialchars(strtoupper($_POST['apellidopat']),ENT_QUOTES,'UTF-8');
$apma = htmlspecialchars(strtoupper($_POST['apellidomat']),ENT_QUOTES,'UTF-8');
$documentoactual = htmlspecialchars(strtoupper($_POST['documentoatual']),ENT_QUOTES,'UTF-8');
$documentonuevo = htmlspecialchars(strtoupper($_POST['documentonuevo']),ENT_QUOTES,'UTF-8');
$tdocumento = htmlspecialchars(strtoupper($_POST['tdocument']),ENT_QUOTES,'UTF-8');
$sexo = htmlspecialchars(strtoupper($_POST['sexo']),ENT_QUOTES,'UTF-8');
$status = htmlspecialchars(strtoupper($_POST['status']),ENT_QUOTES,'UTF-8');
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

if (!is_numeric($documentonuevo))
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
    $consulta = $modelo_per->Editar_Persona($id,$nombre,$appa,$apma,$documentoactual, $documentonuevo,$tdocumento,$sexo,$telefono,$status);
    echo $consulta;
}

