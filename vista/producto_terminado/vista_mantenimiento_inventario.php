<div class="row">
    <div class="col-md-12">
        <div class="ibox ibox-default">
            <div class="ibox-head">
                <div class="ibox-title">Inventario Producto Terminado</div>
                <div class="ibox-tools">
                </div>
            </div>
            <div class="ibox-body">
                <table id="tabla_inventario_prod_term" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th style="text-align: center;">Nombre</th>
                            <th style="text-align: center;">Cantidad</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th>#</th>
                            <th style="text-align: center;">Nombre</th>
                            <th style="text-align: center;">Cantidad</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="../js/console_prod_term_inventario.js?rev=<?php echo time(); ?>">
</script>


<script>
    $(document).ready(function() {
        $('.js-example-basic-single').select2();
        listar_inventario()
    });

</script>