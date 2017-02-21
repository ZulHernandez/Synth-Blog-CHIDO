<%-- 
    Document   : busqueda
    Created on : 12/02/2017, 11:37:57 AM
    Author     : Saul
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  HttpSession sesion=request.getSession();
    String scr="";
    String bsq="";
    String s=sesion.getAttribute("usuario").toString()==null?"":sesion.getAttribute("usuario").toString();
    if(s.equals(""))
        response.sendRedirect("../login");  
    else
       bsq= request.getParameter("queryBsq");
    
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
		<style>
		body
		{
                        background:url("../img/fondomusica1.jpg ");
			margin:0px;
		}
		#resultadosBsq
		{
			width:80%;
			height: 100%;
			
                        background: transparent;
			position: absolute;
			left: 20%;
                        display:none;
                        margin-top: 0px;
                        overflow-y:auto;
                        overflow-x:hidden;
                        
		}
                div[data-tipoFila]
                {
                    position: relative;
                    left:3%;
                    width:90%;
                    height:30%;
                    padding: 2%;
                    margin-top: 1%;
                    background-color: rgba(214,214,214,0.3);
                    box-shadow: 0px 0px 20px #000000;
                    border-radius:3px;
                }
               div[data-tipoFila]:hover
               {
                   /* background-color: rgba(214,214,214,1);*/
                     background-color:#ffffff;
               }
               #datosPerfil
               {
                  
                   width:70%;
                   position: relative;
                   left:15%;
               }
               #imgPerfil
               {
                   border-color: black;
                   border-style: solid;
                   left: 5%;
                   position: absolute;
                   width:10%;
                   height: 71%;  
               }
		#filtrosBsq
		{
			width:20%;
			height: 100%;
			position: absolute;
			
                        background: transparent;
                        display:none;
                        
		}
		#btnsFiltros
		{
			padding: 5%;
                        background-color: rgba(214,214,214,0.3);
			width: 80%;
			height: 80%;
			left:5%;
			position:relative;
			top:10%;
                        box-shadow: 0px 0px 20px #000000;
                        border-radius:3px;

		}
		.buttonFiltro
		{
			width:80%;
			height: 5.1%;
			border-radius: 3px;
                        background-color:#ffffff;
			color:black;
			margin-top: 25%;
			border: none;
                        box-shadow: 0px 0px 20px #000000;
                        border-radius:3px;
                 

		}
		.spFiltro
		{
			color:black;
			font-weight: bold;
			 background-color:#ffffff;
			height: 4.8%;
			width:19%;
			position: absolute;
			left:76.4%;
			margin-top: 22.2%;
			text-align: center;
                        box-shadow: 0px 0px 20px #000000;
                        border-radius:3px;
                      

		}
                .loader
                {
                    display:block;
                    border: 16px solid #f3f3f3; 
                    border-top: 16px solid #3498db; 
                    border-radius: 50%;
                    width: 120px;
                    height:120px;
                    animation: spin 2s linear infinite;
                   


                }
                 .fondo
                {
                    display:none;
                    z-index: 2;
                    background-color: RGB(21,133,183);
                    color: white;
                    box-shadow: 0px 0px 20px #000000;
                    border-radius:3px;
                    padding: 1%;
                    width:95%;
                    height:81%;
                    position: absolute;
                    left:0%;
                    top:10%;
                    text-align: center;
                    font-size: xx-large;
                    font-weight: bold;
                    
                }
                #containerCarga
                {  
                    padding: 10%;
                }
                #spName
                {
                   
                    position: relative;
                    left:20%;
                    font-size: 110%;
                    font-weight: bold;
                    color:black;
                }
                #spDes,#spType
                {
                    position: relative;
                    left: 20%;
                    font-style: italic;
                    
                }
                #seguir,#urlArt
                {
                    position: relative;
                    left:20%;
                    color:black;
                    width:15%;
                    background-color: transparent;
                    height: 10%;
                }
                #seguir:hover
                {
                    background-color: black;
                    color:white;
                }
                @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
                }
               
		</style>
                <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
                <script type="text/javascript">
                    function verPerfil(btnCuenta)
                    {
                        var regis=btnCuenta.parentNode.parentNode.dataset.regis;
                        window.location="perfil.jsp?usr="+regis;
                    }
                    function pegar404()
                    {
                        $("#resultadosBsq").append("<div id='msj' class='fondo'><span style='position:relative'>Lo sentimos, no se encontraron resultados :C</span> </div>");
                        $.each($("#msj").find("span"),function(key,value){this.style.top="40%";});
                        $("#msj").show("slow");
                    }
                    function pedirResultado()
                    {
                       
                       var textoBsq='<%=bsq%>';
                       var totalCiclos=0;
                       var tipoFila=0;
                       var htmlResult="";
                       var btnConsulta="";
                       $.post(
                            "../agregaDatos",
                            {tipoPeticion:5,paramBsq:textoBsq},
                            function(respuesta)
                            {
                               
                               respuesta=$.parseJSON(respuesta);
                               totalCiclos=respuesta.total;
                               if(totalCiclos==null || totalCiclos=='')
                               {
                                   
                                   $("#containerCarga").css("display","none");
                                   $("#filtrosBsq").css("display","block");
                                   $("#resultadosBsq").css("display","block");
                                   pegar404();
                               }
                               else
                               {
                                   $("#rsUsrs").html(respuesta.Usuarios);
                                   $("#rsArtcs").html(respuesta.Articulos);
                                   $("#rsTodos").html(totalCiclos);
                                   
                                   for(var i=0;i<totalCiclos;i++)
                                   {
                                       tipoFila=respuesta.tipos[i]=='Usuario'?1:2;
                                       if(tipoFila==1)
                                           btnConsulta="<button id='ver' onclick='verPerfil(this)'>Ver perfil</button>";
                                       else       
                                           btnConsulta="<a id='urlArt' href='despliegaTeoria.jsp?idT="+respuesta.registros[i]+"' >Leer</a>";
                                   
                                       htmlResult+="<div data-tipoFila='"+tipoFila+"' data-regis='"+respuesta.registros[i]+"'>";
                                       htmlResult+=
                                                    "<img src='/Synth_BLOG/imgs/GDT.JPG' id='imgPerfil'>"
                                                    +"<div id='datosPerfil'>"
                                                    +"<span id='spName' >"
                                                    +respuesta.nombres[i]
                                                    +"</span><br /><br />"
                                                    +"<span id='spType'>"+respuesta.tipos[i]
                                                    +"</span><br /><br /></td>"
                                                    +"<span id='spDes'>"+respuesta.descripciones[i]
                                                    +"</span><br /><br />"+btnConsulta
                                                    +"</div>";
                                       htmlResult+="</div>";     
                                   };
                                   $("#containerCarga").css("display","none");
                                   $("#filtrosBsq").css("display","block");
                                   
                                   $("#resultadosBsq").html(htmlResult);
                                   $("#resultadosBsq").css("display","block");
                              }
                            }
                        );
                    }
                    
                    function ordenarResultados(orden)
                    {
                        switch(orden)
                        {   
                            case 1:
                                 $("#msj").remove();
                                if($("#rsUsrs").html()=='0' || $("#rsUsrs").html()=='')
                                {
                                    pegar404();
                                    $("div[data-tipoFila]").css("display","none");
                                }
                                else
                                {
                                    
                                    $("div[data-tipoFila='1']").css("display","block");
                                    $("div[data-tipoFila='2']").css("display","none");
                                 }
                                break;
                            case 2:
                                 $("#msj").remove();
                                if($("#rsArtcs").html()=='0'||$("#rsArtcs").html()=='')
                                {
                                    $("div[data-tipoFila]").css("display","none");
                                    pegar404();
                                }
                                else
                                {
                                  
                                    $("div[data-tipoFila='2']").css("display","block");
                                    $("div[data-tipoFila='1']").css("display","none");
                                }
                                break;
                                
                            case 3:
                                 $("#msj").remove();
                                if($("#rsTodos").html()==''||$("#rsTodos").html()=='0')
                                    pegar404();
                                else
                                {
                                   
                                    $("div[data-tipoFila]").css("display","block");
                                }
                                break;
                        }
                    }
		</script>
	</head>
	<body onload="pedirResultado()">
        <center id="containerCarga">
            <div id="carga" class="loader" >
            </div>
        </center>
        <div id="filtrosBsq">
                    <div id="btnsFiltros">
                            <button id="todos" name="todos" class="buttonFiltro" onclick="ordenarResultados(3);" >Todos los resultados</button><span class="spFiltro" id="rsTodos"></span>
                            <br />
                            <br />
                            <button id="usrs" name="usrs" class="buttonFiltro"  onclick="ordenarResultados(1);" >Usuarios</button><span id="rsUsrs" class="spFiltro"></span>
                            <br />
                            <br />
                            <button id="artcs" name="artcs" class="buttonFiltro"  onclick="ordenarResultados(2);" >Artículos</button><span id="rsArtcs" class="spFiltro" ></span>
                            <br />
                            <br />

                    </div>
            </div>
            <div id="resultadosBsq">
               
            </div>
	
	</body>
</html>
