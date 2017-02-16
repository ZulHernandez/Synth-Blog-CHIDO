<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion=request.getSession();
    String s=sesion.getAttribute("usuario").toString()==null?"":sesion.getAttribute("usuario").toString();
	int bd = sesion.getAttribute("bd") == null ? 0 : Integer.parseInt(sesion.getAttribute("bd").toString());
	int id = sesion.getAttribute("id") == null?0:Integer.parseInt(sesion.getAttribute("id").toString());
    if(s.equals(""))
        response.sendRedirect("../login");
    ldn.cInicio inicio = new ldn.cInicio(bd);
	String src = inicio.traePostInicio(id);
 %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Perfil de Usuario</title>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script src="../scripts/sweetalert.min.js" type="text/javascript"></script>
        <link href="../styles/sweetalert.css" rel="stylesheet" type="text/css"/>
       <link href="../styles/teoria.css" rel="stylesheet" type="text/css"/>
       <script type="text/javascript">
           function seguir(idss,boton){
               if(boton.innerHTML == "Seguir"){
                   boton.innerHTML = "Seguido";
                   boton.className = "seguido";
               }else{
                   boton.innerHTML = "Seguir";
                   boton.className = "seguir";
               }
               jQuery.ajax({
                    url:"../seguir",
                    type:"POST",
                    data: {id:<%=id%>,ids:idss,bd:<%=bd%>},
                    success: function(respuesta){
                        var resp = JSON.parse(respuesta);
                        var typ,tit;
                        switch(resp.status){
                            case "ERROR":
                                typ = "error";
                                tit = "Ops...";
                                boton.innerHTML = "Seguir";
                                boton.className = "seguir";
                                break;
                            case "WARNING":
                                typ = "error";
                                tit = "Error";
                                boton.innerHTML = "Seguir";
                                boton.className = "seguir";
                                break;
                        }
                        alert(resp.status);
                        if(respuesta.status != "OK")swal({
                            title: tit,
                            text: resp.msg,
                            type: typ,
                            showCancelButton: false,
                            showConfirmButton: true,
                            confirmButtonColor: "#DD6B55",
                            confirmButtonText: "ENTENDIDO",
                            closeOnConfirm: true,
                            closeOnCancel: true
                        });
                    }
                });
           }
       </script>
    <style>
        body
		{
                        background:url("../img/fondomusica1.jpg ");
			margin:0px;
		}
        input[type="radio"] {
          display: none;
        }
        label {
          color: grey;
        }
        .cal {
          direction: rtl;
          unicode-bidi: bidi-override;
        }
        label:hover,
        label:hover ~ label {
          color: black;
        }
        input[type="radio"]:checked ~ label {
          color: black;
        }
    </style>
    </head>
    <body>
        <%if(!inicio.getError().isEmpty()){%>
			<textarea rows="50" cols="100" readonly><%=inicio.getError().replace("\n","<br>")%></textarea>
		<%}else if(!src.isEmpty()){%>
			<%=src%>
		<%}else{%>
			<div class="container"><center><p>ESTO PARECE UNA TIERRA ARIDA</p><p>Para mostrar post que ver en tu pagina de inicio, debes comenzar a seguir diferentes cuentas o agregar intereses a tu cuenta.</p></center></div>
		<%}%>
    </body>
</html>
