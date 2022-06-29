var t_prod_entradas;
function listar_prod_entradas() {

    t_prod_entradas = $("#tabla_prod_entradas").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/producto_terminado/controlador_entradas_producto_listar.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "nombre" },
            {  "data": "lote" },
            {"data": "fecha_caducidad"},
            { "data": "fecha_entrada"},
            { "data": "cantidad" }


        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $($(nRow).find("td")[0]).css('text-align', 'center');
            $($(nRow).find("td")[1]).css('text-align', 'center');
            $($(nRow).find("td")[2]).css('text-align', 'center');
            $($(nRow).find("td")[3]).css('text-align', 'center');
            $($(nRow).find("td")[4]).css('text-align', 'center');
            $($(nRow).find("td")[5]).css('text-align', 'center');
        },
        "language": idioma_espanol,
        select: true
    });
    t_prod_entradas.on('draw.dt', function () {
        var PageInfo = $('#tabla_prod_entradas').DataTable().page.info();
        t_prod_entradas.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}

function AbrirModal() {
    $("#Modal_Registro_P").modal({ backdrop: 'static', keyboard: false })
    $("#Modal_Registro_P").modal("show");
    document.getElementById('div_error').style.display = "none";
    limpiar_modal();
    listar_producto_combo();

}


function listar_producto_combo() {
  $.ajax({
      url: "../controlador/producto_terminado/controlador_producto_combo_listar.php",
      type: "POST"
  }).done(function (resp) {
      data = JSON.parse(resp);
      cadena = "";
      if (data.length > 0) {
          for (var i = 0; i < data.length; i++) {
              cadena += "<option value='" + data[i][0] + "'>" + data[i][1] + "</option>";
          }
          document.getElementById('cmb_producto').innerHTML = cadena;

      }
      else {
          document.getElementById('cmb_producto').innerHTML = "no se encontraron datos";
      }
  })
}

function Registar_Entrada() {
    var producto = document.getElementById('cmb_producto').value;
    var lote = document.getElementById('txtlote').value;
    var cantidad = document.getElementById('txtcantidad').value;
    var fecha_caducidad = document.getElementById('fecha_caducidad').value;
    
    if (producto.length === 0 || producto === null || lote.length === 0 || lote === null || cantidad.length === 0 || cantidad === null || fecha_caducidad.length === 0 || fecha_caducidad === null) {
        mensaje_error(producto, lote, cantidad, fecha_caducidad,'div_error');
        return Swal.fire("Mensaje de advetencia", "Llene el/los campo/s vacio/s", "warning");
    }
    else {

        $.ajax({
            url: '../controlador/producto_terminado/controlador_registro_entrada_producto_terminado.php',
            type: 'POST',
            data: {
                producto: producto,
                lote: lote,
                cantidad: cantidad,
                fecha_caducidad: fecha_caducidad,
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
                        t_prod_entradas.ajax.reload();
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

function mensaje_error(producto, lote, cantidad, fecha_caducidad, id) {
    var cadena = "";
    if (producto.length === 0 || producto === null) {
        cadena = "El campo producto no debe estar vacio.<br>";
    }

    if (lote.length == 0) {
        cadena += "El campo lote no debe estar vacio.<br>";
    }

    if (cantidad.length == 0) {
        cadena += "El campo cantidad no debe estar vacio.<br>";
    }

    if (fecha_caducidad.length == 0) {
        cadena += "El campo fecha caducidad no debe estar vacio.<br>";
    }

    document.getElementById(id).style.display = "block";
    document.getElementById(id).innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + cadena;

}

function limpiar_modal()
{
    var producto = document.getElementById("cmb_producto");
    producto.remove(producto.selectedIndex);
    document.getElementById('txtlote').value = "";
    document.getElementById('txtcantidad').value = "";
    document.getElementById('fecha_caducidad').value = "";
}


