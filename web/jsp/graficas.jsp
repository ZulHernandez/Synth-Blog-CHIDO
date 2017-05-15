

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Información</title>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script type="text/javascript">
          
          google.charts.load("current", {packages:["corechart"]});
         // google.charts.setOnLoadCallback(drawChart);
          var  chart = "";
          var data="";
          var options="";
          function drawChart(datos) {
            chart=new google.visualization.PieChart(document.getElementById('graficaGeneros'));
            data=google.visualization.arrayToDataTable(datos);
            options = {
              is3D: true,
              title:'Géneros',
              backgroundColor:'transparent',
            };
            chart.draw(data, options);
          }
          
          function redimenzionar()
          {
              chart=new google.visualization.PieChart(document.getElementById('graficaGeneros'));
              chart.draw(data,options);
          }
          function pedirDatos(){
              $("body").append("<div class='loader'> </div>");
              $("div[class='loader']").show("slow");
              
              $.post(
                      '../estadisticas',
                      {consulta:"1"},
                     function(respuesta){
                       pedirDatosTop(respuesta);
                    }
                    
                );
                
          }
          
          function pedirDatosTop(respuestaAnterior)
          {
                $.post(
                        '../estadisticas',
                        {consulta:"2"},
                        function(respuesta){
                                $("div[class='loader']").hide("slow",function(){
                                    mostrarRespuestas(respuestaAnterior,respuesta);
                             })
                        }
                );  
          }
          function mostrarRespuestas(respuestaGrafica,respuestaTop)
          {
                var arrayDatos=[];
                var xArr;
                var respuestaGraf=$.parseJSON(respuestaGrafica);
                var html='';
                respuestaTop=$.parseJSON(respuestaTop);
                arrayDatos.push(['Generos','Publicaciones']);
                    for(var i=0;i<respuestaGraf.Size;i++)
                    {
                       xArr=[respuestaGraf.Gen[i],parseInt(respuestaGraf.Cant[i])];
                       arrayDatos.push(xArr);

                    };
                    
                    for(var i=0;i<respuestaTop.contador;i++){
                        html="<div class='div-articulo-top' data-regis='"+respuestaTop.Art[i]+"'>";
                        html+="<span class='spTop sp-articuloTop-titulo'>Titulo: ";
                        html+=respuestaTop.Tit[i];
                        html+="</span>";
                        html+="<span class='spTop sp-articuloTop-fecha'>Publicado: "
                        html+=respuestaTop.Fec[i];
                        html+="</span>";
                        html+="<span class='spTop sp-articuloTop-consultas'>Número de Consultas: ";
                        html+=respuestaTop.Con[i]; 
                        html+="</span>";
                        html+="<button class='btn-articuloTop' onclick='leer(this);' >Leer</button>";
                        html+="</div>";
                        $("#masConsultados").append(html);
                    };
                $("div[class='loader']").remove();
                $("#container").show("slow",function(){drawChart(arrayDatos);}); 
          }
          
          function leer(botonArticulo){
              window.location="despliegaTeoria.jsp?idT="+botonArticulo.parentNode.dataset.regis;
          }

        </script>
        <style>
            @font-face {
    font-family: "Roboto";
    src: url("/Synth_BLOG/fuentes/Roboto-Regular.ttf") format("truetype");
}
            body{
                background:url("../img/fondomusica1.jpg ");
                font-family:"Roboto";
                width:100%;
                height:100%;
                overflow: hidden;
            }
      .loader
      {
            vertical-align: central;
            
            display:none;
            position: absolute;
            left:45%;
            top:40%;
            border: 16px solid #f3f3f3; 
            border-top: 16px solid #3498db; 
            border-radius: 50%;
            width: 120px;
            height:120px;
            animation: spin 2s linear infinite;
      }
      @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
                }
      .fondo
      {
          position: absolute;
          width:100%;
          height: 0%;
          z-index:2;
          opacity:.5 ;
          background-color: black;
         
      }
            #container
            {
                width:100%;
                height:100%;
                padding-top: 8%;
                display:none;
                
            }
            #graficaGeneros{
                position:absolute;
                left:5%;
                 background-color: rgba(214,214,214,0.6);
                width:40%;
                height:60%;
                top:21%;
            }
            #masConsultados{
                position:absolute;
                left:55%;
               background-color: rgba(214,214,214,0.6);
                width:40%;
                height:60%;
                top:21%;
                overflow-y: auto;
            }
            #infoGenero
            {
                position:absolute;
                left:5%;
                background-color: red;
                height:40%;
                width:90%;
                top:62%;
            }
            .titulo
            {
                position: absolute;
                width:40%;
                top:15%;
                height:5%;
                color:white;
                background-color: rgba(214,214,214,0.6);
                text-align: center;
            }
            #tituloGrafica
            {
                left:5%;
            }
            #tituloConsultados
            {
                left:55%;
            }
            .div-articulo-top
            {
                width:90%;
                position: relative;
                left:5%;
                margin-top: 2%;
                margin-bottom: 2%;
                height:40%;
                background-color: rgba(214,214,214,0.6);
                border-style:solid;
                border-color:transparent;
                border-bottom-color: RGB(21,133,183);
            }
            .spTop{
                position: absolute;
                left:5%;
                color:black;
                height:10%;
            }
            .sp-articuloTop-titulo{
                top:20%;
            }
            .sp-articuloTop-fecha{
                top:50%;
            }
            .sp-articuloTop-consultas{
                top:80%;
            }
            .btn-articuloTop{
                position: absolute;
                left:75%;
                top:30%;
                height:40%;
                width:20%;
               background-color: RGB(21,133,183);
               color: white;
               border:none;
               cursor:pointer;
            }
            .btn-articuloTop:hover{
                color:RGB(21,133,183);
                background-color: white;
            }
        </style>
    </head>
    <body onresize="redimenzionar();" onload="pedirDatos();">
        <div id="container">
            <span id="tituloGrafica" class="titulo" >Lo más posteado</span>
            <div id="graficaGeneros"   >
                
            </div>
             <span id="tituloConsultados" class="titulo" >Artículos más consultados</span>
            <div id="masConsultados">

            </div>
           
            
            
        </div>
    </body>
</html>
