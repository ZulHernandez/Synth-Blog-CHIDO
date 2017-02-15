<%--
    Document   : postear
    Created on : 30-nov-2016, 13:15:58
    Author     : Bear
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession ss = request.getSession();
    int db = 0;
    try{
        if(ss.getAttribute("bd") == null) throw new Exception("no hay base de datos aqui");
        db = Integer.parseInt(ss.getAttribute("bd").toString());
    }catch(Exception e){
        System.out.println(e.getMessage());
    }
    ldn.cPost cuenta = new ldn.cPost(db);
    String[] categorias = cuenta.obtenCategorias();
    int cont = 1;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../styles/teoria.css" rel="stylesheet" type="text/css"/>
        <title>.:Postear:.</title>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script src="../scripts/validaRegistro.js" type="text/javascript"></script>
        <script src="/Synth_BLOG/css/sweetalert-master/dist/sweetalert.min.js" type="text/javascript"></script>
        <link href="/Synth_BLOG/css/sweetalert-master/dist/sweetalert.css" rel="stylesheet" type="text/css">
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
                        swal({title: 'ARCHIVO INCORRECTO',text: 'Seleccione una imagen',type: 'error',showConfirmButton: false,timer: 3000, html: false});
                        $("#dir").attr("value","");
                        input.value="";
                        $("#contenido").focus();
                    }else{
                    $("#dir").attr("value",input.files[0].name);
                }
            }
            function colorear(selected){
                var idd = selected.id;
                for(var i = 1; i <= <%=categorias.length%>; i++){
                    document.getElementById(i).style.backgroundColor = "RGB(225,0,203)";
                }    
                document.getElementById(idd).style.backgroundColor = "RGB(123,23,26)";
                categoria.value = selected.id;
            }
            function validar(){
                var titulo = document.getElementById("titulo").value;
                var descripcion = document.getElementById("descripcion").value;
                var categoria = document.getElementById("categoria").value;
                var cabeceraI = document.getElementById("cabeceraI").value;
                var cabeceraA = document.getElementById("cabeceraA").value;
                if(titulo == "" || descripcion == "" || categoria == ""){
                    //swal({title: 'ERROR',text: 'Los campos no pueden ser vacios. Por favor, llenalos',type: 'error',showConfirmButton: true, html: false});
                    alert("Los campos de título, descripción y categoría deben ser llenados obligatoriamente.");
                }else{
                    var data = new FormData();
                    jQuery.each(jQuery('#contenido')[0].files, function(i, file) {
                        data.append('contenido', file);
                    });
                    jQuery.each(jQuery('#audio')[0].files, function(i, file) {
                        data.append('audio', file);
                    });
                    
                    data.append('tipo','0');
                    data.append('titulo',titulo);
                    data.append('descripcion',descripcion);
                    data.append('categoria',categoria);
                    data.append('cabeceraI',cabeceraI);
                    data.append('cabeceraA',cabeceraA);
                    document.getElementById("enviar").disabled = true;
                    document.getElementById("enviar").value = "ENVIANDO...";
                    jQuery.ajax({
                        url: '../post',
                        data: data,
                        cache: false,
                        mimeType: "multipart/form-data",
                        contentType: false,
                        processData: false,
                        type: 'POST',
                        success: function(respuesta){
                            if(respuesta.startsWith("ERROR")){
                                //swal({title: "ERROR",text: respuesta.substring(7),type: "error",showConfirmButton: true, html: false});
                                alert("error: " + respuesta.substring(7));
                                document.getElementById("enviar").disabled = false;
                                document.getElementById("enviar").value = "ENVIAR";
                            }else{
                                alert(respuesta);
                                window.location = "perfil.jsp";
                                /*swal({
                                    title: "EXCELENTE",
                                    text: "Tu post ha sido publicado. dirigete a tu perfil para verlo!",
                                    type: "successs",
                                    showCancelButton: true,
                                    confirmButtonColor: "#DD6B55",
                                    confirmButtonText: "IR ALLA",
                                    cancelButtonText: "SEGUIR POSTEANDO",
                                    closeOnConfirm: true,
                                    closeOnCancel: true
                                  },
                                  function(isConfirm){
                                    if (isConfirm) {
                                        window.location = "perfil.jsp";
                                    } else {
                                        window.location = "postear.jsp";
                                    }
                                  });*/
                            }
                        }
                    });
                }
            }
        </script>
        <style type="text/css">
            .selection{
                background-color: RGB(225,0,203);
            }
            .selection:pressed{
                background-color: white;
            }
           table
           {
               background-color: purple;
           }
        </style>
    </head>
    <body><form id="formaso" name="formaso" action="../post" method="post" enctype="multipart/form-data">
        <table  width="100%" >
            <tr><td height="100%">
            <div id="micha1" class="container" >
                <center>
                    <table  >
                        <tr>
                            <td>Titulo:</td>
                            <td><input type="text" id="titulo" name="titulo" placeholder="Titulo del post"></td>
                        </tr>
                        <tr>
                            <td>Categorias</td>
                            <td>
                                <%for(String cat:categorias){%>
                                    <input type="button" id="<%=cont%>" name="botoncitos" onclick="colorear(this);" class="selection" value="<%=cat%>">
                                    <%cont++;%>
                                <%}%>
                                <input type="hidden" id="categoria" name="categoria" value="" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><input type="button" id="enviar" name="enviar" onclick="validar();" value="ENVIAR" /></td>
                        </tr>
                    </table>
                </center>
            </div></td>
            <td width="60%"><div id="micha2" class="container" height="100%">
                <table  width="100%" height="100%">
                    <tr>
                        <td valign="middle" align="center" width="40%">
                            <img src="/Synth_BLOG/img/Corchea.jpg" id="preview" name="preview"  width="150" height="150" ><br />
                            <input id="contenido" name="contenido" type="file" onchange="cambiaImg(this);" ><br/>
                            <input type="text" id="cabeceraI" name="cabeceraI" placeholder="añade una cabecera a tu imagen" />
                        </td>
                        <td rowspan="2" width="60%"><textarea id="descripcion" class="area"  rows="4" maxlength="500" name="descripcion" placeholder="CONTENIDO..."></textarea></td>
                    </tr>
                    <tr>
                        <td valign="middle" align="center" width="40%">
                            <input type="file" id="audio" name="audio"><br>
                            <input type="text" id="cabeceraA" name="cabeceraA" placeholder="Agrega una cabecera a tu archivo de audio">
                        </td>
                    </tr>
                </table>
            </div></td>
        </table>
    </form></body>
</html>
