<%-- 
    Document   : blog
    Created on : 21/11/2016, 04:57:07 PM
    Author     : Saul
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"  %>
<%
    HttpSession sesion=request.getSession();
    String usrId=sesion.getAttribute("id")==null?"":sesion.getAttribute("id").toString();
    String usr=sesion.getAttribute("usuario")==null?"":sesion.getAttribute("id").toString();
    String bd=sesion.getAttribute("bd")==null?"":sesion.getAttribute("bd").toString();
    String src="";
    if(usrId.equals(""))
        response.sendRedirect("login");
    else{
        src="<script>swal('¡Bienvenido!');</script>";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Synth!WebCommunity</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="imgs/sico.ico"/>
        
        <script src="scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script type="text/javascript">
            
 
        </script>
        <style>
            @font-face {
                font-family: "Roboto";
                src: url("/Synth_BLOG/fuentes/Roboto-Regular.ttf") format("truetype");

            }
            
        </style>
    </head>
    
    <frameset id="pag"  rows=130px,*%,40px>
        
        <frame id="head" name="head" src="head.jsp" scrolling ="no" frameborder="0" noresize />
        <frame id="body" name="body" src="jsp/pUsuario.jsp" scrolling="yes" frameborder="0" noresize />
        <frame id="foot" name="foot" src="pie.jsp" scrolling="no" frameborder="0" noresize />
    </frameset>
    
</html>
