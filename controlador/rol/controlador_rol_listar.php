<?php

require('../../modelo/modelo_rol.php');
$modelo_rol = new Modelo_Rol();
$consulta = $modelo_rol->Listar_Rol();
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
