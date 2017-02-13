<%-- 
    Document   : activacion
    Created on : 23/11/2016, 07:41:15 AM
    Author     : Alumno
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Activa tu cuenta</title>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script src="../scripts/validaRegistro.js" type="text/javascript"></script>
        <script type="text/javascript">
                    
            function validaToken(){
                var cad=document.getElementById("token").value;
                if(!cad==''){
                    if(tieneEspecialesCad(cad) || cad.length!=32)
                    {
                        alert('El token es invalido, revisa por favor que no contenga espacios ni caracteres invalidos o que no sean mas de 32 caracteres.');
                        document.getElementById("token").value="";
                        $("#token").focus();
                    }else
                    {
                         $.post(
                                "../agregaDatos",
                            {tipoPeticion:"3",token:cad},
                             function(respuesta){
                                 alert(respuesta);
                             }
                         )
                    }
                }
                else
                {
                    alert("Ingresa tu token por favor");
                    $("#token").focus();
                }
            }
        </script>
    </head>
    <body>
        <h1>Bienvenido</h1>
        Ingresa el token para activar tu cuenta:
        <input type="text" id="token" name="token" placeholder="Escribe aqui tu token" /><br /><br />
        <input type="button" id="cambia" name="cambia" value="Enviar" onclick="validaToken();"/>
    </body>
</html>
