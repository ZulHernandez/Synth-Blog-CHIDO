<%-- 
    Document   : cono
    Created on : 15-may-2016, 17:41:03
    Author     : Alpine
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String par = "";
    String para = "";
    String titulo = "";
    String msj = "";
    par = request.getParameter("par") == null ? "" : request.getParameter("par");
    String not = "";
    if(par.equals("gatito")){
        titulo = request.getParameter("nombre") == null ? "" : request.getParameter("nombre");
        msj = request.getParameter("contenido") == null ? "" : request.getParameter("contenido");
        Clases.cMail gatito = new Clases.cMail();
        //for(int i = 0; i <= 50; i++){
        if(!titulo.equals("")){
            if(!msj.equals("")){
                if(gatito.mandaMail(titulo, msj)){
                    not = "Mail enviado con exito!!!";
                }else{
                    not = gatito.getError();
                }
            }else{
                not = "Mail no enviado: Contenido vacio";
            }
        }else{
            not = "Mail no enviado: Autor Vacio";
        }
            
        //}
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>MARSOFT&#174;</title>
        <link href="../css/contacto.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" href="../../css/material.min.css">
        <script src="../../css/sweetalert-master/dist/sweetalert.min.js" type="text/javascript"></script>
        <link href="../../css/sweetalert-master/dist/sweetalert.css" rel="stylesheet" type="text/css"/>
        <script src="../../css/material.min.js"></script>
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="icon" type="image/png" href="../../imgs/favicon.ico"/>
    </head>
    <body>
        <style>
            
            .mdl-layout__header
            {
                background-color: #121D24;
            }
            .mdl-layout__drawer
            {
                background-color: #121D24;
            }
            .mdl-layout-title
            {
                font-size: 32px;
            }
            .mdl-layout__drawer-button
            {
                padding-top: 3px;
                color: white;
            }
            .nota
            {
                background-color: green;
                color: white;
                padding: 20px;
            }
        </style>
        <script type="text/javascript">
            function validacion(){
                var valido = false;
                var autor = document.getElementById("contenidos");
                var mensaje = document.getElementById("contenido");
                if(autor.value != "" && autor.value != null){
                    if(mensaje.value != "" && mensaje.value != null){
                       // alert("ya tru");
                        valido = true;
                    }else{
                        swal({title: 'ERROR',text: 'Mensaje Vacio',type: 'error',showConfirmButton: true,timer: 3000, html: false,allowEscapeKey:false},function(){valido=false;});
                    }
                }else{
                    swal({title: 'ERROR',text: 'Autor Vacio',type: 'error',showConfirmButton: true,timer: 3000, html: false,allowEscapeKey:false},function(){valido=false;});
                }
                return valido;
            }
            function confirma(){
                swal({
                    title: 'CONFIRMACION',
                    text:'Confirmar envio de formulario',
                    type:'warning',
                    showCancelButton:true,
                    closeOnConfirm:false,
                    closeOnCancel:true,
                    confirmButtonText:'Confirmar',
                    cancelButtonText:'Cancelar',
                    animation:'slide-from-top',
                },
                function(isConfirm){  
                    if(isConfirm){
                        var regreso = false;
                        regreso = validacion();
                        if(regreso){
                            formu.submit();
                        }
                    }else{
                        swal('Cancelado','El mail no de ha enviado','error');
                    }
                });
            }
        </script>
        <div class="mdl-layout--no-desktop-drawer-button mdl-layout mdl-js-layout">
            <header class="mdl-layout__header ">
                <div class="mdl-layout-icon"></div>
                <div class="mdl-layout__header-row">
                    <span class="mdl-layout-title" id="titulo2"><a href="../../index.html"><font color="white"><b>MARSOFT&#174</b></font></a></span>
                    <div class="mdl-layout-spacer"></div>
                    <nav class="mdl-navigation">
                        <a class="mdl-navigation__link" href="cono.html" onclick="muestra(1);"><b><font color="white">&laquo;CONOCENOS&raquo;</font></b></a>
                        <a class="mdl-navigation__link" href="prop.html"><b><font color="white">&laquo;PROPUESTAS&raquo; </font></b></a>
                        <a class="mdl-navigation__link" href="contacto.jsp"><b><font color="white">&laquo;CONTACTANOS&raquo; </font></b></a>
                        <a class="mdl-navigation__link" href="htm.html"><b><font color="white">&laquo;DO IT YOURSELF&raquo; </font></b></a>
                        <a class="mdl-navigation__link" href="descargas.html"><b><font color="white">&laquo;DOWNLOADS&raquo; </font></b></a>
                        <a class="mdl-navigation__link" href="../../login" target="_blank"><b><font color="white">&laquo;SYNTH&#33;&raquo; </font></b></a>
                    </nav>
                </div>
            </header>
            <div class="mdl-layout__drawer">
                <span class="mdl-layout-title"><a href="../../index.html"><font color="white"><b>MARSOFT&#174</b></font></a></span>
                <nav class="mdl-navigation">
                    <a class="mdl-navigation__link" href="cono.html"><b><font color="white">&laquo;CONOCENOS&raquo;</font></b></a>
                    <a class="mdl-navigation__link" href="prop.html"><b><font color="white">&laquo;PROPUESTAS&raquo; </font></b></a>
                    <a class="mdl-navigation__link" href="contacto.jsp"><b><font color="white">&laquo;CONTACTANOS&raquo; </font></b></a>
                    <a class="mdl-navigation__link" href="htm.html"><b><font color="white">&laquo;DO IT YOURSELF&raquo; </font></b></a>
                    <a class="mdl-navigation__link" href="descargas.html"><b><font color="white">&laquo;DOWNLOADS&raquo; </font></b></a>
                    <a class="mdl-navigation__link" href="../../login" target="_blank"><b><font color="white">&laquo;SYNTH&#33;&raquo; </font></b></a>
                </nav>
            </div>
        </div>
        <main class="mdl-layout__content">
            <br/><br /><br/>
            <%if(!not.equals("")){%>
                <script>
                    swal({title: "Notificación!!",text: "<%=not%>",type:"info",showConfirmButton: true,closeOnConfir:true, html: false,allowEscapeKey:false},function(){window.location="contacto.jsp"});
                </script>
            <%}%>
            <br/><br/>
            <div id="txt" style=" height: 100%">
                <br />
                <txt style="font-size: 24px;"><center>
                    &#161;&#161;MARSOFT ESCUCHA A SUS CLIENTES&#33;&#33;
                    <br/><font style="font-size: 16px;">"S&iacute;guenos en nuestras redes sociales para m&aacute;s de la marsopa"</font>
                </center></txt>
                <br/>
                <p/><p/><p/>
                <table>
                    <td width="30%">
                        <br/><a href="https://sketchfab.com/bear59814" target="_blanck"><img class="icono" id="sk" src="../../imgs/sketch.png"/></a><font size="1.5">SKETCHFAB</font>
                        <br/><a href="https://www.facebook.com/marsoftTeam/?fref=ts" target="_blanck"><img class="icono" id="fa" src="../imgs/face.png"/></a>FACEBOOK
                        <br/><a href="https://twitter.com/marsoftTeam" target="_blanck"><img class="icono" id="tw" src="../imgs/tw.png"/></a>TWITTER
                        <br/><a href="https://www.youtube.com/channel/UCi-6y0AaXNvcHBxtj15UtPA" target="_blanck"><img class="icono" id="yt" src="../imgs/ytb.png"/></a>YOUTUBE
                    </td>
                    <td width="70%">
                        <form action="" method="POST" id="formu" name="formu" onsubmit="return false;confirma();">
                            NOMBRE:
                            <input type="text" id="contenidos" name="nombre" placeholder="Nombre..." autocomplete="off"/>
                            <br/><br/>
                            ENV&Iacute;ANOS TU COMENTARIO:
                            <textarea id="contenido" rows="4" maxlength="300" name="contenido" placeholder="Escribe tu comentario..."></textarea>
                            <br/><button onclick="confirma();"><span>ENVIAR</span></button>
                            <input type="hidden" id="par" name="par" value="gatito" />
                        </form>
                    </td>
                </table>
                <p/><p/>
            </div>
        </main>
        <footer id="foot" style="position:absolute;">
            <br/>
                &#8221;MARSOFT&copy; Es una marca registrada y cumple con los acuerdos en la Constitucion Politica de los Estados Unidos Mexicanos&#8221;
        </footer>
    </body>
</html>