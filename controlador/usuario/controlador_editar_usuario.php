<?php

require '../../modelo/modelo_usuario.php';

//se instancia el modelu usuario
$modelo_Usu = new Modelo_Usuario();

$id =  htmlspecialchars($_POST['id'], ENT_QUOTES, 'UTF-8');
$mail = htmlspecialchars($_POST['mailnuevo'], ENT_QUOTES, 'UTF-8');
$idpersona = htmlspecialchars($_POST['idpersona'], ENT_QUOTES, 'UTF-8');
$idrol = htmlspecialchars($_POST['idrol'], ENT_QUOTES, 'UTF-8');
$status = htmlspecialchars($_POST['status'], ENT_QUOTES, 'UTF-8');

$consulta = $modelo_Usu->Editar_Usuario($id,$mail, $idpersona, $idrol, $status);
echo $consulta;

?>
