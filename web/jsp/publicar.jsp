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
            function compruebaDatos(datos,nombreDatos)
            {
                var error="";
                if(datos.length!=nombreDatos.length)
                {
                    error="Cantidad de datos y nombres no coinciden";
                }
                else
                {
                    for(var i=0;i<datos.length;i++)
                    {
                        if(datos[i]==''|| datos[i]==null)
                        {
                            if(nombreDatos[i]=='Cabecera')
                            {
                                
                                if($("#contenido").val()!='' && $("#contenido").val()!=null)
                                {
                                    error="Contenido vacío: Cabecera de imagen.\n";
                                    error+="No puedes subir una imagen sin cabecera.";
                                    break;
                                }
                            }
                            else
                            {
                                error="Campo vacio: "+nombreDatos[i];
                                break;
                            }
                                
                        }
                        else
                        {
                            if(nombreDatos[i]=='Cabecera')
                            {
                                if($("#contenido").val()=='' || $("#contenido").val()==null)
                                {
                                    error="Contenido vacío: Imagen.\n";
                                    error+="No puedes subir una cabecera de imagen sin imagen.";
                                    break;
                                }
                               
                                
                            }
                           
                        }
                    };
                    return error;
                }
            }
            function validarH(){
                var titulo = document.getElementById("titulo").value;
                var descripcion = document.getElementById("descripcion").value;
                var cuerpo = document.getElementById("cuerpo").value;
                var cabecera = document.getElementById("cabecera").value;
                var datos=[titulo,descripcion,cuerpo,cabecera];
                var nombreDatos=["Titulo","Descripción","Cuerpo","Cabecera"];
                var estatusDatos=compruebaDatos(datos,nombreDatos);
                if(estatusDatos.length!=0){
                    alert(estatusDatos);
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
                            if(!respuesta.includes("Error"))
                            {
                                  window.location = "teoria.jsp";
                            }
                              
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
        textarea
        {
            overflow-y: auto;
        }
        #titulo,#cabecera
        {
            width:50%;
            
        }
        #containerImg
        {
            display:inline-block;
            width:40%;
            height:100%;
            position: absolute;
            left:60%;
            top:0%;
        }
        .containerPost
        {
            width:70%;
            left:15%;
        }
        #preview
        {
            position:relative;
            left:15%;
            width:50%;
            height:40%;
        }
    </style>
    </head>
    
    <body>
        <div class="container containerPost">
            <form id="elform" name="elform" method="post" enctype="multipart/form-data" action="../teoria">
                Título: 
                <br />
                <input type="text" placeholder="titulo del apartado teórico" id="titulo" name="titulo">
                <br />
                <br />
                Descripción: 
                <br>
                <textarea id="descripcion" class="area" rows="5" cols="70" maxlength="200" name="descripcion" placeholder="Breve descripción de este apartado teórico"></textarea>
                <br />
                Contenido:
                <br>
                <textarea id="cuerpo" class="area" rows="10" cols="70" maxlength="2000" name="cuerpo" placeholder="Contenido del apartado teórico"></textarea>
                <br />
                <div id='containerImg'>
                    <br />
                    <img src="/Synth_BLOG/img/Corchea.jpg" id="preview" name="preview" >
                    <br/>
                    <br />
                    <input id="contenido" name="contenido" type="file" onchange="cambiaImg(this);">
                    <br/>
                    <br />
                    <input type="text" id="cabecera" name="cabecera" placeholder="Cabecera de la imagen">
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <input type="button" id="enviar" name="enviar" onclick="validarH();" value="ENVIAR" />
                </div>
                
            </form>
        </div>
    </body>
</html>