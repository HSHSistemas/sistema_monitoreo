<?php
    require '../../modelo/modelo_usuario.php';

    //se instancia el modelu usuario
    $modelo_Usu = new Modelo_Usuario();


    //se consulta el metodo verificar usuario dentro del modelo
    $consulta = $modelo_Usu->Listar_combo_persona();
    echo json_encode($consulta);
?>