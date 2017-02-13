/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldn;

/**
 *
 * @author Saul
 */
public class cValida {
    
    private String _error;
    
    public cValida()
    {
        _error="";
    }
    public String getError()
    {
        return this._error;
    }
    public String obtenCampo(int campo){
        String camp="";
        switch(campo)
        {
            case 0:
                camp="Nombre";
                break;
            case 1:
                camp="Apellidos";
                break;
            case 2:
                camp="Usuario";
                break;
            case 3:
                camp="Clave";
                break;
            case 4:
                camp="Confirmacion Clave";
                break;
            case 5:
                camp="Correo";
                break;
            case 6:
                camp="Correo de recuperacion";
                break;
            case 7:
                camp="Anio";
                break;
            case 8:
                camp="Mes";
                break;
            case 9:
                camp="Dia";
                break;
            case 10:
                camp="Descripcion de usuario";
                break;
            
        }
        return camp;
    }
    
    public boolean coinciden(String uno, String dos,int tipoCoincid)
    {
        boolean coinciden=false;
        if(tipoCoincid==0) 
             if(uno.equals(dos))
                    coinciden=true;
             else
                 _error="Claves no coinciden";
        else
            if(!uno.equals(dos))
                coinciden=true;
            else
                _error="Correos iguales";
        return coinciden;
    }
    public boolean correoValido(String correo){
        boolean valido=false;
        if(correo.indexOf("@")>0){
            correo.matches("/^[_A-Za-z0-9-\\\\+]+(\\\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\\\.[A-Za-z0-9]+)*(\\\\.[A-Za-z]{2,})$/");
            valido=true;
        }else
            _error="Correo no valido";
    
        return valido;
    }
    public boolean tieneLetras(String cadena){
        boolean tiene=false;
        if(cadena.matches("/[a-zA-Z]"))
        {
            tiene=true;
            _error="Contiene letras";
        }
        return tiene;
    }
    public boolean tieneEspeciales(String cadena)
    {
        boolean tiene=false;
        if(cadena.matches("/[^a-zA-Z0-9]/"))
        {
            tiene=true;
            _error="Caracteres espciales encontrados";
        }
        return tiene;
    }
    public boolean extensionValida(String cadena){
        boolean valida=false;
        cadena.toLowerCase();
        if(cadena.endsWith(".jpg")||cadena.endsWith(".png"))
            valida=true;
        else
            _error="Extension de archivo invalida";
        return valida;
    }
    public boolean tieneEspecialesCad(String cadena){
        boolean tiene=false;
        if(cadena.matches("/[^a-zA-Z0-9\\s]/"))
        {
            tiene=true;
            _error="Caracteres especiales no validos para cadena encontrados";
        }
            return tiene;
    }
    public boolean tieneEspecialesTxT(String cadena){
        boolean tiene=false;
        if(cadena.matches("/[^\\.\\,\\:\\(\\)\\?\\¿\\¡\\!\\\"a-zA-Z0-9\\s]/")){
            tiene=true;
            _error="Caracteres especiales no validos para texto encontrados";
        }
            return tiene;
    }
    public boolean tieneNumeros(String cadena){
        boolean tiene=false;
        if(cadena.matches("/[0-9]/"))
        {
            tiene=true;
            _error="Se encontraron numeros en la cadena";
        }
        return tiene;
    }
    public boolean validaCadena(String cadena){
        boolean valida=true;
        if(tieneNumeros(cadena)||tieneEspecialesCad(cadena))
        {
            valida=false;
        }
        return valida;
    }
    public boolean validaTexto(String texto){
        boolean valido=true;
        if(tieneEspecialesTxT(texto))
        {
            valido=false;
        }
        return valido;
    }
    public boolean validaCadNum(String cadena)
    {
        boolean valido=true;
        if(tieneLetras(cadena)||tieneEspecialesCad(cadena))
        {
            valido=false;
        }
        return valido;
    }
    public boolean validaCorreo(String correo){
        boolean valido=false;
        if(correoValido(correo))
        {
            valido=true;
        }
        return valido=true;
    }
    public boolean validaVacios(String [] elementos)
    {
        boolean llenos=true;
        for(int i=0;i<elementos.length;i++){
            if(elementos[i].equals("")){
                llenos=false;
                _error=obtenCampo(i);
                break;
            }
        }
        return llenos;
    }
    public boolean valida(String elemento,int tipo)
    {
        boolean valido = false;
        switch(tipo)
        {
            case 0:
            case 1:
                valido=tieneEspecialesCad(elemento)||tieneNumeros(elemento)?false:true;
                break;
            case 2:
                valido=tieneEspecialesCad(elemento)?false:true;
                break;
            case 3:
            case 4:
                valido=tieneEspecialesCad(elemento)?false:true;
                break;
            case 5:
            case 6:
                valido=correoValido(elemento);
                break;
            case 7:
            case 9:
                valido=tieneLetras(elemento)||tieneEspeciales(elemento)?false:true;
                break;
            case 8:
                valido=tieneNumeros(elemento)||tieneEspeciales(elemento)?false:true;
                break;
            case 10:
                valido=tieneEspecialesTxT(elemento)?false:true;
                break;
        }
        return valido; 
        
    }
    
}
