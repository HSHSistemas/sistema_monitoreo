

var t_usuario;
function listar_usuario() {

    t_usuario = $("#tabla_usuario").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/usuario/controlador_usuario_listar.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "usuario_nombre" },
            { "data": "persona" },
            { "data": "rol_nombre" },
            { "data": "usuario_mail" },
            {
                "data": "usuario_img",
                render: function (data, type, row) {

                    return '<img src="../' + data + '" class="img-circle m-r-10" style="width: 28px;">';

                }
            },
            {
                "data": "usuario_status",

                render: function (data, type, row) {
                    if (data === "ACTIVO") {
                        return "<span class='badge badge-success badge-pill m-r-5 m-b-5'>" + data + "</span>";
                    }
                    else {
                        return "<span class='badge badge-danger badge-pill m-r-5 m-b-5'>"
                            + data + "</span>";
                    }
                }
            },
            { "defaultContent": "<button class='editar btn btn-primary' ><i class='fa fa-edit'></i></button>" }


        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $($(nRow).find("td")[4]).css('text-align', 'center');
            $($(nRow).find("td")[5]).css('text-align', 'center');
        },
        "language": idioma_espanol,
        select: true
    });
    t_usuario.on('draw.dt', function () {
        var PageInfo = $('#tabla_usuario').DataTable().page.info();
        t_usuario.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}

function AbrirModal() {
    $("#Modal_Registro").modal({ backdrop: 'static', keyboard: false })
    $("#Modal_Registro").modal("show");
}

$('#tabla_usuario').on('click', '.editar', function () {
    var data = t_usuario.row($(this).parents('tr')).data();//Detecta a que fila hago click 
    //y me captura los datos en la variable data.
    if (t_usuario.row(this).child.isShown()) {   //Cuando esta en tamaño responsivo
        var data = t_usuario.row(this).data();
    }
    $("#modal_editar").modal({ backdrop: 'static', keyboard: false })
    $("#modal_editar").modal("show");

    console.log(data);
    document.getElementById('txt_usu_id').value = data.usuario_id;
    document.getElementById('txt_usu_editar_actual').value = data.usuario_nombre;
    document.getElementById('txt_email_editar_nuevo').value = data.usuario_mail;
    $("#cmb_persona_editar").val(data.id_persona).trigger("change");
    $("#cmb_status_editar").val(data.usuario_status).trigger("change");
    $("#cmb_rol_editar").val(data.rol_id).trigger("change");

    

})


function Verificar_usuario() {
    var usuario = document.getElementById('usuario').value;
    var password = document.getElementById('password').value;

    console.log(usuario);
    console.log(password);

    if (usuario.length === 0 || password.length === 0) {
        return Swal.fire("Mensaje de advetencia", "Llene los campos vacios", "warnig");
    }

    $.ajax({
        url: '../controlador/usuario/controlador_verificar_usuario.php',
        type: 'POST',
        data: {
            // u y p se declaran para obtener los resultados de las variables que se
            // envian, este caso usuario y contrasena
            u: usuario,
            p: password
        }


    }).done(function (resp) {
        var data = JSON.parse(resp);

        console.log(resp);
        if (resp === 0 || resp === "[]") {
            Swal.fire("Mensaje de advetencia", "Usuario y/o contraseña incorrecta", "warnig");
        }
        else {
            if (data[0][5] == "ACTIVO") {
                $.ajax({
                    url: '../controlador/usuario/controlador_crear_sesion.php',
                    type: 'POST',
                    data: {

                        idusuario: data[0][0],
                        usuario: data[0][1],
                        rol: data[0][6],
                    }
                }).done(function (resp) {
                    let timerInterval
                    Swal.fire({
                        title: 'Bienvenido al sistema',
                        html: 'Será redireccionado en <b></b> milliseconds.',
                        timer: 2000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading()
                            const b = Swal.getHtmlContainer().querySelector('b')
                            timerInterval = setInterval(() => {
                                b.textContent = Swal.getTimerLeft()
                            }, 100)
                        },
                        willClose: () => {
                            clearInterval(timerInterval)
                        }
                    }).then((result) => {
                        /* Read more about handling dismissals below */
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload();
                        }
                    })
                })
            }
            else {
                Swal.fire("Mensaje de advetencia", "El usuario se encuentra inactivo comuniquese con el administrador", "warnig");
            }
        }

    })
}

function listar_persona_combo() {
    $.ajax({
        url: "../controlador/usuario/controlador_persona_combo_listar.php",
        type: "POST"
    }).done(function (resp) {
        data = JSON.parse(resp);
        cadena = "";
        if (data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                cadena += "<option value='" + data[i][0] + "'>" + data[i][1] + "</option>";
            }
            document.getElementById('cmb_persona').innerHTML = cadena;
            document.getElementById('cmb_persona_editar').innerHTML = cadena;

        }
        else {
            document.getElementById('cmb_persona').innerHTML = "no se encontraron datos";
        }
    })
}

function listar_rol_combo() {
    $.ajax({
        url: "../controlador/usuario/controlador_rol_combo_listar.php",
        type: "POST"
    }).done(function (resp) {
        data = JSON.parse(resp);
        cadena = "";
        if (data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                cadena += "<option value='" + data[i][0] + "'>" + data[i][1] + "</option>";
            }
            document.getElementById('cmb_rol').innerHTML = cadena;
            document.getElementById('cmb_rol_editar').innerHTML = cadena;

        }
        else {
            document.getElementById('cmb_rol').innerHTML = "no se encontraron datos";
        }
    })
}


function Registar_Usuario() {
    var usuario = document.getElementById('txt_usu').value;
    var pass = document.getElementById('txt_password').value;
    var mail = document.getElementById('txt_email').value;
    var idpersona = document.getElementById('cmb_persona').value;
    var idrol = document.getElementById('cmb_rol').value;
    var archivo = document.getElementById('imagen').value;

    if(validar_email(mail)){

    }
    else{
       return Swal.fire("Mensaje advertencia", "El formato de email es incorrecto","warning");
    }
    var f = new Date();
    var extension = archivo.split('.').pop();
    var nombrearchivo = "IMG" + f.getDate() + "" + (f.getMonth() + 1) + "" + f.getFullYear() + "" + f.getHours() + "" + f.getMinutes() + "" + f.getSeconds() + "." + extension;
    var formData = new FormData();
    var foto = $("#imagen")[0].files[0];

    formData.append('usuario', usuario);
    formData.append('pass', pass);
    formData.append('mail', mail);
    formData.append('id_persona', idpersona);
    formData.append('idrol', idrol);
    formData.append('foto', foto);
    formData.append('nombrearchivo', nombrearchivo);

    $.ajax({
        url: '../controlador/usuario/controlador_usuario_registro.php',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function (respuesta) {
            if (respuesta != 0) {
                if (respuesta == 1) {
                    LimpiarCampos();
                    t_usuario.ajax.reload();
                    $("#Modal_Registro").modal("hide");
                    Swal.fire("Mensaje de confirmación", "Datos guardados", "success");
                }
                else {
                    Swal.fire("Mensaje de advertencia", "El correo y/o usuario ingresado ya se encuentra registrado", "warnig");
                }
                //Swal.fire('Mensaje De Confirmacion', "Se subio el archivo con exito",
                //    "success");
            }
        }
    });
}

function validar_email(email) {
    var regex = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i; 
    return regex.test(email) ? true : false;
}

function LimpiarCampos()
{
    document.getElementById('txt_usu').value="";
    document.getElementById('txt_password').val="";
    document.getElementById('txt_email').value="";
    document.getElementById('imagen').value="";

}

function TraerDatosUsuario()
{
    id = document.getElementById('txt_codigo_principal').value;
    $.ajax({
        url: '../controlador/usuario/controlador_traerdatos_usuario.php',
        type: 'POST',
        data: {
            id: id
        }
    }).done(function (resp) {
        var data = JSON.parse(resp)
        if (data.length > 0) {

            document.getElementById('usu_sidebar').innerHTML=data[0][1];
            document.getElementById('rol_sidebar').innerHTML=data[0][7];
            document.getElementById('img_index').src = '../' + data[0][6];
        }
    })
}

function TraerDatosPerfil() {
    id = document.getElementById('txt_codigo_principal').value;
    $.ajax({
        url: '../controlador/usuario/controlador_traerdatos_usuario.php',
        type: 'POST',
        data: {
            id: id
        }
    }).done(function (resp) {
        var data = JSON.parse(resp)
        if (data.length > 0) {

            document.getElementById('img_index').src = '../' + data[0][6];
            document.getElementById('txt_img_profile').src = '../' + data[0][6];
            document.getElementById('txt_persona_profile').innerHTML = data[0][8] + ' ' + data[0][9] + ' ' + data[0][10];
            document.getElementById('txt_rol_profile').innerHTML = data[0][7];

            document.getElementById('txt_nombres_profile').value = data[0][8];
            document.getElementById('txt_apepat_profile').value = data[0][9];
            document.getElementById('txt_apemat_profile').value = data[0][10];
            document.getElementById('txt_nrodocuemto_profile').value = data[0][11];
            $("#cmb_tdocumento_profile").val(data[0][12]).trigger("change");
            $("#cmb_sexo_profile").val(data[0][13]).trigger("change");
            document.getElementById('txt_conac_profile').value = data[0][2];

        }
    })
}

function Editar_Usuario() {

    var id = document.getElementById('txt_usu_id').value;
    var mailnuevo = document.getElementById('txt_email_editar_nuevo').value;
    var idpersona = document.getElementById('cmb_persona_editar').value;
    var idrol = document.getElementById('cmb_rol_editar').value;
    var status = document.getElementById('cmb_status_editar').value;

    if(validar_email(mailnuevo)){

    }
    else{
       return Swal.fire("Mensaje advertencia", "El formato de email es incorrecto","warning");
    }

    $.ajax({
        url: '../controlador/usuario/controlador_editar_usuario.php',
        type: 'POST',
        data: {
            id: id,
            mailnuevo: mailnuevo,
            idpersona: idpersona,
            idrol: idrol,
            status: status

        }
    }).done(function (resp) {
        console.log(resp);
        if (resp > 0) {

            if (resp == 1) {
                t_usuario.ajax.reload();
                $("#modal_editar").modal("hide");
                Swal.fire("Mensaje de confirmación", "Datos actualizados", "success");
            }
            else {
                Swal.fire("Mensaje de advertencia", "El email ingresado ya se encuentra en de db", "warnig");
            }
        }
        else {
            Swal.fire("Mensaje de error", "La actualización no se pudo completar", "error");
        }
    })
}


function Editar_Foto() {
  
    var id = document.getElementById('txt_usu_id').value;
    var archivo = document.getElementById('imagen_editar').value;

    var f = new Date();
    var extension = archivo.split('.').pop();
    var nombrearchivo = "IMG" + f.getDate() + "" + (f.getMonth() + 1) + "" + f.getFullYear() + "" + f.getHours() + "" + f.getMinutes() + "" + f.getSeconds() + "." + extension;
    var formData = new FormData();
    var foto = $("#imagen_editar")[0].files[0];

    if(archivo.length=0){
        return Swal.fire("Mensaje advertencia", "Debe seleccionar un archivo","warning");
     }

    formData.append('id', id);
    formData.append('foto', foto);
    formData.append('nombrearchivo', nombrearchivo);

    $.ajax({
        url: '../controlador/usuario/controlador_usuario_editar_imagen.php',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function (respuesta) {
            if (respuesta != 0) {
                if (respuesta == 1) {
                    t_usuario.ajax.reload();
                    $("#modal_editar").modal("hide");
                    Swal.fire("Mensaje de confirmación", "Foto actualizada", "success");
                }
                //Swal.fire('Mensaje De Confirmacion', "Se subio el archivo con exito",
                //    "success");
            }
        }
    });
}

function Editar_Foto_Profile() {

    var id = document.getElementById('txt_codigo_principal').value;
    var archivo = document.getElementById('txt_img_profile2').value;

    if (archivo.length = 0) {
        return Swal.fire("Mensaje advertencia", "Debe seleccionar un archivo", "warning");
    }
    var f = new Date();
    var extension = archivo.split('.').pop();
    var nombrearchivo = "IMG" + f.getDate() + "" + (f.getMonth() + 1) + "" + f.getFullYear() + "" + f.getHours() + "" + f.getMinutes() + "" + f.getSeconds() + "." + extension;
    var formData = new FormData();
    var foto = $("#txt_img_profile2")[0].files[0];

    formData.append('id', id);
    formData.append('foto', foto);
    formData.append('nombrearchivo', nombrearchivo);

    $.ajax({
        url: '../controlador/usuario/controlador_usuario_editar_imagen.php',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function (respuesta) {
            if (respuesta != 0) {
                if (respuesta == 1) {
                    TraerDatosPerfil();
                    Swal.fire("Mensaje de confirmación", "Foto actualizada", "success");
                }
                //Swal.fire('Mensaje De Confirmacion', "Se subio el archivo con exito",
                //    "success");
            }
        }
    });
}

function Datos_Actualizar() {

    var id = document.getElementById('txt_codigo_principal').value;
    var nombre = document.getElementById('txt_nombres_profile').value;
    var apepa = document.getElementById('txt_apepat_profile').value;
    var apema = document.getElementById('txt_apemat_profile').value;
    var nrodocumento = document.getElementById('txt_nrodocuemto_profile').value;
    var tipodoc = document.getElementById('cmb_tdocumento_profile').value;
    var sexo = document.getElementById('cmb_sexo_profile').value;
    var telefono = document.getElementById('txttelefono_profile').value;

    if (nombre.length === 0 || nombre === null || apepa.length === 0 || apepa === null || apema.length === 0 || apema === null || nrodocumento.length === 0 || nrodocumento === null || tipodoc.length === 0 || tipodoc === null || telefono === null || telefono.length === 0) {
        mensaje_error(nombre, apepa, apema, nrodocumento, tipodoc, sexo, telefono);
        return Swal.fire("Mensaje de advetencia", "Llene el campo vacio", "warnig");
    }
    else {

        $.ajax({
            url: '../controlador/usuario/controlador_actualizar_datos_persona_profile.php',
            type: 'POST',
            data: {
                id: id,
                nombre: nombre,
                apepa: apepa,
                apema: apema,
                nrodocumento: nrodocumento,
                tipodoc: tipodoc,
                sexo: sexo,
                telefono: telefono
            }
        }).done(function (resp) {
            alert(resp);
            if (isNaN(resp)) {
                document.getElementById('div_error_profile').style.display = "block";
                document.getElementById('div_error_profile').innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + resp;
            }
            else {
                if (resp > 0) {
                    document.getElementById('div_error_profile').style.display = "none";
                    document.getElementById('div_error_profile').innerHTML = "";
                    if (resp == 1) {
                        Swal.fire("Mensaje de confirmación", "Datos guardados", "success");
                        TraerDatosPerfil();
                    }
                    else {
                        Swal.fire("Mensaje de advertencia", "La persona ya se encuentra registrado", "warnig");
                    }
                }
                else {
                    Swal.fire("Mensaje de error", "El registro no se pudo completar", "error");
                }
            }
        })

    }



}

function mensaje_error(nombre, apellidopat, apellidomat, documentonuevo, tdocument, sexo, telefono) {
    var cadena = "";
    if (nombre.length === 0 || nombre === null) {
        cadena = "El campo nombre no debe estar vacio.<br>";
    }

    if (apellidopat.length == 0) {
        cadena += "El campo apellido paterno no debe estar vacio.<br>";
    }

    if (apellidomat.length == 0) {
        cadena += "El campo apallido materno no debe estar vacio.<br>";
    }

    if (documentonuevo.length == 0) {
        cadena += "El campo nro de documento no debe estar vacio.<br>";
    }

    if (tdocument.length == 0) {
        cadena += "El campo tipo de documento no debe estar vacio.<br>";
    }

    if (sexo.length == 0) {
        cadena += "El campo sexo no debe estar vacio.<br>";
    }

    if (telefono.length == 0) {
        cadena += "El campo telefono no debe estar vacio.<br>";
    }
    document.getElementById("div_error_profile").style.display = "block";
    document.getElementById("div_error_profile").innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + cadena;

}

function actualizar_contra() {
    id = document.getElementById('txt_codigo_principal').value;
    var contra_actual = document.getElementById('txt_conac_profile').value;
    var contra_acutalscrita = document.getElementById('txt_conacactualescrita_profile').value;
    var contra_nueva = document.getElementById('txt_connueva_profile').value;
    var contra_repetir = document.getElementById('txt_conrepetir_profile').value;

    if (contra_nueva != contra_repetir) {
        return Swal.fire("Mensaje de Advertencia", "Debes ingresar la misma clave dos veces para confirmarla", "warning");

    }

    $.ajax({
        url: '../controlador/usuario/controlador_actualizar_contra_usuario.php',
        type: 'POST',
        data: {
            id: id,
            contra_actual: contra_actual,
            contra_acutalscrita: contra_acutalscrita,
            contra_nueva: contra_nueva





        }
    }).done(function (resp) {
        if (resp > 0) {

            if (resp == 1) {
                Swal.fire("Mensaje de confirmación", "Contraseña actualizada", "success");
                limpiar_campos_contra();

            }
            else {
                Swal.fire("Mensaje de advertencia", "La contraseña actual ingresada es incorrecta", "warnig");
            }


        }
        else {
            Swal.fire("Mensaje De Error", "La modificación no se pudo completar",
                "error");

        }
    })

}

function limpiar_campos_contra() {
    TraerDatosPerfil();
    contra_acutalscrita = document.getElementById('txt_conacactualescrita_profile').value = "";
    contra_nueva = document.getElementById('txt_connueva_profile').value = "";
    contra_repetir = document.getElementById('txt_conrepetir_profile').value = "";
}