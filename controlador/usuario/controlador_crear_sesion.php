<?php

//obtenemos los valores mandados por ajax
$IDUSUARIO = $_POST["idusuario"];
$USUARIO = $_POST["usuario"];
$ROL = $_POST["rol"];

//se inicia la sesicón
session_start();

//se declaran las variables de sesión
$_SESSION['S_IDUSUARIO']=$IDUSUARIO;
$_SESSION['S_USUARIO']=$USUARIO;
$_SESSION['S_ROL']=$ROL;


?>