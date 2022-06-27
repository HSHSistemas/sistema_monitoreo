<?php
    require '../../modelo/modelo_molienda.php';

    //se instancia el modelu usuario
    $modelo_mol = new Modelo_Molienda();


    //se consulta el metodo verificar usuario dentro del modelo
    $consulta = $modelo_mol->Listar_combo_materia();
    echo json_encode($consulta);
?>