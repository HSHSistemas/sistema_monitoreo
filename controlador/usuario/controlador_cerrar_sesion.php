<?php

//destruimos la sesión y redireccionamos al index
session_start();
session_destroy();
header('Location: ../../vista/login.php');


?>