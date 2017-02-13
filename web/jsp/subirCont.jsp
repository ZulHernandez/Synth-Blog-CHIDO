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
        <meta charset="UTF-8"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="../styles/teoria.css" rel="stylesheet" type="text/css"/>
        <script src="../scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
        <script type="text/javascript">
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
            function validar(){
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
                    data.append('bd',<%=db%>);
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
    </head>
    <style>
        .mdl-textfield,.mdl-js-textfield, .mdl-textfield--floating-label, .mdl-textfield__input, .mdl-textfield__label
        {
            color: white;
            border-color: white;
            border-width: 2px;
        }
    </style>
    <body>
        <div class="container">
            <form id="elform" name="elform" method="post" enctype="multipart/form-data" action="../teoria">
                <div id="forma" class="container">
                    <span>Titulo:</span><br>
                    <input type="text" placeholder="titulo del apartado teórico" id="titulo" name="titulo" /><br>
                    <span>Descripcion</span><br>
                    <textarea id="descripcion" class="area" rows="4" maxlength="300" name="descripcion" placeholder="Breve descripcion del contenido de este apartado teorico"></textarea>
                    <span>Contenido:</span>
                    <textarea id="cuerpo" class="area" rows="4" maxlength="500" name="cuerpo" placeholder="Contenido del apartado teorico"></textarea>
                    <div id="archivo">
                        <br/>
                        <button class="file-upload" id="enviar"><input type="file" id="contenido" name="contenido" class="file-input" onchange="validaImagen(this); txt2()"/>Agregar imagen:<div id="ext2"></div></button>&nbsp;
                        <input type="text" id="cabecera" name="cabecera" placeholder="Cabecera de la imagen" />
                    </div>
                    <div id="botones">
                        <input type="button" id="boto"  name="enviar" onclick="validar();" style="float: right; margin: 5px;" class="boton">Enviar</input>
                    </div>
                </div>
            </form>
        </div>
    </body>
</html>
