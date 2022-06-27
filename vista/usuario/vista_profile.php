    <div class="row">
        <div class="col-lg-3 col-md-4">
            <div class="ibox">
                <div class="ibox-body text-center">
                    <form method="POST" action="#" enctype="multipart/form-data" onsubmit="return false">
                        <div class="m-t-20">
                            <img class="img-circle" id="txt_img_profile" />
                        </div>
                        <h5 class="font-strong m-b-10 m-t-10" id="txt_persona_profile"></h5>
                        <div class="m-b-20 text-muted" id="txt_rol_profile"></div>
                        <div class="profile-social m-b-20">
                            <input type="file" name="" id="txt_img_profile2" accept="image/*" class="form-control">
                        </div>
                        <div>
                            <button class="btn btn-info btn-rounded m-b-10" onclick="Editar_Foto_Profile()"><i class="fa fa-refresh"></i> Actualizar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-9 col-md-8">
            <div class="ibox">
                <div class="ibox-body">
                    <ul class="nav nav-tabs tabs-line">
                        <li class="nav-item active">
                            <a class="nav-link" href="#tab-2" data-toggle="tab"><i class="ti-settings"></i> Datos Personales</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#tab-3" data-toggle="tab"><i class="ti-announcement"></i> Contraseña</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="tab-2">
                        <div class="row">
                                <div class="col-lg-12">
                                    <label for="">Nombre</label>
                                    <input type="text" id="txt_nombres_profile" class="form-control">
                                </div>
                                <div class="col-lg-12">
                                    <label for="">Apellido Paterno</label>
                                    <input type="text" id="txt_apepat_profile" class="form-control">
                                </div>
                                <div class="col-lg-12">
                                    <label for="">Apellido Materno</label>
                                    <input type="text" id="txt_apemat_profile" class="form-control">
                                </div>

                                <div class="col-lg-12">
                                    <label for="">Numero de documento</label>
                                    <input type="text" id="txt_nrodocuemto_profile" class="form-control">
                                </div>
                                <div class="col-lg-12">
                                    <label for="">Tipo Documento</label>
                                    <select class="js-example-basic-single" id="cmb_tdocumento_profile" style="width:100%">
                                        <option value="DNI">DNI</option>
                                        <option value="PASAPORTE">PASAPORTE</option>
                                        <option value="RUC">RUC</option>
                                    </select>
                                </div>

                                <div class="col-lg-6">
                                    <label for="">Sexo</label>
                                    <select class="js-example-basic-single" id="cmb_sexo_profile" style="width:100%">
                                        <option value="MASCULINO">MASCULINO</option>
                                        <option value="FEMENINO">FEMENINO</option>
                                    </select>
                                </div>


                                <div class="col-lg-6">
                                    <label for="">Telefono</label>
                                    <input type="text" class="form-control" id="txttelefono_profile" onkeypress="return soloNumeros(event)">
                                </div>

                                <div class="col-lg-12" style="text-align: center;">
                                    <br>
                                    <button class="btn btn-info btn-rounded m-b-10" onclick="Datos_Actualizar()"><i class="fa fa-refresh"></i> Actualizar</button>
                                </div>

                                <div class="col-lg-12"><br>
                                    <div class="alert alert-danger alert-bordered" style="display: none" id="div_error_profile">
                                </div>
                                </div>

                            </div>
                        </div>
                        <div class="tab-pane fade" id="tab-3">
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="">Contraseña actual</label>
                                    <input type="password" id="txt_conacactualescrita_profile" class="form-control">
                                    <input type="text" id="txt_conac_profile" hidden> 
                                </div>

                                
                                <div class="col-lg-6">
                                    <label for="">Nueva contraseña</label>
                                    <input type="password" id="txt_connueva_profile" class="form-control">
                                </div>
                                
                                <div class="col-lg-6">
                                    <label for="">Repetir Contraseña</label>
                                    <input type="password" id="txt_conrepetir_profile" class="form-control">
                                </div>

                                <div class="col-lg-12" style="text-align: center;">
                                    <br>
                                    <button class="btn btn-info btn-rounded m-b-10" onclick="actualizar_contra()"><i class="fa fa-refresh"></i> Actualizar contraseña</button>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="../js/console_usuario.js?rev=<?php echo time(); ?>"> </script>

    <script>
        TraerDatosPerfil();
        $(document).ready(function() {
            $('.js-example-basic-single').select2();
        });

        document.getElementById("txt_img_profile2").addEventListener("change", () => {
            var fileName = document.getElementById("txt_img_profile2").value;
            var idxDot = fileName.lastIndexOf(".") + 1;
            var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();
            if (extFile == "jpg" || extFile == "jpeg" || extFile == "png") {
                //TO DO 
            } else {
                Swal.fire("Mensaje de advetencia", "Solo se aceptan imagenes, ustes subio un archivo con exención " + extFile, "warning");
                document.getElementById("txt_img_profile2").value = " ";
            }
        });
    </script>