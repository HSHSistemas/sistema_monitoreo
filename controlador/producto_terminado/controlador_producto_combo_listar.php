<?php
require('../../modelo/modelo_producto_terminado.php');
$modelo_prterm = new Modelo_Producto_terminado();


$consulta = $modelo_prterm->Listar_Combo_Producto();
echo json_encode($consulta);
