/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldn;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.ResultSet;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @author BEAR
 */
public class cInicio {
    private int bd;
    private String error;
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
                src += "<div class=\"container\">";
                    src += "<div>";
                       
                           
                                src += "<span id='spName'>Usuario: "+gatito.getString("usuario")+"</span><br /><br />";
                                src += "<span id='imgSrc'><img src=\""+gatito.getString("foto")+"\" width=\"50\" height=\"50\"></span><br /><br />";
                                src += "<span id='spInte'>Interes: "+gatito.getString("interes")+"</span><br /><br />";
                                
                       
                         
                                src += "<span id='spTit'>"+gatito.getString("titulo")+"</span><br /><br />";
                                src += "<span id='spTxt'>"+gatito.getString("texto")+"</span>";
                                if(!reformat(gatito.getString("imagenpost")).isEmpty())src += "<div class=\"apart\"><img width=10% height=10% src=\""+gatito.getString("imagenpost")+"\"><br /><span id='spCab'>"+gatito.getString("cabeceraimagenpost")+"</span></div>";
                                
                                if(!reformat(gatito.getString("audiopost")).isEmpty())src += "<div class=\"apart\"><a id='audio' href=\""+gatito.getString("audiopost")+"\" download=\""+FilenameUtils.getName(gatito.getString("audiopost"))+"\"><button id='cabAudio'>"+gatito.getString("cabeceraaudiopost")+"</button></a></div>";
                                src += "<button id=\"boto\">Seguir</button>";
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
