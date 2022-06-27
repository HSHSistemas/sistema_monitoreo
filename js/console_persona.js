var t_persona;
function listar_persona() {

    t_persona = $("#tabla_persona").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/persona/controlador_persona_listar.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "persona" },
            {
                "data": "persona_sexo",
                render: function (data, type, row) {
                    if (data === "MASCULINO") {
                        return "<i class= 'fa fa-male'></i>";
                    }
                    else {
                        return "<i class= 'fa fa-female'></i>";
                    }
                }
            },
            {
                "data": "persona_estatus",

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
            $($(nRow).find("td")[0]).css('text-align', 'center');
            $($(nRow).find("td")[1]).css('text-align', 'center');
            $($(nRow).find("td")[2]).css('text-align', 'center');
        },
        "language": idioma_espanol,
        select: true
    });
    t_persona.on('draw.dt', function () {
        var PageInfo = $('#tabla_persona').DataTable().page.info();
        t_persona.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}


function AbrirModal() {
    $("#Modal_Registro_P").modal({ backdrop: 'static', keyboard: false })
    $("#Modal_Registro_P").modal("show");
    document.getElementById('div_error').style.display = "none";
    limpiar_modal();
}

function Registar_Persona() {
    var nombre = document.getElementById('txtnombre').value;
    var apellidopat = document.getElementById('txtapepat').value;
    var apellidomat = document.getElementById('txtapemat').value;
    var documento = document.getElementById('txtnro').value;
    var tdocument = document.getElementById('cmb_tdocumento').value;
    var sexo = document.getElementById('cmb_sexo').value;
    var telefono = document.getElementById('txttelefono').value;

    console.log(nombre);
    console.log(apellidopat);
    console.log(apellidomat);
    console.log(documento);
    console.log(tdocument);
    console.log(sexo);
    console.log(telefono);


    if (nombre.length === 0 || nombre === null || apellidopat.length === 0 || apellidopat === null || apellidomat.length === 0 || apellidomat === null || documento.length === 0 || documento === null || tdocument.length === 0 || tdocument === null || telefono=== null || telefono.length === 0) {
        mensaje_error(nombre, apellidopat, apellidomat, documento, tdocument, sexo, telefono,'div_error');
        return Swal.fire("Mensaje de advetencia", "Llene el campo vacio", "warnig");
    }
    else {

        $.ajax({
            url: '../controlador/persona/controlador_registro_persona.php',
            type: 'POST',
            data: {
                nombre: nombre,
                apellidopat: apellidopat,
                apellidomat: apellidomat,
                documento: documento,
                tdocument: tdocument,
                sexo: sexo,
                telefono: telefono
            }
        }).done(function (resp) {
            if (isNaN(resp)) {
                document.getElementById('div_error').style.display = "block";
                document.getElementById('div_error').innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + resp;
            }
            else {
                if (resp > 0) {
                    document.getElementById('div_error').style.display = "none";
                    document.getElementById('div_error').innerHTML = "";
                    if (resp == 1) {
                        t_persona.ajax.reload();
                        limpiar_modal()
                        $("#Modal_Registro_P").modal("hide");
                        Swal.fire("Mensaje de confirmación", "Datos guardados", "success");
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


function Editar_Persona() {
    var id = document.getElementById('txtid_persona').value;
    var nombre = document.getElementById('txtnombre_editar').value;
    var apellidopat = document.getElementById('txtapepat_editar').value;
    var apellidomat = document.getElementById('txtapemat_editar').value;
    var documentoatual = document.getElementById('txtnro_editar_actual').value;
    var documentonuevo = document.getElementById('txtnro_editar_nuevo').value;
    var tdocument = document.getElementById('cmb_tdocumento_editar').value;
    var sexo = document.getElementById('cmb_sexo_editar').value;
    var telefono = document.getElementById('txttelefono_editar').value;
    var status = document.getElementById('cmb_status').value;

    /*
    console.log(nombre);
    console.log(apellidopat);
    console.log(apellidomat);
    console.log(documento);
    console.log(tdocument);
    console.log(sexo);
    console.log(telefono);
    */

    if (id.length === 0 || id === null || nombre.length === 0 || nombre === null || apellidopat.length === 0 || apellidopat === null || apellidomat.length === 0 || apellidomat === null || documentoatual.length === 0 || documentoatual === null || documentonuevo.length === 0 || documentonuevo === null || tdocument.length === 0 || tdocument === null || telefono=== null || telefono.length === 0) {
        mensaje_error(nombre, apellidopat, apellidomat, documentonuevo, tdocument, sexo, telefono, 'div_error_editar');
        return Swal.fire("Mensaje de advetencia", "Llene el campo vacio", "warnig");
    }
    else {

        $.ajax({
            url: '../controlador/persona/controlador_editar_persona.php',
            type: 'POST',
            data: {
                id:id,
                nombre: nombre,
                apellidopat: apellidopat,
                apellidomat: apellidomat,
                documentoatual: documentoatual,
                documentonuevo: documentonuevo,
                status: status,
                tdocument: tdocument,
                sexo: sexo,
                telefono: telefono
            }
        }).done(function (resp) {
            if (isNaN(resp)) {
                document.getElementById('div_error_editar').style.display = "block";
                document.getElementById('div_error_editar').innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + resp;
            }
            else {
                if (resp > 0) {
                    document.getElementById('div_error_editar').style.display = "none";
                    document.getElementById('div_error_editar').innerHTML = "";
                    if (resp == 1) {
                        t_persona.ajax.reload();
                        $("#modal_editar").modal("hide");
                        Swal.fire("Mensaje de confirmación", "Datos actualizados", "success");
                    }
                    else {
                        Swal.fire("Mensaje de advertencia", "La persona ya se encuentra registrado", "warnig");
                    }
                }
                else {
                    Swal.fire("Mensaje de error", "La actualización no se pudo completar", "error");
                }
            }
        })

    }


}


$('#tabla_persona').on('click','.editar', function(){
    var data = t_persona.row($(this).parents('tr')).data();//Detecta a que fila hago click y me captura los datos en la variable data.
   if (t_persona.row(this).child.isShown ())
   {//Cuando esta en tamaño responsivo
        var data = t_persona.row(this).data();
   }
    $("#modal_editar").modal({backdrop: 'static', keyboard: false})
    $("#modal_editar").modal('show');
    document.getElementById('txtid_persona').value = data.id_persona;
    document.getElementById('txtnombre_editar').value = data.persona_nombre;
    document.getElementById('txtapepat_editar').value = data.persona_apepat;
    document.getElementById('txtapemat_editar').value = data.persona_apemat;
    document.getElementById('txtnro_editar_actual').value = data.persona_nrodocumento;
    document.getElementById('txtnro_editar_nuevo').value = data.persona_nrodocumento;
    $("#cmb_tdocumento_editar").val(data.persona_tipodocumento).trigger("change");
    $("#cmb_sexo_editar").val(data.persona_sexo).trigger("change");
    $("#cmb_status").val(data.persona_estatus).trigger("change");
    document.getElementById('txttelefono_editar').value = data.persona_telefono;
    document.getElementById('div_error_editar').style.display = "none";
 })


function mensaje_error(nombre, apellidopat, apellidomat, documentonuevo, tdocument, sexo, telefono, id) {
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
    document.getElementById(id).style.display = "block";
    document.getElementById(id).innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + cadena;

}

function limpiar_modal()
{

    document.getElementById('txtnombre').value = "";
    document.getElementById('txtapepat').value = "";
    document.getElementById('txtapemat').value = "";
    document.getElementById('txtnro').value = "";
    document.getElementById('txttelefono').value = "";
}
