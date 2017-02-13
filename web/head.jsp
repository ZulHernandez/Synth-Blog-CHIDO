<%-- 
    Document   : head
    Created on : 24/11/2016, 09:02:32 PM
    Author     : Saul
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
 HttpSession sesion=request.getSession();
    String usrId=sesion.getAttribute("id")==null?"":sesion.getAttribute("id").toString();
    String usr=sesion.getAttribute("usuario")==null?"":sesion.getAttribute("id").toString();
    String bd=sesion.getAttribute("bd")==null?"":sesion.getAttribute("bd").toString();
    if(usrId.equals(""))
        response.sendRedirect("login");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>TODO supply a title</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <script>
        function redPerfil(url)
        {
            window.body.location = url;
        }
        function validaFiltro()
        {
           var seleccion= $("#categoria").val();
           if(seleccion >0 & seleccion<=3)
           {
               alert("bien");
               $("#ser").attr("placeholder","Palabras clave de búsqueda");
           }else
           {
              alert("Elije un filtro de busqueda");
               $("#ser").attr("placeholder","Elije un filtro de búsqueda");
              
           }
        }
        function iniciarBusqueda(e)
            {
                var evento = e;
                var tecla=evento.keyCode;
                switch(tecla)
                {
                    case 13:
                      var queryBsq=$("#ser").val();
                      window.parent.frames[1].location="jsp/busqueda.jsp?queryBsq="+queryBsq;
                    break;
                }
                
            }
        window.onload = function() {
            
            document.onkeypress = iniciarBusqueda;
            
          }
        
    </script>
    <style>
        @font-face {
            font-family: "Roboto";
            src: url("/Synth_BLOG/fuentes/Roboto-Regular.ttf") format("truetype");

        }
        body
        {
            zoom: 0.9;
            background-color: rgba(245,240,235,1)
        }
        table
        {
            padding-left: 200px;
            width: 95%;
            float: right;
            z-index: 3;
            position: absolute;
        }
        .head
        {
            float: left;
            border-width: 3px;
            padding-left: 0%;
            padding-right: 0%;
            font-size:20px;
            border-color: rgba(0,0,0,0.5);
            color:black;
            cursor:pointer;
            border-style: solid;
            height: 100%;
            box-sizing: border-box;
            background-color: white;
            text-transform: uppercase;
            -webkit-transition-duration: 0.4s;
            transition-duration: 0.4s;
        }
        .head:hover
        {
            color:white;
            cursor:pointer;
            background-color: black;
        }
        .head:focus
        {
            outline:0px;
        }
        #ser
        {
            border-radius: 50px;
            width:70%;
            background-image: url('img/sear.png');
            background-size: 20px;
            background-position: 10px 7px;
            background-repeat: no-repeat;
            padding-left: 50px;
            height: 120%;
            font-size: 25px;
            cursor: text;
        }
        #ser:focus
        {
            color:white;
            cursor:pointer;
            background-color: black;
        }
        #lgo
        {
            z-index: 2;
            height: 110%;
            float: left;
            position: absolute;
        }
    </style>
    <script src="scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
    </head>
    <body style="margin-top: 0" onkeypress="iniciarBusqueda(this);">
        <img src="imgs/syntw.png" id="lgo" align="middle"/>&nbsp;
        <table>
            <tr>
                <td style="padding: 0px; align-content: center; padding-bottom: 0%;">
                    <input class="head" id="ser"  align="middle" placeholder="Elije un filtro de búsqueda"/>

                </td>
            </tr> 
            <tr style="padding-top: 0%;">
                <td style="width: 100%; padding-top: 0%;">
                    <center>
                        <a href="acceso" target="_top"><input align="middle" class="head" type="button" id="salida" name="salida" value="Salir" style="border-top-left-radius: 25px; border-bottom-left-radius: 25px; border-left-width: 1.5px; border-left-width: 3px; width: 15%;"/></a>
                        <a href="jsp/pUsuario.jsp" target="body"><input align="middle" class="head" type="button" id="inicio" name="inicio" value="Inicio" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 15%;"/></a>
                        <a href="jsp/teoria.jsp" target="body"><input align="middle" class="head" type="button" id="teoria" name="teoria" value="Teoria" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 15%;"/></a>
                        <a href="jsp/postear.jsp" target="body"><input align="middle" class="head" type="button" id="publicar" name="postear" value="Publicar" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 15%;"/></a>

                        <a href="jsp/perfil.jsp" target="body"><input align="middle" class="head" type="button" id="perfil" name="perfil" value="Perfil" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 15%;"/></a>
                        
                        <a href="jsp/cfgCuenta.jsp" target="body"><input align="middle" class="head" type="button" id="cfgCuenta" name="cfgCuenta" value="Configuraci&oacute;n" style="border-top-right-radius: 25px; border-bottom-right-radius: 25px; border-right-width: 1.5px; border-right-width: 3px; width: 15%;"/></a>
                        
                    </center>
                </td>
            </tr>
        </table>
    </body>
</html>
