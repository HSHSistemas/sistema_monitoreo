<?php
require('../../modelo/modelo_producto_terminado.php');
$modelo_prterm = new Modelo_Producto_terminado();


$id_producto = htmlspecialchars(strtoupper($_POST['producto']),ENT_QUOTES,'UTF-8');
$consulta = $modelo_prterm->Listar_Combo_Producto_Lotes_Dos($id_producto);
echo json_encode($consulta);