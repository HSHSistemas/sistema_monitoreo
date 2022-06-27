<?php

require '../../modelo/modelo_usuario.php';

//se instancia el modelu usuario
$modelo_Usu = new Modelo_Usuario();

$id =  htmlspecialchars($_POST['id'], ENT_QUOTES, 'UTF-8');
$contra_actual =  htmlspecialchars($_POST['contra_actual'], ENT_QUOTES, 'UTF-8');
$contra_acutalscrita = htmlspecialchars($_POST['contra_acutalscrita'], ENT_QUOTES, 'UTF-8');
$contra_nueva = password_hash($_POST['contra_nueva'], PASSWORD_DEFAULT, ['cost' => 10]); 

if(password_verify($contra_acutalscrita,$contra_actual))
{
    $consulta = $modelo_Usu->Actualizar_Password($id,$contra_nueva);
    echo $consulta;
}
else
{
    echo 2;
}



?>