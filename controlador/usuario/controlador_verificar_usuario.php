<?php
    require '../../modelo/modelo_usuario.php';

    //se instancia el modelu usuario
    $modelo_Usu = new Modelo_Usuario();

    //se obtiene las variables enviadas por post
    $usuario = htmlspecialchars($_POST['u'],ENT_QUOTES,'UTF-8');
    $pass = htmlspecialchars($_POST['p'],ENT_QUOTES,'UTF-8');

    //se consulta el metodo verificar usuario dentro del modelo
    $consulta = $modelo_Usu->Verificar_Usuario($usuario,$pass);
    $data = json_encode($consulta);
    if ($consulta > 0)
    {
        echo $data;
    }
    else{
        echo 0;
    }
?>