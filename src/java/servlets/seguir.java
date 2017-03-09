/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author BEAR
 */
@WebServlet(name = "seguir", urlPatterns = {"/seguir"})
public class seguir extends HttpServlet {

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
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet seguir</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet seguir at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        JsonObject resp = new JsonObject();
        try{
            String bd = request.getParameter("bd") == null ? "" : request.getParameter("bd");
            String id = request.getParameter("id") == null ? "" : request.getParameter("id");
            String ids = request.getParameter("ids") == null ? "" : request.getParameter("ids");
            System.out.println(bd + "-" + id + "-" + ids);
            if(bd.isEmpty() || id.isEmpty() || ids.isEmpty()){
                throw new Exception("problemas con el servidor. Intentalo mas tarde");
            }
            if(id.equals(ids)){
                throw new Exception("W::No puedes seguirte a ti mismo");
            }
            new ldn.cInicio(Integer.parseInt(bd)).registraSeguidor(id,ids);
            resp.addProperty("msg", "Exito");
            resp.addProperty("status","OK");
        }catch(Exception e){
            if(e.getMessage().startsWith("W::")){
                resp.addProperty("msg", e.getMessage().substring(3));
                resp.addProperty("status","WARNING");
            }else{
                resp.addProperty("msg", e.getMessage());
                resp.addProperty("status","ERROR");
            }
        }
        PrintWriter out = response.getWriter();
        out.print(resp.toString());
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
