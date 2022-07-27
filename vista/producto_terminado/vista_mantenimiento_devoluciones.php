<div class="row">
    <div class="col-md-12">
        <div class="ibox ibox-default">
            <div class="ibox-head">
                <div class="ibox-title">PRODUCTO TERMINADO DEVOLUCIONES</div>
                <div class="ibox-tools">
                    <button class="btn btn-primary" onclick="AbrirModal()">Nuevo registro</button>
                </div>
            </div>
            <div class="ibox-body">
                <table id="tabla_prod_devoluciones" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th style="text-align: center;">Producto</th>
                            <th style="text-align: center;">Lote</th>
                            <th style="text-align: center;">Cantidad</th>
                            <th style="text-align: center;">Motivo devolución</th>
                            <th style="text-align: center;">Fecha</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th>#</th>
                            <th style="text-align: center;">Producto</th>
                            <th style="text-align: center;">Lote</th>
                            <th style="text-align: center;">Cantidad</th>
                            <th style="text-align: center;">Motivo devolución</th>
                            <th style="text-align: center;">Fecha</th>
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
        <h5 class="modal-title" id="exampleModalLongTitle">Registro de devolución</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="row">

        <div class="col-lg-12">
            <label for="">Lote</label>
            <input type="text" onblur="Buscar_Producto()" autocomplete="off"  class="form-control" id="txtlote">
          </div>

          <div class="col-lg-12">
            <label for="">Producto</label>
            <p id="txtproducto">
          </div>
          <div class="col-lg-12">
            <label for="">Cantidad</label>
            <input type="text" autocomplete="off" class="form-control" id="txtcantidad" onkeypress="return soloNumeros(event)">
          </div>
          <br>  
          <div class="col-lg-12">
            <textarea id="txtmotivo" onKeyDown="valida_longitud()" onKeyUp="valida_longitud()" style="position: relative; top: 25px;" placeholder="Escribe aquí el motivo de la devolución" rows="5" cols="65"></textarea>
          </div>
          <div class="col-lg-12"><br>
            <div class="alert alert-danger alert-bordered" style="display: none" id="div_error"></div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
          <button type="button" class="btn btn-primary" onclick="Registar_Entrada()">Guardar</button>
        </div>
      </div>
    </div>
  </div>
</div>



<script src="../js/console_prod_term_devoluciones.js?rev=<?php echo time(); ?>">
</script>


<script>
    $(document).ready(function() {
        $('.js-example-basic-single').select2();
        listar_prod_devoluciones();
        valida_longitud();
        
    });

</script>