

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
                        {tipoPeticion:"0"},
                        function(respuesta){
                            //alert(respuesta);
                            $("#intereses").html(respuesta);
                            traePerfil();
                        }
                    )
                );
            }
            
            function modifInfo(elemento,dato){
                var confirmClave=prompt("Confirma tu clave por favor");
                
                $("#pass").val(confirmClave);
                if($("#pass").val()==''){
                    alert('Escribe tu clave');
                }else{
                   
                if(dato==6){
                    $("#dir").attr("value",<%=usrId%>);
                    alert(document.getElementById("dir").value);
                    alert("Enviando formulario");
                    document.forms[0].submit();
                    
                }else{
                    $.post(
                           "../agregaDatos",
                         {tipoPeticion:"2",nvoDato:elemento,user:<%=usrId%>,tipo:dato,clavUsr:$("#pass").val()},
                         function(respuesta){
                             location.reload();
                             alert(respuesta);
                             
                             
                         }
                   );
                }
                }
                 
            }
            function traePerfil(){
               // alert(<%=usrId%>);
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
            function cualInteres(select){
                alert(select.value);
            }
        </script>
    <style>
        
        .mdl-textfield,.mdl-js-textfield, .mdl-textfield--floating-label, .mdl-textfield__input, .mdl-textfield__label
        {
            /*color: white;*/
            border-color: white;
            border-width: 2px;
        }
        
    </style>
    </head>
    <body onload="traeIntereses();">
        <!--<form id="datosCta" name="datosCta" method="post" action="../cambiaDatos">-->
        <div id="container" name="container">
       <!-- <div id="datosP1" name="datosP1">-->
                    Nombre de usuario:<br /> <input id="usr" name="usr" class="mdl-textfield__input" type="text" placeholder="Nombre de usuario..."/>
                        <input type="button" value="Cambiar>" onclick="datoModif(1);"/><br/>
                    
                    Contraseña: <br /><input id="psw" name="psw" class="mdl-textfield__input" type="password" placeholder="Contraseña..."/>
                       <input type="button" value="Cambiar>" onclick="datoModif(2);" /><br/>
                    
                    Correo electrónico:<br /> <input id="mail" name="mail" class="mdl-textfield__input" type="text" placeholder="Correo..."/>
                        <input type="button" value="Cambiar>" onclick="datoModif(3);"  /><br/>
                        Intereses: <br />
                        <select id="intereses" name="intereses" onchange="cualInteres(this);">
                            
                        </select>
                    <input type="button" value="Cambiar>" onclick="datoModif(4);"  /><br />
                    Descripcion:<br />
                    <textarea id="descrip" class="mdl-textfield__input" name="descrip" rows="4" cols="50"></textarea><br />
                    <input type="button" value="Cambiar>" onclick="datoModif(5);"  /><br /><br />
       <!-- </div>-->
        <!--<div id="datosP2" name="datosP2">-->
                <form id="imgPefil" name="imgPerfil" method="post" action="../agregaImg" enctype="multipart/form-data">
                    
                            Foto de perfil:<br />
                            <img id="preview" name="preview"  width="150" height="150" ><br />
                            <input id="nuevaImg" name="nuevaImg" type="file" onchange="cambiaImg(this);" ><br/>
                             <input type="button" value="cambiar>" onclick="datoModif(6);"  />
                            <input id="dir" name="dir" value=" " type="hidden"/>
                            <input id="pass" name="pass" value=" " type="hidden"/>
                   

               </form>
       <!-- </div>-->
        </div>
    </body>
</html>
