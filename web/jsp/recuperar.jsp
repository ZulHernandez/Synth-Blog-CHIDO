<%-- 
    Document   : registro
    Created on : 4/11/2016, 01:44:46 PM
    Author     : Alumno
--%>
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
   
    <script src="../css/sweetalert-master/dist/sweetalert.min.js" type="text/javascript"></script>
    <link href="../css/sweetalert-master/dist/sweetalert.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="../css/material.min.css">
    <script src="../css/material.min.js"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link href="../css/login.css" rel="stylesheet" type="text/css"/>
    <link rel="icon" type="image/png" href="../imgs/sico.ico"/>
    <script src="../scripts/validaRegistro.js" type="text/javascript"></script>
    <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script>
        function validar(){
            var correoC=document.getElementById("mailc").value;
            var correoR=document.getElementById("mailr").value;
            if(correoC==' '||correoR==''){
                alert("Llena todos los campos");
                $("#mailc").val("");
                $("#mailr").val("");
                $("#mailc").focus();
            }else
                if(validoCorreo(correoC)&& validoCorreo(correoR))
            {
                ya();
                alert("Validos");
                
            }else
            {
                alert("Correos invalidos");
                $("#mailc").val("");
                $("#mailr").val("");
                $("#mailc").focus();
            }
        }
    </script>
    <style>
        body
        {
            overflow-x: hidden;
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
        table{
            width: 30%;
        }
        body
        {
            overflow-x: hidden;
        }
    </style>
    <script>
        function recuperar(){
            $("#claveRecuperacion").focus();
            if($("#claveRecuperacion").val()==''){
                alert("Necesitas introducir tu nueva clave para completar el proceso");
            }else
            {
                if(tieneEspecialesCad($("#claveRecuperacion").val()))
                {
                    alert("Clave invalida, introduce una valida");
                    $("#claveRecuperacion").val("");
                    $("#claveRecuperacion").focus();
                }else
                {
                    $.post(
                    "../recuperar",
                    {peticion:"0",correoC:$("#mailc").val(),correoR:$("#mailr").val(),claveRecuperacion:$("#claveRecuperacion").val()},
                    function(respuesta){
                        alert(respuesta);
                    }
                    );
                }
            }
        }
        function ya()
        {
            document.getElementById('fin').style.display = 'block';
            document.getElementById("booton").style.opacity = '0.6';
            document.getElementById("booton").style.cursor = 'not-allowed';
            document.getElementById("booton").disabled = true;
            document.getElementById("mailc").style.opacity = '0.6';
            document.getElementById("mailc").style.cursor = 'not-allowed';
            document.getElementById("mailc").disabled = true;
            document.getElementById("mailr").style.opacity = '0.6';
            document.getElementById("mailr").style.cursor = 'not-allowed';
            document.getElementById("mailr").disabled = true;
            
        }
    </script>
    </head>
    <style>
        #particles-js
        {
            width: 100%;
            height: 130%;
        }
    </style>
    <body>
        <div id="particles-js"></div>
        <div id="todo">
            <div id="cabeza">
                <center>
                    <img src="../imgs/syntw.png" id="cabe" width= "25%" align="middle" />
                </center>
            </div>
            <br><br>
            <div id="cuerpo">
                <center><b>
                        <p><txt>Recuperar cuenta</txt></p>
                        <form id="datos" method="post" autocomplete="off">
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="email" id="mailc" name="mailc" >
                                <label class="mdl-textfield__label"><center>Correo de la cuenta...</center></label>
                            </div><br><br>
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="email" id="mailr" name="mailr" >
                                <label class="mdl-textfield__label"><center>Correo de recuperaci&#243;n...</center></label>
                            </div><br><br>
                        </form>
                        <form id="recuperar" method="post" >
                            <input type="button" value="Mandar correo" id="booton" onclick="validar();"/><br>
                            <div id="fin" style="display:none;">
                                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                    <input class="mdl-textfield__input" type="text" id="claveRecuperacion" name="claverRecuperacion">
                                    <label class="mdl-textfield__label"><center>Clave...</center></label>
                                </div><br><br>
                                <input type="button" value="Recuperar" id="recupera" name="recupera" onclick="recuperar();"/><br>
                            </div>
                        </form>
                        <br/><hr/>
                        <table>
                            <tr>
                                <td id="rc">
                                    <a href="../login"><b>Ya poseo una cuenta</b></a>
                                </td>
                                <td>
                                    |
                                </td>
                                <td id="r">
                                    <a href="registro.jsp"><b>Registrarse</b></a>
                                </td>
                                </b></tr>
                        </table>
                        <hr><br>
                    </b></center>
            </div>
        </div>  
        <script src="../css/particles.js" type="text/javascript"></script>
        <script src="../css/app.js" type="text/javascript"></script>
    </body>
</html>
