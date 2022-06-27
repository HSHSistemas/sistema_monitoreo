<?php

require('../../modelo/modelo_producto_terminado.php');



$modelo_prterm = new Modelo_Producto_terminado();

$error="";
$contador = 0;


$id_producto = htmlspecialchars(strtoupper($_POST['producto']),ENT_QUOTES,'UTF-8');
$lote = htmlspecialchars(strtoupper($_POST['lote_uno']),ENT_QUOTES,'UTF-8');
$lote_dos = htmlspecialchars(strtoupper($_POST['lote_dos']),ENT_QUOTES,'UTF-8');
$cantidad = htmlspecialchars(strtoupper($_POST['cantidad_salida']),ENT_QUOTES,'UTF-8');
$folio_venta = htmlspecialchars(strtoupper($_POST['folio_venta']),ENT_QUOTES,'UTF-8');


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
    $consulta = $modelo_prterm->Registrar_Salida_Producto_Terminado_Dos_Lotes($id_producto,$lote,$lote_dos,$cantidad,$folio_venta);
    echo $consulta;
}