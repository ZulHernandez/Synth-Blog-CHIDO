/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import com.google.gson.JsonObject;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author Bear
 */
@WebServlet(name = "teoria", urlPatterns = {"/teoria"})
@MultipartConfig
public class teoria extends HttpServlet {
    private ldn.cLogica gatito;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            try{
                int peticion = request.getParameter("tipo")==null ? -1 : Integer.parseInt(request.getParameter("tipo"));
                int db = request.getParameter("bd")==null ? -1 : Integer.parseInt(request.getParameter("bd"));
                if(db == -1) throw new Exception("Problemas con la base de datos. Intentalo mas tarde");
                gatito = new ldn.cLogica(db);
                if(peticion == 0){
                    //obtener teoria
                    String[] values = gatito.getTeoria();
                    if(!gatito.getError().equals("")) throw new Exception(gatito.getError());
                    String[] keys = gatito.iniArray(values.length);
                    JsonObject teoria = gatito.perfilToJson(keys, values);
                    System.out.println(teoria.toString());
                    out.print(teoria.toString());
                }else
                if(peticion == 1){
                    //registrar teoria
                    String titulo = request.getParameter("titulo") == null ? "" : request.getParameter("titulo");
                    String descripcion = request.getParameter("descripcion") == null ? "" : request.getParameter("descripcion");
                    String cuerpo = request.getParameter("cuerpo") == null ? "" : request.getParameter("cuerpo");
                    Part contenido = request.getPart("contenido");
                    String cabecera = request.getParameter("cabecera") == null ? "" : request.getParameter("cabecera");
                    //datos vacios = exception
                    if(titulo.equals("") || descripcion.equals("") || cuerpo.equals("")) throw new Exception("Titulo,Descripcion o cuerpo vacíos.");
                    if(contenido==null && !cabecera.equals("")) throw new Exception("Para subir una cabecera debe subir una imagen también.");
                    if(contenido!=null && cabecera.equals(""))throw new Exception("Para subir una imagen debe agregarle una cabecera");
                    if(contenido !=null && contenido.getContentType().equals("application/octet-stream"))throw new Exception("Error: Formato de imagen incorrecto");
                    String msj = gatito.registraTeoria(titulo, descripcion, cuerpo);
                    //error al subir teoria = exception
                    if(msj.startsWith("at")) throw new Exception(msj);
                    String[] datas = msj.split("/");
                    if(contenido !=null){

                        //no hay cabecera = no pierdas el tiempo
                        if(cabecera.equals("")) throw new Exception(" No se encuentra la cabecera de la imagen");
                        InputStream isimagen = contenido.getInputStream();
                        
                        URL rutaca = getClass().getProtectionDomain().getCodeSource().getLocation(); // traigo dirreccion
                        String rutama = rutaca.toString();
                        String newruta = rutama.substring(5,rutama.length());
                        String newnewruta = newruta.substring(0,newruta.length()-38);
                        String absolute = newnewruta.replace("%20"," ");
                        
                        File destinoimagen = new File(absolute + "/contenido");
                        if(!destinoimagen.exists()){
                            destinoimagen.mkdirs();
                        }
                        File[] ficherosimagen = destinoimagen.listFiles();
                        int numimagen = ficherosimagen.length + 1;
                        File fimagen = new File(destinoimagen + "/imagen" + numimagen + ".jpg");
                        System.out.println(fimagen);
                        String xrutaimagen = "/Synth_BLOG/contenido/imagen" + numimagen + ".jpg";
                        String rutaimagen = xrutaimagen.replace("\\","\\\\");
                        FileOutputStream outimagen = new FileOutputStream(fimagen);
                        int dataimagen = isimagen.read();
                        while(dataimagen != -1){
                            outimagen.write(dataimagen);
                            dataimagen = isimagen.read();
                        }
                        isimagen.close();
                        outimagen.close();
                        msj = gatito.registraContenidoT(datas[1],rutaimagen,cabecera);
                        System.out.println("BD: "+msj);
                        //error al registrar contenido = exception
                        if(!gatito.getError().equals("")) throw new Exception(gatito.getError());
                    }
                    //si todo sale bien = notificacion
                    out.print("Registro de teoria exitoso");
                }else
                if(peticion == -1) throw new Exception("Peticion incorrecta. Intentalo de nuevo");
            }catch(Exception e){
                System.out.println(e);
                out.print("Error: " + e.getMessage());
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
