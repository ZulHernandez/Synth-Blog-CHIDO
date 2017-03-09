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
    public String traePostInicio(int id){
        String src = "";
        BD.cDatos sql = new BD.cDatos(bd);
        try{
            sql.conectar();
            ResultSet gatito = sql.consulta("call _traepostinicio("+id+");");
            while(gatito.next()){
                 src += "<div class=\"container containerPub\" data-regis='"+gatito.getString("idCuenta")+"'>";
                    src += "<div>";
                       
                           
                                src += "<span id='spName'>Usuario: "+gatito.getString("usuario")+"</span><br /><br />";
                                src += "<span id='imgSrc'><img src=\""+gatito.getString("foto")+"\" width=\"50\" height=\"50\"></span><br /><br />";
                                src += "<span id='spInte'>Interes: "+gatito.getString("interes")+"</span><br /><br />";
                                
                       
                         
                                src += "<span id='spTit'>"+gatito.getString("titulo")+"</span><br /><br />";
                                src += "<span id='spTxt'>"+gatito.getString("texto")+"</span><br />";
                                if(!reformat(gatito.getString("imagenpost")).isEmpty())src += "<div class=\"apart\"><img width=10% height=10% src=\""+gatito.getString("imagenpost")+"\"><br /><span id='spCab'>"+gatito.getString("cabeceraimagenpost")+"</span></div><br />"; //+gatito.getString("cabeceraaudiopost")+
                                
                                if(!reformat(gatito.getString("audiopost")).isEmpty())src += "<div class=\"apart\"><a id='audio' href=\""+gatito.getString("audiopost")+"\" download=\""+FilenameUtils.getName(gatito.getString("audiopost"))+"\"><button id='cabAudio' class='seguir' >Descargar archivo adjunto</button></div></a></br>";
                                src += "<button id='verPerfil' class='seguir' onclick='verPerfil(this)' >Ver perfil</button>";
                                
                                src += "</div></div><br /><br />";
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
