<?php

$contra = password_hash('123456', PASSWORD_DEFAULT,['cost' => 10]);
echo $contra;

?>