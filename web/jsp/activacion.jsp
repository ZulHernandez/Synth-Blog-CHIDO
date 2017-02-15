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
                        $("#datos").css("display","none");
                        $("#loader").css("display","block");
                        alert("Verificando...");
                         $.post(
                                "../agregaDatos",
                            {tipoPeticion:"3",token:cad},
                             function(respuesta){
                                 alert(respuesta);
                                 $("#datos").css("display","block");
                                 $("#loader").css("display","none");
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
        <style>
           
                body
		{
                        background:url("../img/fondomusica1.jpg ");
			margin:0px;
                    
		}
            #datos
            {
                width:50%;
                height:70%;
                position: relative;
                left: 22%;
                margin-top: 15%;
               
                    background-color: rgba(214,214,214,0.3);
                    box-shadow: 0px 0px 20px #000000;
                    border-radius:3px;
                padding: 5%;
            }
            span
            {
                font-weight: bold;   
            }
            button
            {
                 width: 20%;
                background-color: RGB(21,133,183);
                color: white;
                border-color: transparent;
                -webkit-transition-duration: 0.2s; 
                transition: all 0.2s;
                display: inline-block;
                cursor: pointer;
            }
            #loader{ 
                    
                    border: 16px solid #f3f3f3; 
                    border-top: 16px solid #3498db; 
                    border-radius: 50%;
                    width: 120px;
                    height:120px;
                    animation: spin 2s linear infinite;
                    position: relative;
                    margin-top: 20%;
            }
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
                }
        </style>
    </head>
    <body>
    <center><div id='loader' style="display: none" > </div></center>
        <div id='datos'>
            <span>Ingrese abajo el token.</span>
            <br />
            <br />
            <input type="text" id="token" name="token" placeholder="Escribe aqui tu token" /><br /><br />
            <button id="cambia" name="cambia"  onclick="validaToken();">Enviar</button>
            <br />
            <br />
        </div>
    </body>
</html>
