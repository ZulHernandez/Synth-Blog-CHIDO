<%-- 
    Document   : teoria.jsp
    Created on : 24-nov-2016, 19:33:53
    Author     : Bear
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession ss = request.getSession();
    int db = 0;
    int tipous = 0;
    try{
        db = ss.getAttribute("bd") == null ? 0 : Integer.parseInt(ss.getAttribute("bd").toString());
        System.out.println("db = " + db);
        tipous = ss.getAttribute("tipous") == null ? 0 : Integer.parseInt(ss.getAttribute("tipous").toString());
    }catch(Exception e){
        System.out.println(e.getMessage());
        response.sendRedirect("/Synth_BLOG/login");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Teoria</title>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <link href="../styles/teoria.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript">
            function getTeoria(){
                $("#list").ready(
                        $.ajax({
                            url:"../teoria",
                            type:"POST",
                            data:{tipo:0,bd:<%=db%>},
                            success:
                            function(respuesta){
                                if(!respuesta.startsWith("ERROR")){
                                    respuesta=$.parseJSON(respuesta);
                                    var src = "";
                                    var registro = [""];
                                    var token = 0;
                                    src += "<table cellspacing=\"20\">";
                                    $.each(respuesta,function(key,value){
                                        registro = value.split("/");
                                        src += "<tr>";
                                        src += "<td><input type=\"hidden\" value=\""+registro[0]+"\"/></td>";
                                        src += "<td>"+registro[3]+"</td>";
                                        src += "<td>"+registro[4]+"</td>";
                                        src += "<td>No. de Consultas: "+registro[2]+"</td>";
                                        src += "<td>"+registro[1]+"</td>";
                                        src += "<td><a href=\"despliegaTeoria.jsp?idT="+registro[0]+"\">IR ALLA</td>";
                                        src += "</tr>";
                                        token = 1;
                                    });
                                    src += "</table>"
                                    if(token == 0){
                                        document.getElementById("list").innerHTML = "No se encontraron registros";
                                    }else{
                                        document.getElementById("list").innerHTML = src;
                                    }
                                }else{
                                    document.getElementById("list").innerHTML = respuesta;
                                }                             
                            }
                        })
                    );
            }
        </script>
    </head>
    <body onload="getTeoria();">
        <div class="container">
            <center><h1>Teoria musical aplicada</h1></center><br>
            <p>El siguiente apartado contiene informacion relacionada con los temas de la teoria musical aplicada. 
               Todos los musicos de la comunidad Synth tienen el deber de practicar lo aprendido al menos una vez 
               al dia</p><br>
            <div class="container" id="list">
                
            </div>
            <%if(tipous == 1){%>
            <br>
            <center><a href="publicar.jsp"><button id="boto">SUBIR TEORIA</button></a></center>
            <br>
            <%}%>
        </div>
    </body>
</html>
