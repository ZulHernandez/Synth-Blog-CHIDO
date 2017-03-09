var diccCampos=["Nombre","Apellidos","Usuario","Contraseña","Contraseña de confirmación","Correo","Correo de confirmación","Año","Mes","Día","Descripción"];


function tieneNumeros(cadena){
    var tiene=false;
    var cad=cadena;
    var res=cad.match(/[0-9]/);
    if(res!=null)
        tiene=true;
    return tiene;  
}
function activo(cadena){
    var tiene=false;
    var cad=cadena;
    var res=cad.match(/Synth_BLOG/);
    if(res!=null)
        tiene=true;
    return tiene;  
}
function tieneLetras(cad){
    var tiene=false;
    var cadena=cad;
        var res=cadena.match(/[a-z]|[A-Z]/);
        if(res!=null)
          tiene=true;
      return tiene;
}
function tieneEspeciales(cad){
    var tiene=false;
    var cadena=cad;
        var res=cadena.match(/[^a-zA-Z0-9\s]/);
        if(res!=null)
            tiene=true;
    return tiene;
}
function tieneEspecialesCad(cad){
    var tiene=false;
    var cadena=cad;
    var res=cadena.match(/[^a-zA-Z0-9]/);
    if(res!=null)
        tiene=true;
    return tiene;
}
function extensionValida(cad){
    var tiene=true;
    var cadena=cad;
    var res=cadena.match(/.jpg$|.png$/i);
    if(res==null)
        tiene=false;
    return tiene;
} 

function validaCadena(texto){
 
    var valido=true;
    if( tieneNumeros(texto)||tieneEspeciales(texto))
    {
        alert('Tiene numeros o especiales');
        valido=false;
    }
    return valido;
}
function validaNumerico(texto){
    var valido=true;
    if(tieneEspeciales(texto)||tieneLetras(texto))
    {
        alert('Tiene especiales o letras');
        valido=false;
    }
    return valido;
}
function validaDescripcion(texto){
    var valido=true;
    var tex=texto;
    var res=tex.match(/[^\.\,\:\(\)\?\¿\¡\!\"a-zA-Z0-9\s]/);
    if(res!=null)
        valido=false;
    return valido;
}
function validoCorreo(correo){
    var valido=true;
    var exp=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if(!exp.test(correo))
        valido=false;
    return valido;
}
function vacios(Elementos){
    var vacios=false;
    for(var i=0;i<Elementos.length;i++){
            if(Elementos[i].value ==''){
                alert(i);
                alert(diccCampos[i]+' vacio');
                if(i<7)
                    divs2();
                document.getElementById(Elementos[i].id).focus();
                vacios=true;
                break;      
            }
        }
    return vacios;
}
function foto(){
    //var archivo = document.getElementById("dir");
   // alert('foto');
    var nfoto = document.getElementById("fotoUsr");
    //var formu = document.getElementById("foto");
    var ximagen = nfoto.files[0];
    document.getElementById("dir").value = ximagen.name;
        //formu.action =  "../modificaDatos";
        //document.forms[0].submit();
        //formu.submit();
}

function traeCampo(numCampo){
    var campo="";
    switch(numCampo){
        case 1:
            campo="usr";
            break;
        case 2:
            campo="psw";
            break;
        case 3:
            campo="mail";
            break;
        case 4:
            campo="interesesCuenta";
            break;
        case 5:
            campo="descrip";
            break;
        case 6:
            campo="dir";
            break;
    }
    return campo;
}
function datoModif(numDato){
    var elemento=traeCampo(numDato);
    var valor=[];
    if(numDato==6)
        document.getElementById(elemento).value=document.getElementById("nuevaImg").files[0].name;
    if(numDato==4)
    {
        //JSON.stringfy
       var jsonIntereses='';
        $.each($("#interesesCuenta").find("button"),function(key,value){
            if(this.dataset.tipo=='perfil')
                valor.push(this.dataset.regis);
            else
            {
                traeIntereses();
                alert("Error:Tipo de interés incorrecto, vuelve a agregar tus intereses.");
            }
        });
       
        jsonIntereses=JSON.stringify({"Intereses":valor});
        alert(jsonIntereses);
        validarNvoDato(numDato,jsonIntereses);
    }
    else
    {
        valor=document.getElementById(elemento).value;
        if(valor==''||valor==' ')
        {
            alert('Llena el valor');
            if(numDato==6)
                document.getElementById("nuevaImg").focus();
            else
                document.getElementById(elemento).focus();
        }else
            validarNvoDato(numDato,valor);
    }
   
}
function validarNvoDato(dato,eleme)
{
    var envioValido=false;
    var elemento=eleme;
    if(dato!=4){
        switch(dato)
        {
            case 1:
            case 2:
                envioValido=!tieneEspecialesCad(elemento);
                break;
            case 3:
                envioValido=validoCorreo(elemento);
                break;
            case 5:
                envioValido=validaDescripcion(elemento);
                break;
            case 6:
                envioValido=extensionValida(elemento);
                
                break;
        }
    }else{
        elemento=eleme;
        envioValido=true;
    }
    if(!envioValido){
        var idElemnto=traeCampo(dato);
        alert('Campo inválido');
        if(dato==6)
        {
            document.getElementById("dir").value="";
            idElemnto="nuevaImg";
        }
        document.getElementById(idElemnto).value="";
        document.getElementById(idElemnto).focus();
    }
    else
    {
        var campo="";
        if(dato==6)
            campo="nuevaImg";
        else
            campo=traeCampo(dato);
            
            var confirmacion=confirm("¿Seguro que quieres modificar?");
            if(confirmacion){
            
                   insertarClave('Confirma tu contraseña por favor.',elemento,dato);
                }else
                {
                    document.getElementById(campo).value="";
                }
            
            
    }
}
function validacion(){
    var pasa=true;
    var name=document.getElementById("nombre");
    var apellidos=document.getElementById("apell");
    var user=document.getElementById("usr");
    var psw=document.getElementById("psw");
    var pswC=document.getElementById("pswC");
    var correo=document.getElementById("correo");
    var correoC=document.getElementById("correoR");
    var anio=document.getElementById("anio");
    var mes=document.getElementById("mes");
    var dia=document.getElementById("dia");
    var cont=document.getElementById("contenido");
    var Elementos=[name,apellidos,user,psw,pswC,correo,correoC,anio,mes,dia,cont];
    
    pasa=vacios(Elementos);
    if(!pasa)
    {
             if(Elementos[4].value!=Elementos[3].value){
                  divs2();
                  document.getElementById(Elementos[4].id).value='';
                  document.getElementById(Elementos[3].id).value='';
                  alert('Las contraseñas que elijas deben coincidir.');
                  document.getElementById(Elementos[3].id).focus();
                }else
                {
                    if(Elementos[5].value==Elementos[6].value){
                        divs2();
                        document.getElementById(Elementos[6].id).value='';
                        document.getElementById(Elementos[5].id).value='';
                        alert('Necesitamos un correo distinto para que puedas recuperar tu cuenta en caso de olvidar tu contraseña o correo de ingreso.');
                        document.getElementById(Elementos[5].id).focus();
                    }
                    else
                    {
                       for(var i=0;i<Elementos.length;i++){
                           pasa=true;
                        switch(i)
                        {
                            case 0,1,2:
                                if(tieneNumeros(Elementos[i].value))
                                    pasa=false;
                                else
                                    pasa=!tieneEspeciales(Elementos[i].value);
                                break;
                            case 3,4:
                                pasa=!tieneEspeciales(Elementos[i].value);
                                break;
                            case 5:
                                pasa=validoCorreo(Elementos[i].value);
                                break;
                            case 6:
                                pasa=validoCorreo(Elementos[i].value);
                                break;
                            case 7,9:
                                if(tieneLetras(Elementos[i].value)|| tieneEspeciales(Elementos[i].value))
                                    pasa=false;
                                break;
                            case 8:
                                if(tieneNumeros(Elementos[i].value)||tieneEspeciales(Elementos[i].value))
                                    pasa=false;
                                break;
                            case 10:
                                pasa=validaDescripcion(Elementos[i].value);
                                break;
                         }
                        if(!pasa)
                        {
                            if(i<7)
                                divs2();
                            alert('Datos invalidos: '+diccCampos[i]);
                            if(i==10)
                             document.getElementById(Elementos[i].id).innerHTML='';
                            else
                            document.getElementById(Elementos[i].id).value='';
                            document.getElementById(Elementos[i].id).focus();
                            break; 
                        }
                    }
                    if(pasa)
                    {
                         //datosReg.submit();
                         //foto();
                         procesaEnvio();
                     }
                }
            }
                
    }
    else
        alert('Rellena correctamente el formulario para que se complete tu registro.');
    
}