var t_prod_term_inv;
function listar_inventario() {

    t_prod_term_inv = $("#tabla_inventario_prod_term").DataTable({
        "ordering": false,
        "pageLength": 10,
        "destroy": true,
        "async": false,
        "responsive": true,
        "autoWidth": false,
        "ajax": {
            "method": "POST",
            "url": "../controlador/producto_terminado/controlador_inventario_prod_term_listar.php",
        },
        "columns": [

            { "defaultContent": "" },
            { "data": "nombre" },
            //{ "data": "rol_feregistro" },
            {
                "data": "stock",

                render: function (data, type, row) {
                    if (data > 1000) {
                        return "<span class='badge badge-success badge-pill m-r-5 m-b-5'>" + data + "</span>";
                    }
                    else {
                        return "<span class='badge badge-danger badge-pill m-r-5 m-b-5'>"
                            + data + "</span>";
                    }
                }
            },


        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $($(nRow).find("td")[1]).css('text-align', 'center');
            $($(nRow).find("td")[2]).css('text-align', 'center');
        },
        "language": idioma_espanol,
        select: true
    });
    t_prod_term_inv.on('draw.dt', function () {
        var PageInfo = $('#tabla_inventario_prod_term').DataTable().page.info();
        t_prod_term_inv.column(0, { page: 'current' }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1 + PageInfo.start;
        });
    });

}
