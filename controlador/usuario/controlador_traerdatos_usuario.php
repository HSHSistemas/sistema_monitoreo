<?php
require '../../modelo/modelo_usuario.php';

//se instancia el modelu usuario
$modelo_Usu = new Modelo_Usuario();

//se obtiene las variables enviadas por post
$id = htmlspecialchars($_POST['id'],ENT_QUOTES,'UTF-8');

//se consulta el metodo verificar usuario dentro del modelo
$consulta = $modelo_Usu->Traer_datos_usuario($id);
$data = json_encode($consulta);
    echo $data;