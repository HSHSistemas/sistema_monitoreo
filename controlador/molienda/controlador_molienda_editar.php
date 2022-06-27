<?php
require('../../modelo/modelo_molienda.php');

  //se instancia el modelu molienda
  $modelo_mol = new Modelo_Molienda();


$id = htmlspecialchars(strtoupper($_POST['id']),ENT_QUOTES,'UTF-8');
$tamizado = htmlspecialchars(strtoupper($_POST['tamizado']),ENT_QUOTES,'UTF-8');
$polvo = htmlspecialchars(strtoupper($_POST['polvo']),ENT_QUOTES,'UTF-8');
$te = htmlspecialchars(strtoupper($_POST['te']),ENT_QUOTES,'UTF-8');
$nromalla = htmlspecialchars(strtoupper($_POST['nromalla']),ENT_QUOTES,'UTF-8');
$status = htmlspecialchars(strtoupper($_POST['status']),ENT_QUOTES,'UTF-8');
$observaciones = htmlspecialchars(strtoupper($_POST['observaciones']),ENT_QUOTES,'UTF-8');
$merma = htmlspecialchars(strtoupper($_POST['merma']),ENT_QUOTES,'UTF-8');
$rendimiento = htmlspecialchars(strtoupper($_POST['rendimiento']),ENT_QUOTES,'UTF-8');

$nombrearchivo = htmlspecialchars($_POST['nombrearchivo'], ENT_QUOTES, 'UTF-8');
if (is_array($_FILES) && count($_FILES) > 0) {
    if (move_uploaded_file($_FILES['foto']['tmp_name'], "img/" . $nombrearchivo)) {
        $ruta = 'controlador/molienda/img/' . $nombrearchivo;
        $consulta = $modelo_mol->Editar_Molienda($id,$tamizado, $polvo, $te, $nromalla, $status, $observaciones,$merma,$rendimiento, $ruta);
        echo $consulta;
    } else {
        echo 0;
    }
} else {
    $ruta = '';
    $consulta = $modelo_mol->Editar_Molienda($id,$tamizado, $polvo, $te, $nromalla, $status, $observaciones,$merma,$rendimiento, $ruta);
    echo $consulta;
}

?>