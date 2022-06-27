<?php

require('../../modelo/modelo_producto_terminado.php');



$modelo_prterm = new Modelo_Producto_terminado();

$error="";
$contador = 0;


$id_producto = htmlspecialchars(strtoupper($_POST['producto']),ENT_QUOTES,'UTF-8');
$lote = htmlspecialchars(strtoupper($_POST['lote']),ENT_QUOTES,'UTF-8');
$cantidad = htmlspecialchars(strtoupper($_POST['cantidad']),ENT_QUOTES,'UTF-8');
$fecha_caducidad = htmlspecialchars(strtoupper($_POST['fecha_caducidad']),ENT_QUOTES,'UTF-8');


if (!is_numeric($cantidad))
{
    $contador ++;
    $error.="El nro de documento debe contener solo numeros. <br>";
}



if($contador>0)
{
    echo $error;
}
else 
{
    $consulta = $modelo_prterm->Registrar_Entrada_Producto_Terminado($id_producto,$lote,$cantidad,$fecha_caducidad);
    echo $consulta;
}