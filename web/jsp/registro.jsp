<%-- 
    Document   : recuperar
    Created on : 4/11/2016, 01:46:32 PM
    Author     : Alumno
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Synth!WebCommunity</title>
    </head>
    <script src="../scripts/validaRegistro.js" type="text/javascript"></script>
    <script src="../css/sweetalert-master/dist/sweetalert.min.js" type="text/javascript"></script>
    <link href="../css/sweetalert-master/dist/sweetalert.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="../css/material.min.css">
    <script src="../css/material.min.js"></script>
    <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link href="../css/login.css" rel="stylesheet" type="text/css"/>
    <link rel="icon" type="image/png" href="../imgs/sico.ico"/>
    <script>
        
       
        function divs()
        {
            document.getElementById('segundoDiv').style.display = 'block';
            document.getElementById('primerDiv').style.display = 'none';
        }
        function divs2()
        {
            document.getElementById('segundoDiv').style.display = 'none';
            document.getElementById('primerDiv').style.display = 'block';
        }
        function imagenes(x)
        {
            var view = new FileReader();
            if (x.files && x.files[0])
            {
                view.onload = function (a)
                {
                    $('#preview').attr('src', a.target.result);
                };
                view.readAsDataURL(x.files[0]);
            }
        }
        $("#imgs").change(function () {
            imagenes(this);
        });
        function borrar()
        {
            var value = Document.getElementById("mes").value;
            if (value !== "") {
                Document.getElementById("mes").value = "";
            }

        }
        function txt2()
        {
            var str = document.getElementById("fotoUsr").value;
            var valida=false;
            document.getElementById("ext2").innerHTML = str;
            document.getElementById("dir").value=str;
            //alert(document.getElementById("ext2").innerHTML);
            valida=extensionValida(document.getElementById("ext2").innerHTML);
            
        }

        function rango()
        {
            var val = document.getElementById("anio").value;
            if (val < 1971) {
                document.getElementById("anio").value = "1971";
            } else
            {
                if (val > 2016)
                {
                    document.getElementById("anio").value = "1971";
                }else
                {
                    if (isNaN(val))
                    {
                        document.getElementById("anio").value = "1971";
                    }
                }
            }
        }
        function bi()
        {
            var val = document.getElementById("anio").value;
            var mes = document.getElementById("mes").value;
            var di = document.getElementById("dia").value;
            var bi = val % 4;
            if (bi == 0 && mes == "Febrero")
            {
                document.getElementById("dia").max = "29";
                if (di > 29)
                {
                    document.getElementById("dia").value = "1";

                }
            } else
            {
                if (bi != 0 && mes == "Febrero")
                {
                    document.getElementById("dia").max = "28";
                    if (di > 28)
                    {
                        document.getElementById("dia").value = "1";

                    }
                } else
                {
                    if (mes == "Enero" || mes == "Marzo" || mes == "Mayo" || mes == "Julio" || mes == "Agosto" || mes == "Octubre" || mes == "Diciembre")
                    {
                        document.getElementById("dia").max = "31";
                        if (di > 31)
                        {
                            document.getElementById("dia").value = "1";

                        }
                    } else
                    {
                        if (mes == "Abril" || mes == "Junio" || mes == "Septiembre" || mes == "Noviembre")
                        {
                            document.getElementById("dia").max = "30";
                            if (di > 30)
                            {
                                document.getElementById("dia").value = "1";

                            }
                        } else
                        {
                            document.getElementById("mes").value = "Enero";
                            document.getElementById("dia").max = "31";
                        }
                    }
                }
            }
        }
        function borra()
        {
            document.getElementById("mes").value = "";
        }
    </script>
    <script>
         var arrayImgs=["imgCarrete1.png","imgCarrete2.png","imgCarrete3.png","imgCarrete4.png","imgCarrete5.png","imgCarrete6.png"];
        function procesaEnvio(){
            document.getElementById("tipoPeticion").value="0";
            
            $.ajax({
                url:"../registro",
                type:"POST",
                data:$("#datosReg").serialize(),
                success:function(respuesta){
                    alert(respuesta);
                },
                error:function(){
                    alert("No registro");
                }   
            });
        }
           function cargarImgSketch()
           {
               $("#modeloSketchFab").ready(
                       ponerImgsCarrete()
                );
               
           }
           function ponerImgsCarrete()
           {
               $("#carreteSketch").attr("src","/Synth_BLOG/imgs/"+arrayImgs[0]);
               $("#carreteSketch").data("numImg","0");       
           }
           
           setInterval(
                   
            function()
            {   
               
               var imgActual=parseInt($("#carreteSketch").data("numImg"));
               
               if(imgActual<arrayImgs.length-1)
               {
                   $("#carreteSketch").attr("src","/Synth_BLOG/imgs/"+arrayImgs[imgActual+1]);
                   $("#carreteSketch").data("numImg",imgActual+1);
               }
               else
               {
                   if(imgActual==arrayImgs.length-1)
                   {
                       $("#carreteSketch").attr("src","/Synth_BLOG/imgs/"+arrayImgs[0]);
                       $("#carreteSketch").data("numImg","1");
                   }
               }
    
            }, 3000);
            
        
    </script>
    <style>
        #contenido
        {
            background-color: transparent;
            color: black;
            padding: 10px;
            display: block;
            border-color:black;
            border-style: solid;
            border-radius: 6px;
            width: 100%;
            overflow: none;
            font-family: inherit;
            height: 64%;
            resize: none;
        }
        .mdl-textfield,.mdl-js-textfield, .mdl-textfield--floating-label, .mdl-textfield__input, .mdl-textfield__label
        {
            color: black;
            border-color: black;
            border-width: 2px;
        }

        .mdl-textfield__input
        {

            background-color: transparent;
        }
        .mdl-textfield__input:focus
        {

            background-color: rgba(214,214,214,0.5);
        }
        .mdl-textfield__label:after
        {
            background-color:#000000;
        }
        #table{
            width: 30%;
        }
        #cuer{
            width: 90%;
        }
        #container
        { 
            background-color: rgba(0,0,0,.8);
            padding: 20px;
        }
        gatito
        {
            text-transform: uppercase;
        }
        .file-upload {
            position: relative;
            overflow: hidden;
            margin: 10px; }

        .file-upload input.file-input {
            position: absolute;
            top: 0;
            right: 0;
            margin: 0;
            padding: 0;
            font-size: 20px;
            cursor: pointer;
            opacity: 0;
            filter: alpha(opacity=0); }
        .boto,.file-upload
        {
            background-color: white;
            color: black;
            border-color: transparent;
            -webkit-transition-duration: 0.2s; 
            transition: all 0.2s;
            display: inline-block;
            cursor: pointer;
            text-transform: uppercase;
        }

        .file-upload:hover,.boto:hover
        {
            background-color: #002233; 
            color:white;
            text-transform: uppercase;
        }
        .fec
        {
            border-bottom-color: black;
            border-bottom-width: 2px;
            border-top-color: transparent;
            border-left-color: transparent;
            border-right-color: transparent;
            background-color: transparent;
        }
        body
        {
            overflow-x: hidden;
        }
        #enviar:focus
        {
            outline:0px;
        }
        
        #carreteSketch
        {
            width:55%;
            height:55%;
            
           

        }
    </style>
    <body onload="cargarImgSketch();">
        <div id="todo">
            <div id="cabeza">
                <center>
                    <img src="../imgs/syntw.png" width= "25%" align="middle" />
                </center>
            </div>
            <div id="cuerpo" >
                <center><b>
                        <p><txt>Registro</txt></p>
                        <table id="cuer">
                            <tr>
                                <td >
                                    <img id="carreteSketch" src="" data-numImg="">
                                </td>
                                <td>
                            <center>
                                <div id="primerDiv">
                                    <form id="datosReg" name="datosReg" method="post" autocomplete="off" action="../registro" enctype="multipart/form-data">
                                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                            <input class="mdl-textfield__input" id="nombre" name="nombre" type="text">
                                            <label class="mdl-textfield__label"><center>Nombre...</center></label>
                                        </div><br><br>
                                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                            <input class="mdl-textfield__input" id="apell" name="apell" type="text">
                                            <label class="mdl-textfield__label"><center>Apellidos...</center></label>
                                        </div><br><br>
                                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                            <input class="mdl-textfield__input" id="usr" name="usr" type="text">
                                            <label class="mdl-textfield__label"><center>Nombre de usuario...</center></label>
                                        </div><br><br>
                                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                            <input class="mdl-textfield__input" id="psw" name="psw" type="password">
                                            <label class="mdl-textfield__label"><center>Contrase&ntilde;a...</center></label>
                                        </div><br><br>
                                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                            <input class="mdl-textfield__input" id="pswC" name="pswC" type="password">
                                            <label class="mdl-textfield__label"><center>Contrase&ntilde;a (confirmaci&oacute;n)...</center></label>
                                        </div><br><br>
                                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                            <input class="mdl-textfield__input" id="correo" name="correo" type="text">
                                            <label class="mdl-textfield__label"><center>Correo...</center></label>
                                        </div><br><br>
                                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                            <input class="mdl-textfield__input" id="correoR" name="correoR" type="text">
                                            <label class="mdl-textfield__label"><center>Correo (recuperaci&oacute;n)...</center></label>
                                        </div><br><br>
                                        <input type="button" value="Siguiente &raquo;" id="boton" onclick="divs();"/><br>
                                        </div>
                                        <div id="segundoDiv" style='display:none;'>
                                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                                <label><center>Fecha de nacimiento...</center></label>
                                                <table>
                                                    <td>
                                                        <input class="fec" id="anio" name="anio" type="number" min="1971" max="2016" placeholder="A&ntilde;o" style="width: 100%;" onchange="rango();">&nbsp;
                                                        &nbsp;<input class="fec" name="mes" list="mon" id="mes" placeholder="Mes" style="width: 100%" onchange="bi();" onclick="borra();">&nbsp;
                                                        &nbsp;<input id="dia" name="dia" class="fec" type="number" min="01" max="31" placeholder="D&iacute;a" style="width: 100%" onchange="bi();">
                                                    </td>
                                                </table>
                                            </div><br><br>
                                            <input type="hidden" id="tipoPeticion" name="tipoPeticion" value=" " >
                                            
                                           <!-- <form id="foto" name="foto" action="../registro" method="post" enctype="multipart/form-data">
                                            <!--<label><center>Foto de perfil...</center></label>
                                            <br/><br/>
                                            <!--<center><img src="" width="60" height="60" /><br /><center/>
                                            <button class="file-upload" id="enviar" name="enviar"><input type="file" id="fotoUsr" name="fotoUsr" class="file-input" onchange="txt2();"/>Agregar imagen:<div id="ext2" name="ext2"></div></button>
                                                -->
                                                
                                                <br/><br/>
                                                <label>Descripci&oacute;n...</label>
                                                <textarea id="contenido"  rows="4" maxlength="300" name="contenido" placeholder="Escribe aqu&iacute;..."></textarea>
                                                <br/><br/>
                                                <input type="button" value="&laquo; Volver" id="boton" onclick="divs2();"/><br/><br/>
                                                <input type="button" value="Registrarse" id="enviar" onclick="validacion();"/> 
                                           
                                        </form>
                                                                                        
                                            <!--<input type="hidden" id="dir" name="dir" value="0" >-->
                                        </div><br/><br/>
                                </div>
                            </center>    
                            </td>
                            </tr>
                        </table>
                        <hr>
                        <table id="table">
                            <tr>
                                <td id="rc">
                                    <a href="recuperar.jsp"><b>Recuperar Cuenta</b></a>
                                </td>
                                <td>
                                    |
                                </td>
                                <td id="r">
                                    <a href="../login"><b>Ya poseo una cuenta</b></a>
                                </td>
                                </b></tr>
                        </table>
                        <hr/><br>
                    </b></center>
            </div>
        </div>
        <datalist id="mon">
            <option value="Enero">01</option>
            <option value="Febrero">02</option>
            <option value="Marzo">03</option>
            <option value="Abril">04</option>
            <option value="Mayo">05</option>
            <option value="Junio">06</option>
            <option value="Julio">07</option>
            <option value="Agosto">08</option>
            <option value="Septiembre">09</option>
            <option value="Octubre">10</option>
            <option value="Noviembre">11</option>
            <option value="Diciembre">12+</option>
        </datalist>
    </body>
</html>
