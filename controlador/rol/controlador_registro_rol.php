<?php

require('../../modelo/modelo_rol.php');
$modelo_rol = new Modelo_Rol();
$rol = htmlspecialchars($_POST['rol'],ENT_QUOTES,'UTF-8');
$consulta = $modelo_rol->Registrar_Rol($rol);
echo $consulta;
?>