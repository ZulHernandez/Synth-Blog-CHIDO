<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    HttpSession ss = request.getSession();
    int db = 0;
    try{
        db = ss.getAttribute("bd") == null ? 0 : Integer.parseInt(ss.getAttribute("bd").toString());
        System.out.println("bd = " + db);
    }catch(Exception e){
        System.out.println(e.getMessage());
        response.sendRedirect("/Synth_BLOG/login");
    }
%>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="../styles/teoria.css" rel="stylesheet" type="text/css">
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
                        $("#nuevaImg").focus();
                    }else{
                    $("#dir").attr("value",input.files[0].name);
                }
            }
            function validaImagen(f){
                var ext=['gif','jpg','jpeg','png'];
                var v=f.value.split('.').pop().toLowerCase();
                for(var i=0,n;n=ext[i];i++){
                    if(n.toLowerCase()==v)
                        return
                }
                var t=f.cloneNode(true);
                t.value='';
                f.parentNode.replaceChild(t,f);
                swal({title: 'ARCHIVO INCORRECTO',text: 'Seleccione una imagen',type: 'error',showConfirmButton: false,timer: 3000, html: false});
            }
            function txt2()
            {
                var str = document.getElementById("contenido").value;
                document.getElementById("ext2").innerHTML = str;
            }
            function validarH(){
                var titulo = document.getElementById("titulo").value;
                var descripcion = document.getElementById("descripcion").value;
                var cuerpo = document.getElementById("cuerpo").value;
                var cabecera = document.getElementById("cabecera").value;
                if(titulo == "" || descripcion == "" || cuerpo == ""){
                    alert("DATOS VACIOS: por favor, llena los campos faltantes");
                }else{
                    var data = new FormData();
                    jQuery.each(jQuery('#contenido')[0].files, function(i, file) {
                        data.append('contenido', file);
                    });
                    data.append('tipo','1');
                    data.append('titulo',titulo);
                    data.append('descripcion',descripcion);
                    data.append('cuerpo',cuerpo);
                    data.append('cabecera',cabecera);
                    data.append('bd',0);
                    jQuery.ajax({
                        url: '../teoria',
                        data: data,
                        cache: false,
                        mimeType: "multipart/form-data",
                        contentType: false,
                        processData: false,
                        type: 'POST',
                        success: function(respuesta){
                            alert(respuesta);
                            window.location = "teoria.jsp";
                        }
                    });
                }
            }
        </script>
    <style>
        .mdl-textfield,.mdl-js-textfield, .mdl-textfield--floating-label, .mdl-textfield__input, .mdl-textfield__label
        {
            color: white;
            border-color: white;
            border-width: 2px;
        }
    </style></head>
    
    <body>
        <div class="container">
            <form id="elform" name="elform" method="post" enctype="multipart/form-data" action="../teoria">
                <table cellspacing="10" width="100%">
                    <tbody>
                    <tr>
                        <td align="center" colspan="2">Titulo: <input type="text" placeholder="titulo del apartado teórico" id="titulo" name="titulo"></td>
                    </tr>
                    <tr>
                        <td width="70%">Descripcion: <br><textarea id="descripcion" class="area" rows="4" maxlength="300" name="descripcion" placeholder="Breve descripcion del contenido de este apartado teorico"></textarea></td>
                        <td align="center">
                            <img src="/Synth_BLOG/img/Corchea.jpg" id="preview" name="preview" width="150" height="150"><br>
                            <input id="contenido" name="contenido" type="file" onchange="cambiaImg(this);"><br>
                            <input type="text" id="cabecera" name="cabecera" placeholder="Cabecera de la imagen">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Contenido:<br><textarea id="cuerpo" class="area" rows="4" maxlength="500" name="cuerpo" placeholder="Contenido del apartado teorico"></textarea></td>
                    </tr>
                    <tr>
                        <td align="right" colspan="2"><input type="button" id="enviar" name="enviar" onclick="validarH();" value="ENVIAR" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </body>
</html>