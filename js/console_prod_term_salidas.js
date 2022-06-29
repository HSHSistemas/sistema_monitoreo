var t_prod_salidas;
function listar_prod_salidas() {

    t_prod_salidas = $("#tabla_prod_salidas").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/producto_terminado/controlador_salidas_producto_listar.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "nombre" },
            {  "data": "lote" },
            {"data": "fecha_caducidad"},
            {"data": "fecha_salida"},
            { "data": "cantidad"},
            { "data": "folio_venta" }


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
    t_prod_salidas.on('draw.dt', function () {
        var PageInfo = $('#tabla_prod_salidas').DataTable().page.info();
        t_prod_salidas.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}

function AbrirModal() {
    $("#Modal_Registro_Salida").modal({ backdrop: 'static', keyboard: false })
    $("#Modal_Registro_Salida").modal("show");
    document.getElementById('div_error_2').style.display = "none";
    limpiar_modal();
    listar_producto_combo();
}

function AbrirModal_US() {
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
          document.getElementById('cmb_producto_2').innerHTML = cadena;

      }
      else {
          document.getElementById('cmb_producto').innerHTML = "no se encontraron datos";
      }
  })
}

function obtener_lotes(){

    $( ".js-example-basic-single" ).change(function() {
        var producto = document.getElementById('cmb_producto').value;
        llenar_combo_lotes(producto)
    
    });

}

function llenar_combo_lotes(producto)
{
    $.ajax({
        url: "../controlador/producto_terminado/controlador_lotes_producto_combo_listar.php",
        type: "POST",
        data: {
            producto: producto
        }
    }).done(function (resp) {
        data = JSON.parse(resp);
        cadena = "";
        if (data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                cadena += "<option value='" + data[i][0] + "'>" + data[i][1] + "</option>";
            }
            document.getElementById('cmb_lote').innerHTML = cadena;
  
        }
        else {
            document.getElementById('cmb_lote').innerHTML = "no se encontraron datos";
        }
    })
}

function obtener_datos_extra()
{
    $( ".js-example-basic-single_1").change(function() {
        id_entrada = $("#cmb_lote").val();
        document.getElementById('txtcantidad_disponible').value = "";
        document.getElementById('txtfecha_caducidad').value = "";

        $.ajax({
            url: "../controlador/producto_terminado/controlador_datos_restante_producto.php",
            type: "POST",
            data: {
                id_entrada: id_entrada
            }
        }).done(function (resp) {
            data = JSON.parse(resp);
            console.log(data[0][0]);
    
            document.getElementById('txtcantidad_disponible').value = data[0][1];
            document.getElementById('txtfecha_caducidad').value = data[0][0];
        })


    
    });
}

function Registar_Salida() {
    var producto = document.getElementById('cmb_producto').value;
    var lote = document.getElementById('cmb_lote').value;
    var cantidad_salida = document.getElementById('txtcantidad_salida').value;
    var cantidad_disponible= document.getElementById('txtcantidad_disponible').value;;
    var folio_venta = document.getElementById('txt_folio_venta').value;

    
    if (producto.length === 0 || producto === null || lote.length === 0 || lote === null || cantidad_salida.length === 0 || cantidad_salida === null || folio_venta.length === 0 || folio_venta === null) {
        mensaje_error(producto, lote, cantidad_salida,folio_venta,'div_error');
        return Swal.fire("Mensaje de advetencia", "Llene el/los campo/s vacio/s", "warning");
    }
    else {

        cantidad_salida = parseFloat(cantidad_salida);
        cantidad_disponible = parseFloat(cantidad_disponible);
        
        if (cantidad_salida <= cantidad_disponible)
        {
            console.log(cantidad_salida);
            console.log(cantidad_disponible);
            $.ajax({
                url: '../controlador/producto_terminado/controlador_registro_salida_producto_terminado.php',
                type: 'POST',
                data: {
                    producto: producto,
                    lote: lote,
                    cantidad_salida: cantidad_salida,
                    folio_venta: folio_venta,
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
                            t_prod_salidas.ajax.reload();
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
        else
        {
            return Swal.fire("Mensaje de advetencia", "No hay la cantidad de producto en el lote solicitado", "warning");
        }

        

    }


}

function mensaje_error(producto, lote, cantidad_salida,folio_venta, id) {
    var cadena = "";
    if (producto.length === 0 || producto === null) {
        cadena = "El campo producto no debe estar vacio.<br>";
    }

    if (lote.length == 0) {
        cadena += "El campo lote no debe estar vacio.<br>";
    }

    if (cantidad_salida.length == 0) {
        cadena += "El campo cantidad no debe estar vacio.<br>";
    }

    if (folio_venta.length == 0) {
        cadena += "El campo folio venta no debe estar vacio.<br>";
    }

    document.getElementById(id).style.display = "block";
    document.getElementById(id).innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + cadena;

}

function limpiar_modal()
{
    $('#cmb_lote').empty();
    $('#cmb_producto').empty();
    document.getElementById('txtcantidad_salida').value = "";
    document.getElementById('txtcantidad_disponible').value = "";
    document.getElementById('txtfecha_caducidad').value = "";
    document.getElementById('txt_folio_venta').value = "";
    document.getElementById('txtcantidad_salida_2').value = "";
    
    

}

function Buscar_Lotes(){
$("#container").html("");
var cantidad_salida = document.getElementById('txtcantidad_salida_2').value;
var producto = document.getElementById('cmb_producto_2').value;
cantidad_salida= parseInt(cantidad_salida)

$.ajax({
    url: '../controlador/producto_terminado/controlador_verificar_cantidad_producto.php',
    type: 'POST',
    data: {
        producto: producto
    }
}).done(function (resp) {
    var data = JSON.parse(resp)
    if (data.length > 0) {
        var stock;
        console.log(data);
        stock=parseFloat(data[0][0]);
        console.log(stock);
       if( stock>= cantidad_salida )
       {
        llenar_checkbox_lotes(producto, cantidad_salida);
       }
       else
       {
        return Swal.fire("Mensaje de advertencia", "No hay la cantidad de producto en stock", "warning");
       }
    }
})

}


function llenar_checkbox_lotes(producto,cantidad_salida)
{
    $.ajax({
        url: "../controlador/producto_terminado/controlador_lotes_producto_checkbox_listar.php",
        type: "POST",
        data: {
            producto: producto
        }
    }).done(function (resp) {
        data = JSON.parse(resp);
        var cant_Prod_ACT = parseInt(0);
        var cant_disp_lote = parseInt(0);
        var cant_faltante = parseInt(0);

        if (data.length > 0) 
        {

            for (var i = 0; i < data.length; i++) {
                cant_disp_lote = parseInt(data[i][2]);
                if ( cant_disp_lote < cantidad_salida )
                {                    
                    cant_Prod_ACT = cant_Prod_ACT+cant_disp_lote;
                    console.log(data[i][2]);
                    if (cant_Prod_ACT < cantidad_salida)
                    {
                        
                        $('#container')
                        .append(`<input type="checkbox" id="${data[i][0]}" name="lotes" value="${data[i][1]}">`)
                        .append(`<label for="${data[i][1]}">${data[i][1]}</label></div>`)
                        .append(`<br>`);
                    }

                    if (cant_Prod_ACT >= cantidad_salida)
                    {
                        
                        $('#container')
                        .append(`<input type="checkbox" id="${data[i][0]}" name="lotes" value="${data[i][1]}">`)
                        .append(`<label for="${data[i][1]}">${data[i][1]}</label></div>`)
                        .append(`<br>`);
                        break;
                    }
                }
                if ( cant_disp_lote == cantidad_salida )
                {
                    $('#container')
                        .append(`<input type="checkbox" id="${data[i][0]}" name="lotes" value="${data[i][1]}">`)
                        .append(`<label for="${data[i][1]}">${data[i][1]}</label></div>`)
                        .append(`<br>`);
                        break;
                }

                if ( cant_disp_lote > cantidad_salida )
                {
                    var cantidad_nueva_Lote = 0;

                    cantidad_nueva_Lote = cant_disp_lote - cantidad_salida;
                    $('#container')
                        .append(`<input type="checkbox" id="${data[i][0]}" name="lotes" value="${data[i][1]}">`)
                        .append(`<label for="${data[i][1]}">${data[i][1]}</label></div>`)
                        .append(`<br>`);
                        break;
                }

                /*
                else 
                {
                    if (cant_Prod_ACT == cantidad_salida  )
                    {
                        console.log("es igual");
                    }
                    else
                    {
                        cant_faltante= cantidad_salida - cant_Prod_ACT;
                        if ((cant_disp_lote - cant_faltante) > 0 )
                            {
                            $('#container')
                            .append(`<input type="checkbox" id="${data[i][0]}" name="interest" value="${data[i][1]}">`)
                            .append(`<label for="${data[i][1]}">${data[i][1]}</label></div>`)
                            .append(`<br>`);
                             }
                    }

                }*/
            }
        }
        console.log(data);
    })
}

function Registar_Salida_2() {

    var producto = document.getElementById('cmb_producto_2').value;
    var cantidad_salida = document.getElementById('txtcantidad_salida_2').value;
    var folio_venta = document.getElementById('txt_folio_venta_2').value;
    var lote;

    var lotes= [];

    $('input:checkbox[name=lotes]:checked').each(function(){
        lotes.push(($(this).val()));
      });

      
    if (producto.length === 0 || producto === null || lotes.length === 0 || lotes === null || cantidad_salida.length === 0 || cantidad_salida === null || folio_venta.length === 0 || folio_venta === null) {
        mensaje_error2(producto, lote, cantidad_salida,folio_venta,'div_error_2');
        return Swal.fire("Mensaje de advetencia", "Llene el/los campo/s vacio/s", "warning");
    }
    else {
        
        cantidad_salida = parseFloat(cantidad_salida);
        //cantidad_disponible = parseFloat(cantidad_disponible);
        
        if (lotes.length == 1)
        {
            lote=lotes[0];
            console.log(cantidad_salida);
            //console.log(cantidad_disponible);
            $.ajax({
                url: '../controlador/producto_terminado/controlador_registro_salida_un_lote.php',
                type: 'POST',
                data: {
                    producto: producto,
                    lote: lote,
                    cantidad_salida: cantidad_salida,
                    folio_venta: folio_venta,
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
                            t_prod_salidas.ajax.reload();
                            limpiar_modal()
                            $("#Modal_Registro_Salida").modal("hide");
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
        if (lotes.length == 2)
        {
            var lote_uno;
            var lote_dos;

            lote_uno = lotes[0];
            lote_dos = lotes[1];
            
            console.log(cantidad_salida);
            //console.log(cantidad_disponible);
            $.ajax({
                url: '../controlador/producto_terminado/controlador_registro_salida_dos_lote.php',
                type: 'POST',
                data: {
                    producto: producto,
                    lote_uno: lote_uno,
                    lote_dos: lote_dos,
                    cantidad_salida: cantidad_salida,
                    folio_venta: folio_venta,
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
                            t_prod_salidas.ajax.reload();
                            limpiar_modal()
                            $("#Modal_Registro_Salida").modal("hide");
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
        if (lotes.length == 3)
        {
            var lote_uno;
            var lote_dos;
            var lote_tres;

            lote_uno = lotes[0];
            lote_dos = lotes[1];
            lote_tres = lotes[2];
            
            console.log(cantidad_salida);
        
            $.ajax({
                url: '../controlador/producto_terminado/controlador_registro_salida_tres_lote.php',
                type: 'POST',
                data: {
                    producto: producto,
                    lote_uno: lote_uno,
                    lote_dos: lote_dos,
                    lote_tres: lote_tres,
                    cantidad_salida: cantidad_salida,
                    folio_venta: folio_venta,
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
                            t_prod_salidas.ajax.reload();
                            limpiar_modal()
                            $("#Modal_Registro_Salida").modal("hide");
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
        if (lotes.length == 4)
        {
            var lote_uno;
            var lote_dos;
            var lote_tres;
            var lote_cuatro;

            lote_uno = lotes[0];
            lote_dos = lotes[1];
            lote_tres = lotes[2];
            lote_cuatro = lotes[3];
            
            console.log(cantidad_salida);
        
            $.ajax({
                url: '../controlador/producto_terminado/controlador_registro_salida_cuatro_lote.php',
                type: 'POST',
                data: {
                    producto: producto,
                    lote_uno: lote_uno,
                    lote_dos: lote_dos,
                    lote_tres: lote_tres,
                    lote_cuatro:lote_cuatro,
                    cantidad_salida: cantidad_salida,
                    folio_venta: folio_venta,
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
                            t_prod_salidas.ajax.reload();
                            limpiar_modal()
                            $("#Modal_Registro_Salida").modal("hide");
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
        else
        {
            return Swal.fire("Mensaje de advetencia", "No hay la cantidad de producto en el lote solicitado", "warning");
        }

        

    }


}

function mensaje_error2(producto, lote, cantidad_salida,folio_venta, id) {
    var cadena = "";
    if (producto.length === 0 || producto === null) {
        cadena = "El campo producto no debe estar vacio.<br>";
    }

    if (cantidad_salida.length == 0) {
        cadena += "El campo cantidad no debe estar vacio.<br>";
    }

    if (folio_venta.length == 0) {
        cadena += "El campo folio venta no debe estar vacio.<br>";
    }

    document.getElementById(id).style.display = "block";
    document.getElementById(id).innerHTML = "<strong>Revise los siguientes campos: </strong><br>" + cadena;

}
