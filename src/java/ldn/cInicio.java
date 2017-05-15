/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldn;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @author BEAR
 */
public class cInicio {
    private int bd;
    private String error;
    private Integer[] seguidos;
    public cInicio(int bd){
        this.bd = bd;
        this.error = "";
    }
    public boolean empty(String a){
        if(a == null || a.isEmpty() || a.equals("null")){
            return true;
        }else return false;
    }
    
    //Trae post para el muro
    public String traePostInicio(int id){
        String src = "";
        BD.cDatos sql = new BD.cDatos(bd);
        try{
            sql.conectar();
            ResultSet gatito = sql.consulta("call _traepostinicio("+id+");");
            while(gatito.next()){
                 src += "<div class=\"container \" data-regis='"+gatito.getString("idCuenta")+"'>";
                    //src += "<div>";
                       
                           
                                src += "<span id='spName' onclick='verPerfil(this)' >"+gatito.getString("usuario")+"</span><br /><br />";
                                src+= "<span id='spDate'>"+gatito.getString("fecha")+"</span><br />";
                                src += /*<span id='imgSrc'>*/"<img id='imgUsr' src=\""+gatito.getString("foto")+"\" ><br />";
                                src += "<span id='spCateg'>Categoría: "+gatito.getString("interes")+"</span>";
                                
                       
                         
                                src += "<span id='spTit'>"+gatito.getString("titulo")+"</span><br />";
                                src += "<span id='contPost'>"+gatito.getString("texto")+"</span><br />";
                                if(!reformat(gatito.getString("imagenpost")).isEmpty())src += "<img id='imgPost' width=200 height=200 src=\""+gatito.getString("imagenpost")+"\" ><br /><span id='cabImg'>"+gatito.getString("cabeceraimagenpost")+"</span><br />"; //+gatito.getString("cabeceraaudiopost")+
                                
                                if(!reformat(gatito.getString("audiopost")).isEmpty())src += "<span id='cabAudio'>" + gatito.getString("cabeceraaudiopost") + "</span><br /><a id='audio' href=\""+gatito.getString("audiopost")+"\" download=\""+FilenameUtils.getName(gatito.getString("cabeceraaudiopost"))+"\"><button  class='seguir' >Descargar archivo</button></a>";
                                //src += "<br /><button id='verPerfil' class='seguir' onclick='verPerfil(this)' >Ver perfil</button>";
                                
                                src += "</div><br /><br />";
            }
        }catch(Exception e){
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            this.error = sw.toString();
        }
        return src;
    }
    public boolean esSeguido(int id, int ids) throws Exception{
        if(seguidos == null){
            ArrayList<Integer> list = new ArrayList<>();
            BD.cDatos sql = new BD.cDatos(bd);
            sql.conectar();
            ResultSet gatito = sql.consulta("call _obtenlistaseguidos("+id+");");
            while(gatito.next()){
                list.add(gatito.getInt("idCuenta"));
            }
            seguidos = list.toArray(new Integer[list.size()]);
        }
        if(seguidos.length == 0) return false;
        else for(int i = 0; i < seguidos.length; i++)if(seguidos[i] == ids)return true;
        return false;
    }
    public void registraSeguidor(String id, String ids) throws Exception{
        BD.cDatos sql = new BD.cDatos(bd);
        sql.conectar();
        sql.actualizar("call _registraSeguidor("+id+","+ids+");");
    }
    public String getError(){
        return this.error;
    }
    public String reformat(String t){
        if(  t == null || t.isEmpty() || t.equals("null")){
            return "";
        }else{
            return t;
        }
    }
}
