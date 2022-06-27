<?php

require('../../modelo/modelo_molienda.php');

  //se instancia el modelu molienda
  $modelo_mol = new Modelo_Molienda();


$materia = htmlspecialchars(strtoupper($_POST['materia']),ENT_QUOTES,'UTF-8');
$corte = htmlspecialchars(strtoupper($_POST['corte']),ENT_QUOTES,'UTF-8');
$kg = htmlspecialchars(strtoupper($_POST['kg']),ENT_QUOTES,'UTF-8');
$molino = htmlspecialchars(strtoupper($_POST['molino']),ENT_QUOTES,'UTF-8');

 //se consulta el metodo verificar usuario dentro del modelo
 $consulta = $modelo_mol->Registrar_Molienda($materia,$corte,$kg,$molino);
 echo ($consulta);

