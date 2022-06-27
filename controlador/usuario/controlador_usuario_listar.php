<?php

require('../../modelo/modelo_usuario.php');
$modelo_usu = new Modelo_Usuario();
$consulta = $modelo_usu->Listar_Usuario();
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