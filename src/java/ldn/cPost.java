/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldn;

import java.sql.ResultSet;
import java.util.ArrayList;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @author Bear
 */
public class cPost {
    private String error;
    private int bd;
    private int idP;
    public cPost(int bd){
        this.bd = bd;
        this.idP = 0;
        error = "";
    }
    public String[] obtenCategorias(){
        String src = "";
        ResultSet gatito = null;
        BD.cDatos sql = new BD.cDatos(bd);
        try{
            sql.conectar();
            gatito = sql.consulta("call _obtenCategorias()");
            while(gatito.next()){
                if(src.equals("")){
                    src = gatito.getString("descripion");
                }else{
                    src += "/" + gatito.getString("descripion");
                }
            }
        }catch(Exception e){
            this.error = "ERROR DEL SERVIDOR:" + e.getMessage();
            System.out.println(error);
        }
        System.out.println(src);
        return src.split("/");
    }
    public String nuevoPost(int id, int categoria, String titulo, String descripcion) throws Exception{
        String msj = "";
        ResultSet gatito = null;
        BD.cDatos sql = new BD.cDatos(bd);
            sql.conectar();
            gatito = sql.consulta("call _nuevoPost('"+id+"','"+categoria+"','"+titulo+"','"+descripcion+"')");
            if(gatito.next()){
                msj = gatito.getString("msj");
                this.idP = Integer.parseInt(gatito.getString("idP"));
            }
        return msj;
    }
    public String registraContenidoP(String idP, String ruta, String cabecera) throws Exception{
        String msj = "";
        ResultSet gatito = null;
        BD.cDatos sql = new BD.cDatos(bd);
            sql.conectar();
            gatito = sql.consulta("call _registraContenido('"+idP+"','"+ruta+"','"+cabecera+"','2')");
            if(gatito.next()){
                msj = gatito.getString("msj");
            }
        return msj;
    }
    
    private final int IMAGEN = 1;
    private final int AUDIO = 2;
    public String[] obtenPost(int idC){
        ArrayList<String> src = new ArrayList<>();
        BD.cDatos sql = new BD.cDatos(bd);
        ResultSet gatito = null;
        try{
            sql.conectar();
            gatito = sql.consulta("call _obtenPost('"+idC+"');");
            while(gatito.next()){
                String row = "";
                row += "<div class=\"container\" data-regPost="+gatito.getString("idPost")+" >";
                row+="<span id='spName'>"+gatito.getString("usuario")+"</span><br />";
                row+="<span id='spDate'>"+gatito.getString("fecha")+"</span><br />";
                row += "<img id=\"imgUsr\" src=\""+gatito.getString("foto")+" \"><br />"; 
                
                row+="<span id='spTit' >Tit:"+gatito.getString("titulo")+"</span><br /><br /><span id='spCateg'>Categoria: "+gatito.getString("interes")+"</span>";
                if(!empty(gatito.getString("imagenpost")))row += "<img id='imgPost' src=\""+gatito.getString("imagenpost")+"\" width=\"200\" height=\"200\"><br /><span id='cabImg' >Imagen: "+gatito.getString("cabeceraimagenpost")+"</span>";
                row += "<span id='contPost'>"+gatito.getString("texto").replace("<","&lt;").replace(">","&gt;")+"</span><br />";
               
                if(!empty(gatito.getString("audiopost")))row += "<span id='cabAudio'>" + gatito.getString("cabeceraaudiopost") + "</span><a id='audio' href=\""+gatito.getString("audiopost")+" download=\""+FilenameUtils.getName(gatito.getString("cabeceraaudiopost"))+"\"><button>Descargar</button></a>";
                row +="</div><br /><br />";
                src.add(row);
            }
        }catch(Exception e){
            this.error = e.getMessage();
        }
        return src.toArray(new String[src.size()]);
    }
    public boolean empty(String a){
        if(a == null || a.isEmpty() || a.equals("null")){
            return true;
        }else return false;
    }
    public String getError() {
        return error;
    }

    public int getIdP() {
        return idP;
    }
}
