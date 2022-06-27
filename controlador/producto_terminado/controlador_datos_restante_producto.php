<?php
require('../../modelo/modelo_producto_terminado.php');
$modelo_prterm = new Modelo_Producto_terminado();

$id_entrada = htmlspecialchars(strtoupper($_POST['id_entrada']),ENT_QUOTES,'UTF-8');
$consulta = $modelo_prterm->Listar_Datos_Restantes_Producto($id_entrada);
echo json_encode($consulta);