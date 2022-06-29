<div class="row">
    <div class="col-md-12">
        <div class="ibox ibox-default">
            <div class="ibox-head">
                <div class="ibox-title">PRODUCTO TERMINADO SALIDAS</div>
                <div class="ibox-tools">
                    <button class="btn btn-link btn-sm" onclick="AbrirModal_US()">Nueva salida US</button>
                    <button class="btn btn-primary" onclick="AbrirModal()">Nueva salida MX</button>
                </div>
            </div>
            <div class="ibox-body">
                <table id="tabla_prod_salidas" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th style="text-align: center;">Producto</th>
                            <th style="text-align: center;">Lote</th>
                            <th style="text-align: center;">Fecha Caducidad</th>
                            <th style="text-align: center;">Fecha Salida</th>
                            <th style="text-align: center;">Cantidad</th>
                            <th style="text-align: center;">Folio venta</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th>#</th>
                            <th style="text-align: center;">Producto</th>
                            <th style="text-align: center;">Lote</th>
                            <th style="text-align: center;">Fecha Caducidad</th>
                            <th style="text-align: center;">Fecha Salida</th>
                            <th style="text-align: center;">Cantidad</th>
                            <th style="text-align: center;">Folio venta</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="Modal_Registro_P" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Registro de salida</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-lg-12">
            <label for="">Producto</label>
            <select class="js-example-basic-single" id="cmb_producto" style="width:100%">
            </select>
          </div>
          <div class="col-lg-12">
            <label for="">Lote</label>
            <select class="js-example-basic-single_1" id="cmb_lote" style="width:100%">
            </select>
          </div>
          <div class="col-lg-6">
            <label for="">Cantidad de salida</label>
            <input type="text" autocomplete="off" class="form-control" id="txtcantidad_salida" onkeypress="return soloNumeros(event)">
          </div>
          <div class="col-lg-6">
            <label for="">Cantidad disponible</label>
            <input type="text" readonly autocomplete="off" class="form-control" id="txtcantidad_disponible" onkeypress="return soloNumeros(event)">
          </div>
          <div class="col-lg-12">
            <label for="">Fecha caducidad</label>
            <input type="text" readonly autocomplete="off" class="form-control" id="txtfecha_caducidad" onkeypress="return soloNumeros(event)">
          </div>

          <div class="col-lg-12">
            <label for="">Folio Venta</label>
            <input type="text" autocomplete="off" class="form-control" id="txt_folio_venta" onkeypress="return soloNumeros(event)">
          </div>

          <div class="col-lg-12"><br>
            <div class="alert alert-danger alert-bordered" style="display: none" id="div_error"></div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
          <button type="button" class="btn btn-primary" onclick="Registar_Salida()">Guardar</button>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="Modal_Registro_Salida" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Registro de salida</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="row">

          <div class="col-lg-12">
            <label for="">Producto</label>
            <select class="js-example-basic-single" id="cmb_producto_2" style="width:100%">
            </select>
          </div>
          
          <div class="col-lg-6">
            <label for="">Cantidad de salida</label>
            <input type="text" autocomplete="off" class="form-control" id="txtcantidad_salida_2" onkeypress="return soloNumeros(event)">
            <br>
            <button type="button" class="btn btn-success" onclick="Buscar_Lotes()">Buscar lotes</button>
            <br>
          </div>

          <div class="col-lg-6">
            <label for="">Folio Venta</label>
            <input type="text" autocomplete="off" class="form-control" id="txt_folio_venta_2" onkeypress="return soloNumeros(event)">
          </div>

          <br>
          <div class="col-lg-12">
            <p>Seleccione los lotes<p>
            <div id="container"></div>
            <div>
          </div>

          <div class="col-lg-12"><br>
            <div class="alert alert-danger alert-bordered" style="display: none" id="div_error_2"></div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
            <button type="button" class="btn btn-primary" onclick="Registar_Salida_2()">Guardar</button>
          </div>
      </div>
    </div>
  </div>
</div>


<script src="../js/console_prod_term_salidas.js?rev=<?php echo time(); ?>">
</script>


<script>
    $(document).ready(function() {
        $('.js-example-basic-single').select2();
        listar_prod_salidas();
        obtener_lotes();
        obtener_datos_extra();
        
    });

</script>