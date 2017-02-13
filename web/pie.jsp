<%-- 
    Document   : pie
    Created on : 24/11/2016, 09:02:44 PM
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
        <title>Pie de página</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            @font-face 
            {
                font-family: "Roboto";
                src: url("/Synth_BLOG/fuentes/Roboto-Regular.ttf") format("truetype");

            }
            body
            {
                padding: 0px;
                background-color:rgba(0,0,0,1);
                margin: 0 ;
                padding: 0 ;
            }
            #lonk
            {
                height: 35px;
                padding-right: 5px;
            }
            #enlace
            {
                background-color: white;
                float: right;
            }
            #otro{
                z-index: 1;
                padding-left: 10%;
                float: right;
            }
            #titulo
            {
                z-index: 2;
                float: left;
                color:white;
                padding-left: 0px;
                font-weight: bolder;
                font-size: 35px;
            }
            tx
            {
                font-size: 12px;
            }
            #lo
            {
                z-index: 3;
                height: 40px;
            }
            tt
            {
                padding-left: 10px;
            }
            a
            {
                color: transparent;
            }
        </style>
    </head>
    <body>
        <div id="titulo" align="middle">
            <tt>MARSOFT<tx>&#174;</tx></tt>
            <img src="img/MARSO.jpg" id="lo" align="left"/>&nbsp;
        </div>
        <div id="otro" >
            <div id="enlace">
                <a href="https://www.facebook.com/marsoftTeam/?fref=ts" target="_blank">
                    <img src="img/facebook.png" id="lonk" />&nbsp;
                </a>
                <a href="https://twitter.com/marsoftTeam" target="_blank">
                    <img src="img/tw.png"  id="lonk" />&nbsp;
                </a>
                <a href="https://www.youtube.com/channel/UCi-6y0AaXNvcHBxtj15UtPA" target="_blank">
                    <img src="img/youtube.png" id="lonk"/>&nbsp;
                </a>
                <a href="https://sketchfab.com/bear59814" target="_blank">
                    <img src="img/sketch.png" id="lonk" />&nbsp;
                </a>
            </div>
        </div>
    </body>
</html>

