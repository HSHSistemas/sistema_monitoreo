<?php

require('../../modelo/modelo_persona.php');
$modelo_per = new Modelo_Persona();
$consulta = $modelo_per->Listar_Persona();
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