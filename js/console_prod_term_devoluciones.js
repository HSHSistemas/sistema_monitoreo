var t_prod_devoluciones;
function listar_prod_devoluciones() {

    t_prod_devoluciones = $("#tabla_prod_devoluciones").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/producto_terminado/controlador_devoluciones_listar.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "nombre" },
            { "data": "lote" },
            {"data": "cantidad"},
            {"data": "motivo"},
            { "data": "fecha"}


        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $($(nRow).find("td")[0]).css('text-align', 'center');
            $($(nRow).find("td")[1]).css('text-align', 'center');
            $($(nRow).find("td")[2]).css('text-align', 'center');
            $($(nRow).find("td")[3]).css('text-align', 'center');
            $($(nRow).find("td")[4]).css('text-align', 'center');
            $($(nRow).find("td")[5]).css('text-align', 'center');
            $($(nRow).find("td")[6]).css('text-align', 'center');
        },
        "language": idioma_espanol,
        select: true
    });
    t_prod_devoluciones.on('draw.dt', function () {
        var PageInfo = $('#tabla_prod_devoluciones').DataTable().page.info();
        t_prod_devoluciones.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}

function AbrirModal() {
    $("#Modal_Registro_p").modal({ backdrop: 'static', keyboard: false })
    $("#Modal_Registro_P").modal("show");
    limpiar_modal();
}

function Buscar_Producto(){
    var lote = document.getElementById('txtlote').value;
    console.log(lote);

    $.ajax({
        url: '../controlador/producto_terminado/controlador_traer_producto.php',
        type: 'POST',
        data: {
            lote: lote
        }
    }).done(function (resp) {
        var data = JSON.parse(resp)
        if (data.length > 0) {
            document.getElementById('txtproducto').innerHTML=data[0][0];
           
        }
    })

}

function Registar_Entrada() {
    var lote = document.getElementById('txtlote').value;
    var cantidad = document.getElementById('txtcantidad').value;
    var motivo = $('#txtmotivo').val();
    
    if ( lote.length === 0 || lote === null || cantidad.length === 0 || cantidad === null || motivo.length === 0 || motivo === null) {
        mensaje_error(lote, cantidad, motivo,'div_error');
        return Swal.fire("Mensaje de advetencia", "Llene el/los campo/s vacio/s", "warning");
    }
    else {

        $.ajax({
            url: '../controlador/producto_terminado/controlador_registro_devolucion_producto_terminado.php',
            type: 'POST',
            data: {
                lote: lote,
                cantidad: cantidad,
                motivo: motivo,
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
                        t_prod_devoluciones.ajax.reload();
                        limpiar_modal()
                        $("#Modal_Registro_P").modal("hide");
                        Swal.fire("Mensaje de confirmación", "Datos guardados", "success");
                    }
                    else {
                        Swal.fire("Mensaje de advertencia", "La persona ya se encuentra registrado", "warning");
                    }
                }
                else {
                    Swal.fire("Mensaje de error", "El registro no se pudo completar", "error");
                }
            }
        })

    }


}

function mensaje_error(lote, cantidad, motivo, id) {
    var cadena = "";

    if (lote.length == 0) {
        cadena += "El campo lote no debe estar vacio.<br>";
    }

    if (cantidad.length == 0) {
        cadena += "El campo cantidad no debe estar vacio.<br>";
    }

    if (motivo.length == 0) {
        cadena += "El campo fecha caducidad no debe estar vacio.<br>";
    }

    document.getElementById(id).style.display = "block";
    document.getElementById(id).innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + cadena;

}

function limpiar_modal()
{
    document.getElementById('txtlote').value = "";
    document.getElementById('txtcantidad').value = "";
    document.getElementById("txtmotivo").value = "";
}



contenido_textarea = ""
num_caracteres_permitidos = 250;

function valida_longitud(){
   num_caracteres = $('#txtmotivo').val().length;

   if (num_caracteres > num_caracteres_permitidos)
   {
    Swal.fire("Mensaje de advetencia", "Ha excedido el máximo de caracteres", "warning");
   }
}