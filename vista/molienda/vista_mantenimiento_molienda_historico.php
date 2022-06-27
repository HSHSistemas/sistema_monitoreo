<div class="row">
    <div class="col-md-12">
        <div class="ibox ibox-default">
            <div class="ibox-head">
                <div class="ibox-title">HISTORICO MOLIENDA</div>
                <div class="ibox-tools">
                </div>
            </div>
            <div class="ibox-body">
                <table id="tabla_molienda_historico" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th style="text-align: center;">Materia</th>
                            <th style="text-align: center;">N&deg; de control</th>
                            <th style="text-align: center;">Corte</th>
                            <th style="text-align: center;">Fecha entrada</th>
                            <th style="text-align: center;">Hora entrada</th>
                            <th style="text-align: center;">Kg</th>
                            <th style="text-align: center;">N&deg; de molino</th>
                            <th style="text-align: center;">Fecha salida</th>
                            <th style="text-align: center;">Hora salida</th>
                            <th style="text-align: center;">Tamizado</th>
                            <th style="text-align: center;">Polvo (KG)</th>
                            <th style="text-align: center;">Te (kG)</th>
                            <th style="text-align: center;">N&deg; de malla</th>
                            <th style="text-align: center;">Merma</th>
                            <th style="text-align: center;">Rendimiento</th>
                            <th style="text-align: center;">Observaciones</th>
                            <th style="text-align: center;">Imagen</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th>#</th>
                            <th>Materia</th>
                            <th>N&deg; de control</th>
                            <th>Corte</th>
                            <th>Fecha entrada</th>
                            <th style="text-align: center;">Hora entrada</th>
                            <th>Kg</th>
                            <th>N&deg; de molino</th>
                            <th style="text-align: center;">Fecha salida</th>
                            <th style="text-align: center;">Hora salida</th>
                            <th style="text-align: center;">Tamizado</th>
                            <th style="text-align: center;">Polvo (KG)</th>
                            <th style="text-align: center;">Te (kG)</th>
                            <th style="text-align: center;">N&deg; de malla</th>
                            <th style="text-align: center;">Merma</th>
                            <th style="text-align: center;">Rendimiento</th>
                            <th style="text-align: center;">Observaciones</th>
                            <th style="text-align: center;">Imagen</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>


<script src="../js/console_molienda.js?rev=<?php echo time(); ?>">
</script>


<script>
    $(document).ready(function() {
        listar_molienda_historico();
    });

    $('#Modal_Registro').on('shown.bs.modal', function() {
        $('#txt_usu').trigger('focus')

    })

</script>
