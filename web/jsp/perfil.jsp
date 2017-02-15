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
                                     document.getElementById(key).innerHTML=value;
                                    else
                                        if( key=='correo' || key=='descripcion')
                                            document.getElementById(key).innerHTML=value;
                                    else{
                                        document.getElementById(key).value=value;
                                    }
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
                 background:url("../img/fondomusica1.jpg ");
                 overflow-x: hidden;
                 overflow-y: hidden;
            }
       
            .scontainer{
                height:100%;
                width: 30%;
                background-color: transparent;
		color: white;
                position: absolute;
            }
            .container
            {
                width:90%;
                height:70%;
                margin-top: 5%;
                background-color: rgba(214,214,214,0.3);
                box-shadow: 0px 0px 20px #000000;
                    border-radius:3px;
                color: black;
                position: relative;
                left:5%;
                
            }
            #imgUsr
            {
                width:10%;
                height:27%;
                position: absolute;
                left:5%;
                top:2%;
            }
            #spName,#spDate
            {
                font-width:bold;
                position:absolute;
                left:17%;
                margin-top: 1%;
                
            }
            #spTit
            {
                position: absolute;
                left:30%;
                top:0%;
                margin-top: 1%;
                font-weight: bold;
            }
            #spCateg
            {
                position: absolute;
                left:30%;
                margin-top: 1%;
                top:6%;
                font-size: 5;
                font-style: italic;
            }
            #contPost
            {
                display:block;
                position:absolute;
                left:30%;
                top:20%;
                background-color: transparent;
                width:60%;
                height:60%;
                overflow-y:auto;
            }
            #imgPost
            {
                position:relative;
                left:5%;
                width:13%;
                margin-top: 5%;
                height:25%;
                background-color: red;
            }
            #cabImg
            {
               
                display:block;
                width:13%;
                position:relative;
                left:5%;
            }
            #audio
            {
                position:relative;
                left:5%;
            }
            #cabAudio
            {
                display:block;
                width:13%;
                position:relative;
                left:5%;
                font-style: italic;
                
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
                width:70%;
                height:100%;
                position: absolute;
                background-color: transparent;
                overflow-y:auto;
                left:30%;
                margin-bottom: 10%;
            }
            #imgPerfil{
                position:relative;
                margin-top: 10%;
                left:32.5%;
                width: 35%;
                height:30%;
            }
            #descripcion{
                position:relative;
                top:10%;
                left:5%;
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
                left:5%;
            }
            #datosPerfil
            {
                position:relative;
                width:80%;
                height:80%;
                margin-top: 10%;
                left:10%;
                    background-color: rgba(214,214,214,0.3);
                    box-shadow: 0px 0px 20px #000000;
                    border-radius:3px;
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