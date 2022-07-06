<?php

require('../../modelo/modelo_persona.php');


$modelo_per = new Modelo_Persona();

$error="";
$contador = 0;


$nombre = htmlspecialchars(strtoupper($_POST['nombre']),ENT_QUOTES,'UTF-8');
$appa = htmlspecialchars(strtoupper($_POST['apellidopat']),ENT_QUOTES,'UTF-8');
$apma = htmlspecialchars(strtoupper($_POST['apellidomat']),ENT_QUOTES,'UTF-8');
$sexo = htmlspecialchars(strtoupper($_POST['sexo']),ENT_QUOTES,'UTF-8');


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



if($contador>0)
{
    echo $error;
}
else 
{
    $consulta = $modelo_per->Registrar_Persona($nombre,$appa,$apma,$sexo);
    echo $consulta;
}

