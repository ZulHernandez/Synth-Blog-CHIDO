<%-- 
    Document   : head
    Created on : 24/11/2016, 09:02:32 PM
    Author     : Saul
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    String usrId = sesion.getAttribute("id") == null ? "" : sesion.getAttribute("id").toString();
    String usr = sesion.getAttribute("usuario") == null ? "" : sesion.getAttribute("id").toString();
    String bd = sesion.getAttribute("bd") == null ? "" : sesion.getAttribute("bd").toString();
    if (usrId.equals("")) {
        response.sendRedirect("login");
    }
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
                var seleccion = $("#categoria").val();
                if (seleccion > 0 & seleccion <= 3)
                {
                    alert("bien");
                    $("#ser").attr("placeholder", "Palabras clave de búsqueda");
                } else
                {
                    alert("Elije un filtro de busqueda");
                    $("#ser").attr("placeholder", "Elije un filtro de búsqueda");

                }
            }
            function iniciarBusqueda(e)
            {
                var evento = e;
                var tecla = evento.keyCode;
                switch (tecla)
                {
                    case 13:
                        var queryBsq = $("#ser").val();
                        window.parent.frames[1].location = "jsp/busqueda.jsp?queryBsq=" + queryBsq;
                        break;
                }

            }


            function out()
            {
                var largo1 = window.innerWidth;
                var logo = document.getElementById("lgo");
                var todo = document.getElementById("cont");
                var sal = document.getElementById("sal");
                var ini = document.getElementById("ini");
                var teo = document.getElementById("teo");
                var pub = document.getElementById("pub");
                var per = document.getElementById("per");
                var cfg = document.getElementById("cfg");

                if (largo1 > 975)
                {
                    todo.style.padding = "0px 0px 0px 200px";
                    logo.width = "200";
                    sal.innerHTML = "SALIR";
                    ini.innerHTML = "INICIO";
                    teo.innerHTML = "TEORIA";
                    pub.innerHTML = "PUBLICAR";
                    per.innerHTML = "PERFIL";
                    cfg.innerHTML = "CONFIGURACI&Oacute;N";

                } else
                {
                    todo.style.padding = "0px 0px 0px 10px";
                    logo.width = "0";
                    sal.innerHTML = "<img src='imgs/icon/salir.png' style='width:40px; padding-top:1px;'/>";
                    ini.innerHTML = "<img src='imgs/icon/muro.png' style='width:40px; padding-top:1px;'/>";
                    teo.innerHTML = "<img src='imgs/icon/toria.png' style='width:40px; padding-top:1px;'/>";
                    pub.innerHTML = "<img src='imgs/icon/publicar.png' style='width:40px; padding-top:1px;'/>";
                    per.innerHTML = "<img src='imgs/icon/perfil.png' style='width:40px; padding-top:1px;'/>";
                    cfg.innerHTML = "<img src='imgs/icon/config.png' style='width:40px; padding-top:1px;'/>";
                }
            }

            function redPerfil(url)
            {
                window.body.location = url;
            }
            window.onload = function ()
            {
                document.onkeypress = iniciarBusqueda;
                var largo1 = window.innerWidth;
                var logo = document.getElementById("lgo");
                var todo = document.getElementById("cont");
                var sal = document.getElementById("sal");
                var ini = document.getElementById("ini");
                var teo = document.getElementById("teo");
                var pub = document.getElementById("pub");
                var per = document.getElementById("per");
                var cfg = document.getElementById("cfg");

                if (largo1 > 975)
                {
                    todo.style.padding = "0px 0px 0px 200px";
                    logo.width = "200";
                    sal.innerHTML = "SALIR";
                    ini.innerHTML = "INICIO";
                    teo.innerHTML = "TEORIA";
                    pub.innerHTML = "PUBLICAR";
                    per.innerHTML = "PERFIL";
                    cfg.innerHTML = "CONFIGURACI&Oacute;N";

                } else
                {
                    todo.style.padding = "0px 0px 0px 10px";
                    logo.width = "0";
                    sal.innerHTML = "<img src='imgs/icon/salir.png' style='width:40px; padding-top:1px;'/>";
                    ini.innerHTML = "<img src='imgs/icon/muro.png' style='width:40px; padding-top:1px;'/>";
                    teo.innerHTML = "<img src='imgs/icon/toria.png' style='width:40px; padding-top:1px;'/>";
                    pub.innerHTML = "<img src='imgs/icon/publicar.png' style='width:40px; padding-top:1px;'/>";
                    per.innerHTML = "<img src='imgs/icon/perfil.png' style='width:40px; padding-top:1px;'/>";
                    cfg.innerHTML = "<img src='imgs/icon/config.png' style='width:40px; padding-top:1px;'/>";
                }
            }
            window.onresize = function ()
            {
                var largo1 = window.innerWidth;
                var logo = document.getElementById("lgo");
                var todo = document.getElementById("cont");
                var sal = document.getElementById("sal");
                var ini = document.getElementById("ini");
                var teo = document.getElementById("teo");
                var pub = document.getElementById("pub");
                var per = document.getElementById("per");
                var cfg = document.getElementById("cfg");

                if (largo1 > 975)
                {
                    todo.style.padding = "0px 0px 0px 200px";
                    logo.width = "200";
                    sal.innerHTML = "SALIR";
                    ini.innerHTML = "INICIO";
                    teo.innerHTML = "TEORIA";
                    pub.innerHTML = "PUBLICAR";
                    per.innerHTML = "PERFIL";
                    cfg.innerHTML = "CONFIGURACIÓN";

                } else
                {
                    todo.style.padding = "0px 0px 0px 10px";
                    logo.width = "0";
                    sal.innerHTML = "<img src='imgs/icon/salir.png' style='width:40px; padding-top:1px;'/>";
                    ini.innerHTML = "<img src='imgs/icon/muro.png' style='width:40px; padding-top:1px;'/>";
                    teo.innerHTML = "<img src='imgs/icon/toria.png' style='width:40px; padding-top:1px;'/>";
                    pub.innerHTML = "<img src='imgs/icon/publicar.png' style='width:40px; padding-top:1px;'/>";
                    per.innerHTML = "<img src='imgs/icon/perfil.png' style='width:40px; padding-top:1px;'/>";
                    cfg.innerHTML = "<img src='imgs/icon/config.png' style='width:40px; padding-top:1px;'/>";
                }
            }
            function blanco(i)
            {
                var largo1 = window.innerWidth;
                var sal = document.getElementById("sal");
                var ini = document.getElementById("ini");
                var teo = document.getElementById("teo");
                var pub = document.getElementById("pub");
                var per = document.getElementById("per");
                var cfg = document.getElementById("cfg");

                if (largo1 < 975)
                {
                    switch (i)
                    {
                        case 1:
                            sal.innerHTML = "<img src='imgs/icon/salirb.png' style='width:40px; padding-top:1px;'/>";
                            break;
                        case 2:
                            ini.innerHTML = "<img src='imgs/icon/murob.png' style='width:40px; padding-top:1px;'/>";
                            break;
                        case 3:
                            teo.innerHTML = "<img src='imgs/icon/toriab.png' style='width:40px; padding-top:1px;'/>";
                            break;
                        case 4:
                            pub.innerHTML = "<img src='imgs/icon/publicarb.png' style='width:40px; padding-top:1px;'/>";
                            break
                        case 5:
                            per.innerHTML = "<img src='imgs/icon/perfilb.png' style='width:40px; padding-top:1px;'/>";
                            break;
                        case 6:
                            cfg.innerHTML = "<img src='imgs/icon/configb.png' style='width:40px; padding-top:1px;'/>";
                            break;
                    }

                }
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

                width: 97%;
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
                height: 25%;
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
                width:99%;
                background-image: url('img/sear.png');
                background-size: 20px;
                background-position: 10px 7px;
                background-repeat: no-repeat;
                padding-left: 50px;
                height: 20%;
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
                float: left;
                position: absolute;
            }
        </style>
        <script src="scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
    </head>
    <body style="margin-top: 0">
        <img src="imgs/syntw.png" id="lgo" align="middle" />&nbsp;
        <table id="cont">
            <tr>
                <td style="padding: 0px; align-content: center; padding-bottom: 0%;">
                    <input class="head" id="ser"  align="middle"/>&nbsp;
                    <br/><br/><br/>
                </td>

            </tr> 
            <tr style="padding-top: 0%;">
                <td style="width: 100%; padding-top: 0%;">
            <center>
                <a href="acceso" target="_top"><button align="middle" class="head" type="button" id="salida" name="salida" value="Salir" style="border-top-left-radius: 25px; border-bottom-left-radius: 25px; border-left-width: 1.5px; border-left-width: 3px; width: 16%;" onmouseover="blanco(1);" onmouseout="out();"/><span id="sal"></span></button></a>
                <a href="jsp/pUsuario.jsp" target="body"><button align="middle" class="head" type="button" id="inicio" name="inicio" value="Inicio" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 16%;" onmouseover="blanco(2);" onmouseout="out();"/><span id="ini" ></span></button></a>
                <a href="jsp/teoria.jsp" target="body"><button align="middle" class="head" type="button" id="teoria" name="teoria" value="Teoria" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 16%;" onmouseover="blanco(3);" onmouseout="out();"/><span id="teo" ></span></button></a>
                <a href="jsp/postear.jsp" target="body"><button align="middle" class="head" type="button" id="publicar" name="postear" value="Publicar" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 16%;" onmouseover="blanco(4);" onmouseout="out();"/><span id="pub" ></span></button></a>
                <a href="jsp/perfil.jsp" target="body"><button align="middle" class="head" type="button" id="perfil" name="perfil" value="Perfil" style="border-left-width: 1.5px; border-right-width: 1.5px; width: 16%;" onmouseover="blanco(5);" onmouseout="out();"/><span id="per" ></span></button></a>
                <a href="jsp/cfgCuenta.jsp" target="body"><button align="middle" class="head" type="button" id="cfgCuenta" name="cfgCuenta" value="Configuraci&oacute;n" style="border-top-right-radius: 25px; border-bottom-right-radius: 25px; border-right-width: 1.5px; border-right-width: 3px; width: 19%;" onmouseout="out();" onmouseover="blanco(6);"/><span id="cfg"></span></button></a>
            </center>
        </td>
    </tr>
</table>
</body>
</html>
