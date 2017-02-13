/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldn;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author Castillo
 */
public class cLogica {
    private String error;
    private String usuario;
    private String activo;
    private int bd;
    private int tipous;
    public cLogica(){
        this.error = "";
        this.bd = 0;
        this.activo="";
    }
    public cLogica(int bd){
        this.error = "";
        this.bd = bd;
        this.activo="";
    }
    public String getError(){
        return this.error;
    }
    public String registrar(String nam,String ape,String us, String clav
   ,String fecha,String correo,String correoR, String des){
        String registro="";
        ResultSet rsRegistro=null;
        try{
            for(int i = 0; i < 4; i++){
                BD.cDatos sql=new BD.cDatos(0);
                sql.conectar();
                rsRegistro = sql.consulta("call _registraCuenta('"+nam+"','"+ape+"','"+us+
                        "','"+clav+"','"+fecha+"','"+correo+"','"+correoR+"','"+des+"');");
                if(rsRegistro.next()){
                    registro=rsRegistro.getString("msg");
                }
                sql.cierraConexion();
            }
        }catch(Exception e){
            this.error=e.getMessage();
        }
        return registro;
    }
    public String getMes(String mes)
    {
        String result="";
        switch(mes)
        {
            case "Enero":
                result="01";
                break;
                case "Febrero":
                result="02";
                break;
                case "Marzo":
                result="03";
                break;
                case "Abril":
                result="04";
                break;
                case "Mayo":
                result="05";
                break;
                case "Junio":
                result="06";
                break;
                case "Julio":
                result="07";
                break;
                case "Agosto":
                result="08";
                break;
                case "Septiembre":
                result="09";
                break;
                case "Octubre":
                result="10";
                break;
                case "Noviembre":
                result="11";
                break;
                case "Diciembre":
                result="12";
                break;
                
        }
        return result;
    }
    public String getIntereses(){
        String srcIntereses="<option value='0'> Elige un interes</option>";
        BD.cDatos sql=new BD.cDatos(bd);
        ResultSet rsInteres=null;
        try{
            sql.conectar();
            rsInteres=sql.consulta("call _obtenIntereses();");
            while(rsInteres.next()){
                srcIntereses+="<option value='"+rsInteres.getString("Interes")+"'>"
                        +rsInteres.getString("Genero")+"</option>";
            }
        }catch(Exception e){
            this.error=e.getMessage();
        }
        
        return srcIntereses;
    }
    public String validarRecuperacion(String correoC, String correoR){
        String resultado="";
        ResultSet rsRecu=null;
        BD.cDatos sql=new BD.cDatos(bd);
        try{
            sql.conectar();
            rsRecu=sql.consulta("call _validaRecuperacion('"+correoC+"','"+correoR+"');");
            if(rsRecu.next())
            {
                resultado=rsRecu.getString("Usr");
            }
        }catch(Exception e){
            this.error=e.getMessage();
        }
        return resultado;
    }
     public String[] iniArray(int len){
        String[] array = new String[len];
        for(int i = 0; i < len; i++){
            array[i] = "registro-"+(i+1);
        }
        return array;
    }
     public int getTipous(){
        return this.tipous;
    }
    public String recuperarCuenta(String correoC,String correoR,String nvaClave){
        String resultado="";
        ResultSet rsRecuperar=null;
        BD.cDatos sql=new BD.cDatos(bd);
        try{
            sql.conectar();
            rsRecuperar=sql.consulta("call _recuperarCuenta('"+correoC+"','"+correoR+"','"+nvaClave+"');");
            if(rsRecuperar.next()){
                if(rsRecuperar.getString("Regreso").equals("Cuenta recuperada"))
                    resultado=rsRecuperar.getString("Token");
            }
        }catch(Exception e){
            this.error=e.getMessage();
        }
        return resultado;
    }
    public JsonObject perfilToJson(String [] att,String [] values){
        JsonObject perfil=new JsonObject();
        for(int i=0;i<values.length;i++)
        {
            perfil.addProperty(att[i],values[i]);
        }
        return perfil;
    }
    public int getLogin(String correo, String contraseña){
        BD.cDatos sql = new BD.cDatos(bd);
        ResultSet gatito = null;
        int id = 0;
        try{
            sql.conectar();
            gatito = sql.consulta("call _obtenCuenta('"+ correo +"','"+ contraseña +"')");
            if(gatito.next()){
                id = Integer.parseInt(gatito.getString("msg"));
                usuario = gatito.getString("us");
                activo=gatito.getString("activo");
                tipous = Integer.parseInt(gatito.getString("tipous"));
                System.out.println(activo);
                
                if(!(activo.endsWith(".jpg") || activo.endsWith(".png")))
                {
                    id=404;
                }
            }
        }catch(Exception e){
            System.out.println(this.error);
            System.out.println("Qui?");
            this.error = e.getMessage();
        }
        return id;
    }
    public String getUsuario(){
        return this.usuario;
    }
    public boolean datosVacios(String [] datos){
        boolean vacios=false;
        for(int i=0;i<datos.length;i++)
        {
            if(datos[i].equals(""))
            {
                vacios=true;
                this.error="Datos faltantes"+i;
            }
        }
        return vacios;
    }
    public String modifDatosCta(String idUsr,String nvoDato,String clav,String tipo){
        BD.cDatos sql=new BD.cDatos(bd);
        ResultSet rsModif=null;
        String resultado="";
        try{
            sql.conectar();
            rsModif=sql.consulta("call _modificarCuenta('"+idUsr+"','"+clav+"','"+nvoDato+"','"+tipo+"');");
            if(rsModif.next()){
                resultado=rsModif.getString("Estado");
            }
        }catch(Exception e){
            this.error=e.getMessage();
        }
        return resultado;
    }
    public String [] traePerfil(String idUsr,int i){
        BD.cDatos sql=new BD.cDatos(bd);
        ResultSet rsPerfil=null;
        String []datos=new String[i==1?5:4];
        try{
            sql.conectar();
            rsPerfil=sql.consulta("call _traePerfil("+Integer.parseInt(idUsr)+");");
            if(rsPerfil.next()){
                if(rsPerfil.getString("estado").equals("Encontrado")){
                    datos[0]=rsPerfil.getString("nombre");
                    if(i==1){
                        datos[1]=rsPerfil.getString("contra");
                        datos[2]=rsPerfil.getString("mail");
                        datos[3]=rsPerfil.getString("descrip");
                        datos[4]=rsPerfil.getString("fotoUsr");
                    }else
                    {
                        datos[0]=rsPerfil.getString("nombre");
                        datos[1]=rsPerfil.getString("mail");
                        datos[2]=rsPerfil.getString("descrip");
                        datos[3]=rsPerfil.getString("fotoUsr");
                        
                    }
                }else
                    datos[0]="";
                    //datos[0]=rsPerfil.getString("estado");
            }
        }catch(Exception e){
            System.out.println(e.getMessage());
            this.error=e.getMessage();
        }
        return datos;
    }
    public String activarCuenta(String token){
        String activacion="";
        ResultSet rsActiv=null;
        try{
            for(int i = 0; i < 4; i++){
                BD.cDatos sql=new BD.cDatos(i);
                sql.conectar();
                rsActiv=sql.consulta("call _activarCuenta('"+token+"');");
                if(rsActiv.next())
                {
                    activacion=rsActiv.getString("Activacion")+"|"+rsActiv.getString("corr")+"||"+rsActiv.getString("clav");
                    String xStr=activacion.substring(0,activacion.indexOf("|"));
                    if(!xStr.equals("Cuenta activada"))
                    {
                        activacion="No se encontro la cuenta";
                    }
                }
                sql.cierraConexion();
            }
        }catch(Exception e)
        {
            this.error=e.getMessage();
        }
        return activacion;
    }
    public String mandaMailRecup(String destino,String titulo,String token){
        boolean envio=false;
        Clases.cMail env=new Clases.cMail();
        String link="http://localhost:8080/Synth_BLOG/jsp/activacion.jsp";
        env.setPara(destino);
        env.setCuerpoMsj("Para finalizar la recuperacion de tu cuenta debes"
                + " volver a activarla introduciendo este token: \n"
                +  token+" en la siguiente pagina: \n"
                + link +" \n Atte:Equipo Marsoft");
        if(!env.mandaMail(titulo))
            this.error="Error al enviar mail";
        else
            this.error="Recuperacion existosa, revisa tu correo para terminar"
                    + " el proceso de recuperacion";
        return this.error;
    }
    public String mandaMailConfirm(String destino,String titulo)
    {
        boolean envio=false;
        Clases.cMail env=new Clases.cMail();
        Clases.cMD5 cif=new Clases.cMD5();
        String link="http://localhost:8080/Synth_BLOG/jsp/activacion.jsp";
        String token=cif.getStringMessageDigest(destino,"MD5");
        env.setPara(destino);
        env.setCuerpoMsj("Gracias por registrarte,para activar tu cuenta"
                + " y poder usarla ingresa al siguiente link: \n "+link+" \n E ingresa"
                + " este Token:\n"+token);
        if(!env.mandaMail(titulo))
            this.error="Error al enviar mail, se intentará más tarde.";
        else
            this.error="Registro exitoso,revisa tu correo" +            
                    "para confirmar tu cuenta de lo contrario," +
                     "no podrás acceder al blog";
        
        return this.error;
    }
    public String[] getTeoria(){
        ArrayList<String> src = new ArrayList<>();
        String elemento = "";
        ResultSet gatito = null;
        BD.cDatos sql = new BD.cDatos(bd);
        int cont = 0;
        try{
            sql.conectar();
            gatito = sql.consulta("call _obtenTeoria(-1);");
            while(gatito.next()){
                elemento += gatito.getString(bd==1?"idTeo":"idTeoria") + "/";
                elemento += gatito.getString(bd==1?"fec":"fecha") + "/";
                elemento += gatito.getString(bd==1?"numConsul":"numConsultas") + "/";
                elemento += gatito.getString(bd==1?"titu":"titulo") + "/";
                elemento += gatito.getString(bd==1?"descrip":"descripcion") + "/";
                elemento += gatito.getString(bd==1?"cuer":"cuerpo");
                src.add(elemento);
                elemento = "";
                cont++;
            }
        }catch(Exception e){
            this.error = "at cLogica.getTeoria: " + e.getMessage();
        }
        return src.toArray(new String[cont]);
    }
    public String registraTeoria(String titulo, String descripcion, String cuerpo){
        ResultSet gatito = null;
        String msj = "";
        String idT = "";
        BD.cDatos sql = new BD.cDatos(bd);
        try{
            sql.conectar();
            gatito = sql.consulta("call _subirTeoria('"+titulo+"','"+descripcion+"','"+cuerpo+"')");
            if(gatito.next()){
                msj = gatito.getString("msj");
                idT = gatito.getString("idT");
                msj = msj + "/" + idT;
            }
        }catch(Exception e){
            msj = "at cLogica.getTeoria: " + e.getMessage();
        }
        return msj;
    }
    public String registraContenidoT(String idT, String ruta, String cabecera){
        String msj = "";
        ResultSet gatito = null;
        BD.cDatos sql = new BD.cDatos(bd);
        try{
            sql.conectar();
            gatito = sql.consulta("call _registraContenido('"+idT+"','"+ruta+"','"+cabecera+"','1')");
            if(gatito.next()){
                msj = gatito.getString("msj");
            }
        }catch(Exception e){
           this.error = "at cLogica.registraContenidoT: " + e.getMessage();
        }
        return msj;
    }
    public String busquedaGeneral(String paramBsq)
    {
        ResultSet rsBsq=null;
        BD.cDatos sql=new BD.cDatos(bd);
        int totalResults=0;
        String []arrIds=null;
        String []arrNombres=null;
        String []arrTipos=null;
        String []arrDes=null;
        int i=0;
        int totalUs=0;
        int totalArt=0;
        JsonObject results=new JsonObject();
        Gson s=new Gson();   
        try
        {
            sql.conectar();
            rsBsq= sql.consulta("call _buscar('"+paramBsq+"');");
            rsBsq.last();
            totalResults=rsBsq.getRow();
            rsBsq.beforeFirst();
            arrIds=new String [totalResults];
            arrNombres=new String [totalResults];
            arrTipos =new String [totalResults];
            arrDes=new String [totalResults];
            while(rsBsq.next())
            {
                arrIds[i]=rsBsq.getString("registro");
                arrNombres[i]=rsBsq.getString("nombre");
                arrTipos[i]=rsBsq.getString("tipoResultado");
                arrDes[i]=rsBsq.getString("texto");
                if(arrTipos[i].equals("Usuario"))
                    totalUs+=1;
                else
                  if(arrTipos[i].equals("Articulo"))
                    totalArt+=1;
                i++;
            }
            results.addProperty("total",totalResults);
            results.addProperty("Usuarios",totalUs);
            results.addProperty("Articulos", totalArt);
            results.add("registros",s.toJsonTree(arrIds));
            results.add("nombres", s.toJsonTree(arrNombres));
            results.add("tipos",s.toJsonTree(arrTipos));
            results.add("descripciones",s.toJsonTree(arrDes));
        }catch(Exception e)
        {
            this.error=e.getMessage();
            System.out.println(error);
        }
        return results.toString();
    }
}
