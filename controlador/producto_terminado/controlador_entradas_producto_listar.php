<?php

require('../../modelo/modelo_producto_terminado.php');
$modelo_prterm = new Modelo_Producto_terminado();
$consulta = $modelo_prterm->Listar_Entrada_Producto();
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