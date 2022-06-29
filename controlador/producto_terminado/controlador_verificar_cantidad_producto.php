<?php
require '../../modelo/modelo_producto_terminado.php';

//se instancia el modelu usuario
$modelo_PT = new Modelo_Producto_terminado();

//se obtiene las variables enviadas por post
$id = htmlspecialchars($_POST['producto'],ENT_QUOTES,'UTF-8');

//se consulta el metodo verificar usuario dentro del modelo
$consulta = $modelo_PT->Traer_Stock_Producto($id);
$data = json_encode($consulta);
    echo $data;