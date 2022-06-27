<?php

require('../../modelo/modelo_molienda.php');
$modelo_rol = new Modelo_Molienda();
$consulta = $modelo_rol->Listar_Molienda();
if ($consulta) 
{
    echo json_encode($consulta);
}
else
{
    echo '{
        "sEcho": 1,
        "iTotalRecords": "0",
        "iTotalDisplayRecords": "0",
        "aaData": []
    )';
}


?>