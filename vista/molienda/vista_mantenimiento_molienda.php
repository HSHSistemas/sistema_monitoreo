<div class="row">
    <div class="col-md-12">
        <div class="ibox ibox-default">
            <div class="ibox-head">
                <div class="ibox-title">MANTENIMIENTO MOLIENDA</div>
                <div class="ibox-tools">
                    <button class="btn btn-primary" onclick="AbrirModal()">Nuevo registro</button>
                </div>
            </div>
            <div class="ibox-body">
                <table id="tabla_molienda" class="display" style="width:100%">
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
                            <th>Acci&oacute;n</th>
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
                            <th>Acci&oacute;n</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="Modal_Registro" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Registro Molienda</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="row">

                <div class="col-lg-12">
                        <label for="">Materia</label>
                        <select class="js-example-basic-single" id="cmb_materia" style="width:100%">
                        </select><br>
                    </div>

                    <div class="col-lg-6">
                        <label for="">Corte</label>
                        <input type="text" class="form-control" id="txt_corte" onkeypress="return sololetras(event)"> <br>
                    </div>

                    <div class="col-lg-6">
                        <label for="">KG</label>
                        <input type="text" class="form-control" onkeypress="return soloNumeros_punto(event)" id="txt_KG"> <br>
                    </div>

                    <div class="col-lg-12">
                    <label for="">molino</label>
                    <select class="js-example-basic-single" id="cmb_molino" style="width:100%">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">N/A</option>
                    </select>
                    </div>

                    <div class="col-lg-12"><br>
                    <div class="alert alert-danger alert-bordered" style="display: none" id="div_error"> 
                    </div>
                    </div>

                    <!--
                    <div class="col-lg-12">
                        <label for="">Subir Imagen</label>
                        <input type="file" id="imagen" accept="image/*" style="width: 100%;">
                    </div>
                        -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="Registar_Molienda()">Guardar</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal_editar" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Editar Molienda</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-lg-12">
            <input type="text" id="txtid_molienda" hidden>
          </div>

          <div class="col-lg-12">
            <label for="">Tamizado</label>
            <input type="text" class="form-control" id="txttamizado_editar">
          </div>
          
          <div class="col-lg-12">
            <label for="">Polvo (KG)</label>
            <input type="text" class="form-control" id="txtpolvo_editar">
          </div>
          <div class="col-lg-12">
            <label for="">TE (KG)</label>
            <input type="text" class="form-control" id="txttekg_editar">
          </div>

          <div class="col-lg-12">
            <label for="">Nro Malla</label>
            <input type="text" class="form-control" id="txtnro_malla_editar">
          </div>

          <div class="col-lg-12">
            <label for="">Estatus</label>
            <select class="js-example-basic-single"  id="cmb_estatus" style="width:100%">
                <option value="FINALIZADO">FINALIZADO</option>
            </select>
          </div>

          <div class="col-lg-12">
            <label for="">Observaciones</label>
            <input type="text" class="form-control" id="txtobservaciones_editar">
          </div>

          <div class="col-lg-12">
            <label for="">Subir Imagen</label>
            <input type="file" id="imagen" accept="image/*" style="width: 100%;">
          </div>

          <div class="col-lg-12">
          <input type="text" id="txtkg_entrada" hidden>
          </div>

          <div class="col-lg-12"><br>
            <div class="alert alert-danger alert-bordered" style="display: none" id="div_error_editar"></div>
          </div>

        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary" onclick="Editar_Usuario()">Actualizar</button>
      </div>
    </div>
  </div>
</div>


<script src="../js/console_molienda.js?rev=<?php echo time(); ?>">
</script>


<script>
    $(document).ready(function() {
        $('.js-example-basic-single').select2();
        listar_molienda();
        listar_materia_combo();
    });

    $('#Modal_Registro').on('shown.bs.modal', function() {
        $('#txt_usu').trigger('focus')

    })

</script>