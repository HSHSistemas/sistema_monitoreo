<?php
require '../../modelo/modelo_usuario.php';

//se instancia el modelu usuario
$modelo_Usu = new Modelo_Usuario();

$usuario = htmlspecialchars($_POST['usuario'], ENT_QUOTES, 'UTF-8');
$pass =  password_hash($_POST['pass'], PASSWORD_DEFAULT, ['cost' => 10]);
$mail = htmlspecialchars($_POST['mail'], ENT_QUOTES, 'UTF-8');
$idpersona = htmlspecialchars($_POST['id_persona'], ENT_QUOTES, 'UTF-8');
$idrol = htmlspecialchars($_POST['idrol'], ENT_QUOTES, 'UTF-8');
$nombrearchivo = htmlspecialchars($_POST['nombrearchivo'], ENT_QUOTES, 'UTF-8');
if (is_array($_FILES) && count($_FILES) > 0) {
    if (move_uploaded_file($_FILES['foto']['tmp_name'], "img/" . $nombrearchivo)) {
        $ruta = 'controlador/usuario/img/' . $nombrearchivo;
        $consulta = $modelo_Usu->Registar_Usuario($usuario, $pass, $mail, $idpersona, $idrol, $ruta);
        echo $consulta;
    } else {
        echo 0;
    }
} else {
    $ruta = 'controlador/usuario/img/user_defecto.png';
    $consulta = $modelo_Usu->Registar_Usuario($usuario, $pass, $mail, $idpersona, $idrol, $ruta);
    echo $consulta;
}
