var t_molienda;
function listar_molienda() {

    t_molienda = $("#tabla_molienda").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/molienda/controlador_molienda.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "materia_nombre" },
            { "data": "materia_no_control" },
            { "data": "molienda_corte" },
            { "data": "molienda_fecha_entrada" },
            { "data": "molienda_hora_entrada" },
            { "data": "molienda_kg_ingresados" },
            { "data": "id_molino" },
            { "data": "molienda_fecha_salida" },
            { "data": "molienda_hora_salida" },
            { "data": "molienda_tamizado" },
            { "data": "molienda_polvo" },
            { "data": "molienda_te" },
            { "data": "molienda_no_malla" },
            { "data": "molienda_merma" },
            { "data": "molienda_rendimiento" },
            { "data": "molienda_observaciones" },
            { "data": "molienda_img_url" ,

                render: function (data, type, row) {
                return '<img src="../' + data + '" class="img-circle m-r-10" style="width: 28px;">';

            }
            },
            { "defaultContent": "<button class='editar btn btn-primary' ><i class='fa fa-edit'></i></button>" }


        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $($(nRow).find("td")[2]).css('text-align', 'center');
            $($(nRow).find("td")[3]).css('text-align', 'center');
            $($(nRow).find("td")[4]).css('text-align', 'center');
            $($(nRow).find("td")[5]).css('text-align', 'center');
            $($(nRow).find("td")[6]).css('text-align', 'center');
            $($(nRow).find("td")[7]).css('text-align', 'center');
            $($(nRow).find("td")[8]).css('text-align', 'center');
            $($(nRow).find("td")[10]).css('text-align', 'center');
            $($(nRow).find("td")[11]).css('text-align', 'center');
            $($(nRow).find("td")[12]).css('text-align', 'center');
            $($(nRow).find("td")[13]).css('text-align', 'center');
        },
        "language": idioma_espanol,
        select: true
    });
    t_molienda.on('draw.dt', function () {
        var PageInfo = $('#tabla_molienda').DataTable().page.info();
        t_molienda.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}

function AbrirModal() {
    $("#Modal_Registro").modal({ backdrop: 'static', keyboard: false })
    $("#Modal_Registro").modal("show");
   // document.getElementById('div_error').style.display = "none";
    limpiar_modal();
}


function listar_materia_combo() {
    $.ajax({
        url: "../controlador/molienda/controlador_materia_combo_listar.php",
        type: "POST"
    }).done(function (resp) {
        data = JSON.parse(resp);
        cadena = "";
        if (data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                cadena += "<option value='" + data[i][0] + "'>" + data[i][1] + "</option>";
            }
            document.getElementById('cmb_materia').innerHTML = cadena;
            document.getElementById('cmb_materia').innerHTML = cadena;

        }
        else {
            document.getElementById('cmb_materia').innerHTML = "no se encontraron datos";
        }
    })
}

function Registar_Molienda() {


    var materia = document.getElementById('cmb_materia').value;
    var corte = document.getElementById('txt_corte').value;
    var kg = document.getElementById('txt_KG').value;
    var molino = document.getElementById('cmb_molino').value;


    if (materia.length === 0 || materia === null || corte.length === 0 || corte === null || kg.length === 0 || kg === null || molino.length === 0 || molino === null) {
        mensaje_error(materia, corte, kg, molino,'div_error');
        return Swal.fire("Mensaje de advetencia", "Llene el campo vacio", "warnig");
    }
    $.ajax({
        url: '../controlador/molienda/controlador_registro_molienda.php',
        type: 'POST',
        data: {
            materia: materia,
            corte: corte,
            kg: kg,
            molino: molino
        }
    }).done(function (resp) {
        console.log(resp);
        if (resp > 0) {

            if (resp == 1) {
                t_molienda.ajax.reload();
                $("#Modal_Registro").modal("hide");
                Swal.fire("Mensaje de confirmación", "Datos guardados", "success");
            }
        }
        else {
            Swal.fire("Mensaje de error", "El registro no se pudo completar", "error");
        }
    })
}

$('#tabla_molienda').on('click','.editar', function(){
    var data = t_molienda.row($(this).parents('tr')).data();//Detecta a que fila hago click y me captura los datos en la variable data.
   if (t_molienda.row(this).child.isShown ())
   {//Cuando esta en tamaño responsivo
        var data = t_molienda.row(this).data();
   }
    $("#modal_editar").modal({backdrop: 'static', keyboard: false})
    $("#modal_editar").modal('show');
    document.getElementById('txtid_molienda').value = data.id_molienda;
    document.getElementById('txtkg_entrada').value = data.molienda_kg_ingresados;
    document.getElementById('div_error_editar').style.display = "none";
 })

function mensaje_error(materia, corte, kg, molino, id) {
    var cadena = "";
    if (materia.length === 0 || materia === null) {
        cadena = "El campo materia no debe estar vacio.<br>";
    }

    if (corte.length == 0) {
        cadena += "El campo corte no debe estar vacio.<br>";
    }

    if (kg.length == 0) {
        cadena += "El cammpo kg no debe estar vacio.<br>";
    }

    if (molino.length == 0) {
        cadena += "El campo molino no debe estar vacio.<br>";
    }

    document.getElementById(id).style.display = "block";
    document.getElementById(id).innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + cadena;

}

function limpiar_modal()
{

    document.getElementById('txt_corte').value = "";
    document.getElementById('txt_KG').value = "";
}

function Editar_Usuario() {

    var merma = 0;
    var rendimiento = 0;

    var id = document.getElementById('txtid_molienda').value;
    var tamizado = document.getElementById('txttamizado_editar').value;
    var polvo = document.getElementById('txtpolvo_editar').value;
    var te = document.getElementById('txttekg_editar').value;
    var nromalla = document.getElementById('txtnro_malla_editar').value;
    var status = document.getElementById('cmb_estatus').value;
    var observaciones = document.getElementById('txtobservaciones_editar').value;
    var kgentrada = document.getElementById('txtkg_entrada').value;
    var archivo = document.getElementById('imagen').value;
    kgentrada=parseFloat(kgentrada);


    //calculo de molienda
    var materia_molienda = 0;
    materia_molienda = parseFloat(polvo) + parseFloat(te);
    merma = parseFloat(merma)
    merma = kgentrada - materia_molienda;

    //caculo de rendimiento
    var materia_molienda =parseFloat(polvo) + parseFloat(te);
    rendimiento = (materia_molienda * 100) / kgentrada;
    

    var f = new Date();
    var extension = archivo.split('.').pop();
    var nombrearchivo = "IMG" + f.getDate() + "" + (f.getMonth() + 1) + "" + f.getFullYear() + "" + f.getHours() + "" + f.getMinutes() + "" + f.getSeconds() + "." + extension;
    var formData = new FormData();
    var foto = $("#imagen")[0].files[0];

    formData.append('id', id);
    formData.append('tamizado', tamizado);
    formData.append('polvo', polvo);
    formData.append('te', te);
    formData.append('nromalla', nromalla);
    formData.append('status', status);
    formData.append('observaciones', observaciones);
    formData.append('merma', merma);
    formData.append('rendimiento', rendimiento);
    formData.append('foto', foto);
    formData.append('nombrearchivo', nombrearchivo);

    $.ajax({
        url: '../controlador/molienda/controlador_molienda_editar.php',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function (respuesta) {
            if (respuesta != 0) {
                if (respuesta == 1) {
                    LimpiarCampos();
                    t_molienda.ajax.reload();
                    $("#modal_editar").modal("hide");
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


function calcular_merma(polvo,te, merma,kgentrada)
{

    var materia_molienda = 0;
    materia_molienda = parseFloat(polvo) + parseFloat(te);
    merma = parseFloat(merma)
     merma = kgentrada - materia_molienda;
     return merma;
}

function calcular_rendimiento(rendimiento,polvo,te,kgentrada)
{
    var materia_molienda =parseFloat(polvo) + parseFloat(te);
    rendimiento = (materia_molienda * 100) / kgentrada;
    return rendimiento;
}
function LimpiarCampos()
{
    document.getElementById('txt_corte').value = "";
    document.getElementById('txt_KG').value = "";

    document.getElementById('txtid_molienda').value = "";
    document.getElementById('txttamizado_editar').value= "";
    document.getElementById('txtpolvo_editar').value= "";
    document.getElementById('txttekg_editar').value= "";
    document.getElementById('txtnro_malla_editar').value= "";
    document.getElementById('cmb_estatus').value= "";
    document.getElementById('txtobservaciones_editar').value= "";
    document.getElementById('txtkg_entrada').value= "";
    document.getElementById('imagen').value= "";
}




var t_molienda_historico;
function listar_molienda_historico() {

    t_molienda_historico = $("#tabla_molienda_historico").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/molienda/controlador_historico_molienda.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "materia_nombre" },
            { "data": "materia_no_control" },
            { "data": "molienda_corte" },
            { "data": "molienda_fecha_entrada" },
            { "data": "molienda_hora_entrada" },
            { "data": "molienda_kg_ingresados" },
            { "data": "id_molino" },
            { "data": "molienda_fecha_salida" },
            { "data": "molienda_hora_salida" },
            { "data": "molienda_tamizado" },
            { "data": "molienda_polvo" },
            { "data": "molienda_te" },
            { "data": "molienda_no_malla" },
            { "data": "molienda_merma" },
            { "data": "molienda_rendimiento" },
            { "data": "molienda_observaciones" },
            { "data": "molienda_img_url" ,

                render: function (data, type, row) {
                return '<img src="../' + data + '" class="img-circle m-r-10" style="width: 28px;">';

            }
            }


        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $($(nRow).find("td")[2]).css('text-align', 'center');
            $($(nRow).find("td")[3]).css('text-align', 'center');
            $($(nRow).find("td")[4]).css('text-align', 'center');
            $($(nRow).find("td")[5]).css('text-align', 'center');
            $($(nRow).find("td")[6]).css('text-align', 'center');
            $($(nRow).find("td")[7]).css('text-align', 'center');
            $($(nRow).find("td")[8]).css('text-align', 'center');
            $($(nRow).find("td")[10]).css('text-align', 'center');
            $($(nRow).find("td")[11]).css('text-align', 'center');
            $($(nRow).find("td")[12]).css('text-align', 'center');
            $($(nRow).find("td")[13]).css('text-align', 'center');
        },
        "language": idioma_espanol,
        select: true
    });
    t_molienda_historico.on('draw.dt', function () {
        var PageInfo = $('#tabla_molienda_historico').DataTable().page.info();
        t_molienda_historico.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}