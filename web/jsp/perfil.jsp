<%-- 
    Document   : perfil
    Created on : 29/11/2016, 12:59:51 PM
    Author     : Alumno
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion=request.getSession();
	int bd = 0;
	int usrId = 0;
	String usr = "";
        String usrVisita="n";
        boolean visitante=false;
	try{
            usrId=sesion.getAttribute("id") == null?0:Integer.parseInt(sesion.getAttribute("id").toString());
            usrVisita=request.getParameter("usr")== null || usrId==Integer.parseInt(request.getParameter("usr")) ?"no":request.getParameter("usr");
            if(!usrVisita.equals("no"))
            {        
                visitante=true;
            }
		usr=sesion.getAttribute("usuario") == null?"":sesion.getAttribute("usuario").toString();
		bd = sesion.getAttribute("bd") == null ? 0 : Integer.parseInt(sesion.getAttribute("bd").toString());
		if(usrId == 0) throw new Exception("c:");
	}catch(Exception e){
		response.sendRedirect("../login");
	}
	ldn.cPost post = new ldn.cPost(bd);
        String[] src = visitante==true? post.obtenPost(Integer.parseInt(usrVisita)):post.obtenPost(usrId);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Perfil</title>
        <link href="../styles/teoria.css" rel="stylesheet" type="text/css"/>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script>
            
            function traePerfil(){
                $("#container").ready(
                        
                        $.ajax({
                        url:"../agregaDatos",
                        type:"POST",
                        data:{tipoPeticion:"4",user:<%=usrId%>,visita:<%=visitante%>,visitante:'<%=usrVisita%>'},
                        success:
                        function(respuesta){ 
                            //alert(respuesta);
                            respuesta=$.parseJSON(respuesta);
                            //alert(respuesta);
                            $.each(respuesta,function(key,value){
                                
                                if(key=='imgPerfil')
                                    document.getElementById(key).src=value;
                                else
                                    if(key=='nombre'|| key=='correo' || key=='descripcion')
                                     document.getElementById(key).innerHTML=value;
                                    else
                                       if(key=='seguir'){
                                           if(value=='true')
                                               document.getElementById("seguir").innerHTML="Siguiendo";
                                       }
                            })                                   
                        }
                    })
                );
            }
            function seguirPerfil()
            {
                $.post(
                  "../agregaDatos",
                  {tipoPeticion:6,user:<%=usrId%>,visitante:<%=usrVisita%>,visita:<%=visitante%>},
                  function(respuesta)
                  {
                      alert(respuesta);
                        $("#seguir").html(respuesta);
                  }
                );
            }
        </script>
        <link href="../styles/pub.css" rel="stylesheet" type="text/css"/>
        <style type="text/css">
            html{
                
                height: 100%;
            }
           body{
               margin: 0px;
                height:100%;
                width:100%;
                 background:url("../img/fondomusica1.jpg ");
                 overflow-x: hidden;
                 overflow-y: hidden;
            }
       
         
        </style>
    </head>
    <body onload="traePerfil();">
        <div class="scontainer">
            <div id='datosPerfil'>
                    <img id="imgPerfil" name="imgPerfil" src=""  />
                    <br />
                    <br />
                    <div id="nombre"  ><%=usr%></div><br/>
                    <div id="correo" ></div><br />
                    <div id="descripcion" ></div><br />
                    <%
                        if(visitante){
                    %>
                    <button id="seguir" onclick="seguirPerfil();">Seguir</button>
                    <%}%>
            </div>
                    <!--<input id="seguir" name="seguir" type="button" value="Seguir"/><br />-->
	</div>
        <div id='muro'>
        <%if(!post.getError().isEmpty()){%>
            <%=post.getError()%>
        <%}else{%>
	<%for(String part:src){%>
            <%=part%>
	<%}}%>
        </div>
    </body>
</html>