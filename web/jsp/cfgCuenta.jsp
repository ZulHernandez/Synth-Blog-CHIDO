

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
     HttpSession sesion=request.getSession();
    String usrId=sesion.getAttribute("id").toString()==null?"":sesion.getAttribute("id").toString();
    String usr=sesion.getAttribute("usuario").toString()==null?"":sesion.getAttribute("id").toString();
    if(usrId.equals(""))
        response.sendRedirect("/login");
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Teoría</title>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script src="../scripts/validaRegistro.js" type="text/javascript"></script>
        <script src="../scripts/sweetalert.min.js" type="text/javascript"></script>
        <link href="../styles/sweetalert.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript">
                    
            function cambiaImg(input){
                
                var reader=new FileReader();
                var valido=extensionValida(input.files[0].name);
                    reader.onload=function(e){
                        if(valido)
                        $("#preview").attr("src",e.target.result);                 
                    
                }
                reader.readAsDataURL(input.files[0]);
                if(!valido){
                        alert("Extension invalida");
                        $("#dir").attr("value","");
                        input.value="";
                        $("#nuevaImg").focus();
                    }else{
                    $("#dir").attr("value",input.files[0].name);
                }
            }
            function traeIntereses(){
                $("#intereses").ready(
                        $.post(
                            "../agregaDatos",
                        {tipoPeticion:"0",user:'<%=usrId%>'},
                        function(respuesta){
                            
                            respuesta=$.parseJSON(respuesta);
                            var total=respuesta.Total;
                            var intPerfil=respuesta.interesesPerfil;
                            var encontrado='';
                            var vecesEncontrado=0;
                            for(var i=0;i<total;i++)
                            {
                                encontrado=$.inArray(respuesta.Intereses[i],intPerfil);
                                
                                if(encontrado!=-1)
                                {
                                 $("#interesesCuenta").append("<button id='btn-interes' onclick='agregarInteres(this);' data-tipo='perfil' data-regis='"+respuesta.Intereses[i]+"'>"+respuesta.Generos[i]+"</button>");
                                 vecesEncontrado++;
                                }
                                else
                                  $("#todosIntereses").append("<button id='btn-interes' onclick='agregarInteres(this);' data-tipo='general' data-regis='"+respuesta.Intereses[i]+"'>"+respuesta.Generos[i]+"</button>");
                            };
                            if(vecesEncontrado>0)
                                $("#interesesCuenta").html("<span>Elige algún interes</span>");
                            traePerfil();
                        }
                    )
                );
            }
            function agregarInteres(btnInteres)
            {
                var btn=btnInteres.cloneNode(true);
                var cont='';
                var tipo=btn.dataset.tipo;
                var cantIntereses=document.getElementById("interesesCuenta").getElementsByTagName("button").length;
                var ilegalInteres='';
                if($("#interesesCuenta").find("span").length>0)
                {
                   $.each($("#interesesCuenta").find("span"),function(key,value){
                       this.remove()});
                }   
                if(cantIntereses>2 && tipo=='general')
                {
                    alert("No puedes elegir más de 3 intereses");
                }
                else
                    if(cantIntereses==1 && tipo=='perfil')
                        alert("Debes elegir al menos 1 interes");
                else
                {
                    btnInteres.remove();
                    if(tipo=='general')
                    {
                        btn.dataset.tipo='perfil';
                        $("#interesesCuenta").prepend(btn);

                    }
                    else
                    {
                        btn.dataset.tipo='general';
                        $("#todosIntereses").prepend(btn);
                    }
                }
                
                
            }
            function insertarClave(Texto,elemento,dato)
            {   
                var regreso='';
                var codigo="<div id='prompt'>";
                codigo+="<br /><span id='mensajeClave' class='sinMensaje' >";
                codigo+=Texto;
                codigo+="</span><br /><br />"
                codigo+="<input type='password' id='clave' placeholder='Confirma tu clave por favor' />";
                codigo+="<br /><button id='cancelar'>Cancelar</button>";
                codigo+="<button id='confirmar'>Confirmar</button>";
                codigo+="</div>";
                $("body").append("<div class='fondo'> </div>");
                $("body").append(codigo);
                //$("div[class='fondo']").show("slow");
               
                 
                    $("div[class='fondo']").animate({"height":"+=100%"},"slow");
                        $("#prompt").show("slow",function()
                            {
                                $("#prompt").animate(
                                           {"height":"+=25%"},"slow"
                                         );
                            }
                        );
               
                $("#prompt").children("#cancelar").click(function(){
                       
                            $("#prompt").animate(
                                    {"height":"-=30%"},"slow"

                                    ,function()
                                    {
                                       $("#prompt").hide("slow",function(){ 
                                            $("#prompt").remove(); 
                                            $("div[class='fondo']").animate(
                                                {"height":"-=100%"},"slow",
                                                function(){
                                                    $("div[class='fondo']").remove()
                                                    });
                                        })
                                    });
                        
                        });
                
                $("#prompt").children("#confirmar").click(
                   function(){
                       regreso=$("#clave").val();
                       if(regreso!='' && !tieneEspeciales(regreso))
                       {
                               $("#prompt").html("<div class='loader'></div>");
                               $("div[class='loader']").show("slow");
                                setTimeout(function(){
                                    modifInfo(elemento,dato,regreso);   
                               },2000);
                           
                            
                       }
                       else
                       {
                           $("#clave").focus();
                           $("#mensajeClave").removeClass("sinMensaje");
                           $("#mensajeClave").addClass("errorClave");
                           $("#mensajeClave").html("Tu clave no es válida porque contiene carácteres especiales o está vacía.");
                          
                           
                       }
                   }
                );
                $("#clave").focus();
            }
            function modifInfo(elemento,dato,confirmClave){
                
                
                $("#pass").val(confirmClave);
                if($("#pass").val()==''){
                    alert('Escribe tu clave');
                }
                else{
                   
                    if(dato==6){
                        $("#dir").attr("value",<%=usrId%>);
                        alert(document.getElementById("dir").value);
                        alert("Enviando formulario");
                        document.forms[0].submit();

                    }
                    else{
                            $.post(
                                   "../agregaDatos",
                                 {tipoPeticion:"2",nvoDato:elemento,user:<%=usrId%>,tipo:dato,clavUsr:$("#pass").val()},
                                 function(respuesta){
                                     $("#prompt").html("<span id='mensajeClave' class='sinMensaje'>"+respuesta+"</span>");
                                     $("#mensajeClave").css("top","45%");
                                     $("#mensajeClave").css("display","none");
                                     $("#mensajeClave").show("slow");
                                     setTimeout(function(){
                                     if(respuesta.includes("Error"))
                                     {
                                        
                                          $("#prompt").animate(
                                                  {"height":"-=30%"},"slow"

                                                    ,function()
                                                    {
                                                        $("#prompt").hide("slow",function(){ 
                                                            $("#prompt").remove(); 
                                                            $("div[class='fondo']").animate(
                                                                    {"height":"-=100%"},"slow",
                                                                     function(){
                                                                         $("div[class='fondo']").remove()
                                                                     });
                                                                 })
                                                    });

                                            
                                     }else
                                         location.reload();
                                     },2550);
                                    
                                    }
                                );
                        }
                }
                 
            }
            function traePerfil(){
               
                $("#datosCta").ready(
                        $.ajax({
                        url:"../agregaDatos",
                        type:"POST",
                        data:{tipoPeticion:"1",user:<%=usrId%>},
                        success:
                        function(respuesta){ 
                           // alert(respuesta);
                            respuesta=$.parseJSON(respuesta);
                            //alert(respuesta);
                            $.each(respuesta,function(key,value){
                                
                                if(key=='preview')
                                    document.getElementById(key).src=value;
                                else
                                    document.getElementById(key).value=value;
                            })                                   
                        }
                    })
                
                );
            }
            
            
        </script>
    <style>
      body{
          background:url("../img/fondomusica1.jpg ");
            margin:0px;
        width:100%;
        height: 100%;
      }
      .loader
      {
            display:none;
            position: relative;
            left:30%;
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
          z-index:1;
      }
        .mdl-textfield,.mdl-js-textfield, .mdl-textfield--floating-label, .mdl-textfield__input, .mdl-textfield__label
        {
            /*color: white;*/
            border-color: white;
            border-width: 2px;
        }
        button,input[type='button']
        {
            display:inline-block;
            
            background-color: RGB(21,133,183);
            color: white;
            border-color: transparent;
            -webkit-transition-duration: 0.2s; 
            transition: all 0.2s;
            display: inline-block;
            cursor: pointer;
        }
        #cancelar
        {
            position:absolute;
            left:50%;
            padding:2%;
            top:75%;
        }
        #confirmar
        {
            position: absolute;
            left:75%;
            padding: 2%;
            top:75%;
        }
        #clave
        {
            position:relative;;
            width:98%;
            height:20%;
        }
        #mensajeClave
        {
            position: absolute;
            display: block;
            top:5%;
            left:0%;
            width:100%;
            font-weight: bold;
            text-align: center;
        }
        .sinMensaje
        {
            background-color: RGB(21,133,183);
            color:white;
        }
        .errorClave
        {
            background-color: red;
            color:white;
            opacity: .8;
        }
       
        #prompt
        {
            display:none;
            padding: 1%;
            width:26%;
            height:5%;
            z-index: 3;
            position: absolute;
            left:37%;
            top:35%;
            background-color:white;
            box-shadow: 0px 0px 20px #000000;
            border-radius:3px;
           
        }
        #datosP2
        {
            position: absolute;
            left:65%;
            top:0%;
            margin-top: 5%;
            width:30%;
            height:60%;
            
            padding: 2%;
            background-color: rgba(214,214,214,0.6);
                   
            border-radius:3px;
        }
        #datosP1
        {
           
            position:absolute;
            width:60%;
            height:60%;
            top:0%;
            margin-top: 5%;
            left:1%;
            padding: 2%;
            background-color: rgba(214,214,214,0.6);
            
                    border-radius:3px;
        }
        .interesContainer
        {
         
            width:15%;
            height:55%;
            position: absolute;
            overflow-y:auto;
            overflow-x:hidden;
            top:15%;
            
        }
        .cabInteres
        {
            display:block;
            width:15%;
            height:5%;
            position: absolute;
            top:10%;
            text-align: center;
        }
        #cabTodosInt
        {
            left:55%;
        }
        #btn-interes
        {
            display:block;
            width:98%;
            height:15%;
            margin:1%;
        }
        #todosIntereses
        {
            
            left:55%;
        }
        #cabIntCuent
        {
            left:75%;
            
        }
        
        #interesesCuenta
        {
            
            left:75%;
        }
        button[id='envio']
        {
            position: absolute;
            left:75%;
            top:70%;
            
        }
       
    </style>
    </head>
    <body onload="traeIntereses();">
        <!--<form id="datosCta" name="datosCta" method="post" action="../cambiaDatos">-->
    <div id="container">
       <div id="datosP1" >
                    Nombre de usuario:<br /> <input id="usr" name="usr" class="mdl-textfield__input" type="text" placeholder="Nombre de usuario..."/>
                        <input type="button" value="Cambiar Usuario" onclick="datoModif(1);"/><br/>
                    
                    Contraseña: <br /><input id="psw" name="psw" class="mdl-textfield__input" type="password" placeholder="Contraseña..."/>
                       <input type="button" value="Cambiar  Clave" onclick="datoModif(2);" /><br/>
                    
                    Correo electrónico:<br /> <input id="mail" name="mail" class="mdl-textfield__input" type="text" placeholder="Correo..."/>
                        <input type="button" value="Cambiar correo" onclick="datoModif(3);"  /><br/>
                   
                    Descripcion:<br />
                    <textarea id="descrip" class="mdl-textfield__input" name="descrip" rows="4" cols="50"></textarea><br />
                    <input type="button" value="Cambiar Descripción" onclick="datoModif(5);"  /><br /><br />
                    <span id='cabTodosInt' class='cabInteres' >Intereses</span>  
                    <div id="todosIntereses" class="interesContainer"> </div>
                    <span id='cabIntCuent' class='cabInteres' >Tus intereses</span>
                    <div id="interesesCuenta" class="interesContainer" > </div>
                    <button id="envio" onclick="cambiarIntereses();">Cambiar Intereses</button>
       </div>
        <div id="datosP2" >
                <form id="imgPefil" name="imgPerfil" method="post" action="../agregaImg" enctype="multipart/form-data">
                    
                            Foto de perfil:<br />
                            <img id="preview" name="preview"  width="150" height="150" ><br />
                            <input id="nuevaImg" name="nuevaImg" type="file" onchange="cambiaImg(this);" ><br/>
                             <input type="button" value="Cambiar Imagen" onclick="datoModif(6);"  />
                            <input id="dir" name="dir" value=" " type="hidden"/>
                            <input id="pass" name="pass" value=" " type="hidden"/>
                   

               </form>
       </div>
    </div>
    </body>
</html>
