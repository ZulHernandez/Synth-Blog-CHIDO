/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldn;

import java.sql.ResultSet;

/**
 *
 * @author Bear
 */
public class cTeoria {
    private int bd;
    private String error;
    public cTeoria(int bd){
        this.bd = bd;
        this.error = "";
    }
    public String getTeoria1(int idT){
        BD.cDatos sql = new BD.cDatos(this.bd);
        ResultSet gatito = null;
        String src = "<div class=\"container\">";
        String con = "";
        try{
            sql.conectar();
            gatito = sql.consulta("call _obtenTeoria("+idT+")");
            if(gatito.next()){
                src += "<center><h1>"+gatito.getString(bd==1?"titu":"titulo")+"</h1></center><br>";
                src += "<div class=\"header\">"+gatito.getString(bd==1?"descrip":"descripcion")+"</div><br>";
                src += "<div class=\"part\">aqui va a estar el contenido</div><br>";
                src += "<div class=\"content\">"+gatito.getString(bd==1?"cuer":"cuerpo")+"</div><br>";
                src += "<div class=\"footer\">("+gatito.getString(bd==1?"fec":"fecha")+") Veces consultado: "+gatito.getString(bd==1?"numConsul":"numConsultas")+"</div>";
            }
            gatito = sql.consulta("call _obtenContenido("+idT+")");
            while(gatito.next()){
                con += "<center><img src=\""+gatito.getString(bd==1?"conten":"contenido")+"\" width=\"50%\" height=\"50%\"><br><i>"+gatito.getString(bd==1?"cabe":"cabeceraC")+"</i></center>";
            }
            src = src.replace("aqui va a estar el contenido", con);
        }catch(Exception e){
            this.error = e.getMessage();
        }
        src += "</div>";
        return src;
    }
    public String getError(){
        return this.error;
    }
}
