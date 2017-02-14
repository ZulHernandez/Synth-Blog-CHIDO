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
	try{
		usrId=sesion.getAttribute("id") == null?0:Integer.parseInt(sesion.getAttribute("id").toString());
		usr=sesion.getAttribute("usuario") == null?"":sesion.getAttribute("usuario").toString();
		bd = sesion.getAttribute("bd") == null ? 0 : Integer.parseInt(sesion.getAttribute("bd").toString());
		if(usrId == 0) throw new Exception("c:");
	}catch(Exception e){
		response.sendRedirect("../login");
	}
	ldn.cPost post = new ldn.cPost(bd);
	String[] src = post.obtenPost(usrId);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Perfil</title>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script>
            
            function traePerfil(){
                $("#container").ready(
                        $.ajax({
                        url:"../agregaDatos",
                        type:"POST",
                        data:{tipoPeticion:"4",user:<%=usrId%>},
                        success:
                        function(respuesta){ 
                            //alert(respuesta);
                            respuesta=$.parseJSON(respuesta);
                            //alert(respuesta);
                            $.each(respuesta,function(key,value){
                                
                                if(key=='imgPerfil')
                                    document.getElementById(key).src=value;
                                else
                                    if(key=='nombre')
                                     document.getElementById(key).innerHTML="Bienvenido a tu perfil "+value;
                                    else
                                        if( key=='correo')
                                            document.getElementById(key).innerHTML=value;
                                    else
                                        document.getElementById(key).value=value;
                            })                                   
                        }
                    })
                );
            }
        </script>
        <style type="text/css">
            html{
                
                height: 100%;
            }
           body{
               margin: 0px;
                height:100%;
                width:100%;
            }
            #scontainer{
                height: 100%;
                width: 100%;
				background-color: RGB(167,75,89);
				color: white;
            }
            #part1{
                padding-top: 0px;
                float:left;
                background-color:purple;
                height: 100%;
                width: 20%;
                left:0%;
                
            }
            #cuerpo{
               float:left;
               position:relative;
               
               height:100%;
               width:80%;
            }
            #cabecera{
                
                height: 30%;
            }
            #muro{
                
                height:70%;
            }
            #imgPerfil{
                position:relative;
                top:10%;
                left:25%;
                width: 50%;
                height:25%;
            }
            #descripcion{
                position:relative;
                
                top:10%;
                left:25%;
                width:50%;
                height:10%;
            }
            #nombre{
                position: relative;
                top:10%;
                left:5%;
            }
            #correo{
                position:relative;
                top:10%;
                left:75%;
            }
        </style>
    </head>
    <body onload="traePerfil();">
        <div class="scontainer">
            <p>
		<img src="aquivalaimagen" width="150" height="150" align=left id="imgPerfil"/><div><%=usr%><br>descripcion de la cuenta<br>SEGUIR</div>
            </p>
	</div>
        <%if(!post.getError().isEmpty()){%>
            <%=post.getError()%>
        <%}else{%>
	<%for(String part:src){%>
            <%=part%>
	<%}}%>
    </body>
</html>