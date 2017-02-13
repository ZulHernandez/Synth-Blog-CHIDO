/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldn;

import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author Bear
 */
public class cPost {
    private String error;
    private int bd;
    private int idP;
	
	private final int IMAGEN = 1;
	private final int AUDIO = 2;
public String[] obtenPost(int idC){
    ArrayList<String> src = new ArrayList<>();
    int count = 0;
    String row = "";
	int tipocon = 0;
    BD.cDatos sql = new BD.cDatos(bd);
    ResultSet gatito = null;
    try{
        sql.conectar();
        gatito = sql.consulta("call _obtenPost('"+idC+"');");
        while(gatito.next()){
            System.out.println("se detecto registro!!!");
			if(!row.equals("") && row.substring(4,5) == gatito.getString("idPost")){
				if(gatito.getString("contenido").indexOf("/img/") > 0)
					row = row.replace("AQUIVAELCONTENIDO","<p><img src=\""+gatito.getString("contenido")+"\" width=\"150\" height=\"150\" ALIGN=LEFT>"+gatito.getString("cabecera")+"</p>");
				else
					row = row.replace("AQUIVAELCONTENIDO","<p>" + gatito.getString("cabecera") + "</p><a href=\""+gatito.getString("contenido")+" download=\"audio\"\"><button>DESCARGA EL AUDIO</button></a>");
				src.set(0,row);
			}else{
				if(gatito.getString("contenido").indexOf("/img/") > 0)
					tipocon = IMAGEN;
				else
					tipocon = AUDIO;
				row = "<!--"+gatito.getString("idPost")+"-->><div class=\"container\"><table border=\"5\" cellspacing=\"15\" width=\"100%\"><tr>";
				row += "<td colspan=\"2\"><img id=\"lafoto\" src=\""+gatito.getString("foto")+"\" width=\"70\" height=\"70\">&nbsp;&nbsp;<h2>"+gatito.getString("usuario")+"&nbsp;"+gatito.getString("fecha")+" </h2></td>";
				row += "</tr><tr><td><table border=\"5\" cellspacing=\"7\" width=\"100%\" style=\"background-color: white; color: black;\"><tr>";
				row += "<td>Publicacion<br>"+(tipocon == AUDIO ? "AQUIVAELCONTENIDO" : (gatito.getString("contenido") == null ? "" : "<p><img src=\""+gatito.getString("contenido")+"\" width=\"150\" height=\"150\" ALIGN=LEFT>"+gatito.getString("cabecera")+"</p>"))+"</td>";
				row += "<td>"+gatito.getString("texto").replace("<","&lt;").replace(">","&gt;")+"</td></tr></table></td>";
				row += "<td><p><h2>"+gatito.getString("titulo")+"</h2></p><br><p>Categoria: "+gatito.getString("descripion")+"</p>"+(tipocon == IMAGEN ? "AQUIVAELCONTENIDO" : (gatito.getString("contenido") == null ? "" : "<p>" + gatito.getString("cabecera") + "</p><a href=\""+gatito.getString("contenido")+" download=\"audio\"\"><button>DESCARGA EL AUDIO</button></a>"))+"</td>";
				row += "</tr>";
				row += "</table>";
                                System.out.println(row);
				src.add(0,row);
				count++;
			}
        }
    }catch(Exception e){
        this.error = e.getMessage();
        System.out.println(e.getMessage());
    }
    return src.toArray(new String[count]);
}
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
    public String nuevoPost(int id, int categoria, String titulo, String descripcion){
        String msj = "";
        ResultSet gatito = null;
        BD.cDatos sql = new BD.cDatos(bd);
        try{
            sql.conectar();
            gatito = sql.consulta("call _nuevoPost('"+id+"','"+categoria+"','"+titulo+"','"+descripcion+"')");
            if(gatito.next()){
                msj = gatito.getString("msj");
                this.idP = Integer.parseInt(gatito.getString("idP"));
            }
        }catch(Exception e){
            this.error = e.getMessage();
        }
        return msj;
    }
    public String registraContenidoP(String idP, String ruta, String cabecera){
        String msj = "";
        ResultSet gatito = null;
        BD.cDatos sql = new BD.cDatos(bd);
        try{
            sql.conectar();
            gatito = sql.consulta("call _registraContenido('"+idP+"','"+ruta+"','"+cabecera+"','2')");
            if(gatito.next()){
                msj = gatito.getString("msj");
            }
        }catch(Exception e){
           this.error = e.getMessage();
        }
        return msj;
    }
    
    public String getError() {
        return error;
    }

    public int getIdP() {
        return idP;
    }
}
