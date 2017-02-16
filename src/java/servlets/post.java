/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @author Daniel Castillo
 */
@WebServlet(name = "post", urlPatterns = {"/post"})
@MultipartConfig
public class post extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        JsonObject resp = new JsonObject();
        try{
            String tipo = request.getParameter("tipo") == null ? "" : request.getParameter("tipo");
            String titulo = request.getParameter("titulo") == null ? "" : request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion") == null ? "" : request.getParameter("descripcion");
            int categoria = request.getParameter("categoria") == null ? -1 : Integer.parseInt(request.getParameter("categoria"));
            
            //Si los campos estan vacios: error de validacion
            if(tipo.equals("") || titulo.equals("") || descripcion.equals("") || categoria == -1){
                throw new Exception("W::No puedes dejar campos vacios. Intentalo nuevamente");
            }
            
            Part imagen = request.getPart("contenido");
            Part audio = request.getPart("audio");
            String cabeceraI = "";
            String cabeceraA = "";
            
            boolean siimagen = false;
            if(imagen != null && !imagen.getContentType().equals("application/octet-stream")){
                cabeceraI = request.getParameter("cabeceraI") == null ? "" : request.getParameter("cabeceraI");
                if(cabeceraI.equals(""))throw new Exception("W::tu imagen no tiene cabecera. Agregale una antes de enviar los datos");
                else siimagen = true;
            }
            boolean siaudio = false;
            if(audio != null && !audio.getContentType().equals("application/octet-stream")){
                cabeceraA = request.getParameter("cabeceraA") == null ? "" : request.getParameter("cabeceraA");
                if(cabeceraA.equals(""))throw new Exception("W::tu archivo no tiene cabecera. Agregale uno antes de enviar los datos");
                else siaudio = true;
            }
            
            HttpSession ss = request.getSession();
            int db = ss.getAttribute("bd") == null ? -1 : Integer.parseInt(ss.getAttribute("bd").toString());
            int id = ss.getAttribute("id") == null ? -1 : Integer.parseInt(ss.getAttribute("id").toString());
            if(db == -1 || id == -1) throw new Exception("Problemas con la base de datos. Por favor, intentalo mas tarde");
            
            ldn.cPost post = new ldn.cPost(db);
            String msg = post.nuevoPost(id,categoria,titulo,descripcion);
            if(post.getIdP() == -1) throw new Exception(msg);
            //msg se manda como error si idP = -1
            
            String result = "";
            if(siimagen){
                String extension = FilenameUtils.getExtension(imagen.getSubmittedFileName());
                result = Clases.Utilities.saveFile(imagen, "imagenPost", "imagen", "." + extension);
                if(result.startsWith("/")) result = post.registraContenidoP(Integer.toString(post.getIdP()),result,cabeceraI);
                else throw new Exception(result);
                msg += "\n" + result;
            }
            if(siaudio){
                String extension = FilenameUtils.getExtension(audio.getSubmittedFileName());
                result = Clases.Utilities.saveFile(audio, "audioPost", "audio", "." + extension);
                if(result.startsWith("/")) result = post.registraContenidoP(Integer.toString(post.getIdP()),result,cabeceraA);
                else throw new Exception(result);
                msg += "\n" + result;
            }
            resp.addProperty("status", "OK");
            resp.addProperty("msg",msg);
        }catch(Exception e){
            if(e.getMessage().startsWith("W::")){
                resp.addProperty("status", "WARNING");
                resp.addProperty("msg",e.getMessage().substring(3));
            }else{
                resp.addProperty("status", "ERROR");
                resp.addProperty("msg",e.getMessage());
            }
        }
        out.print(resp.toString());
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
