/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Saul
 */
@WebServlet(name = "estadisticas", urlPatterns = {"/estadisticas"})
public class estadisticas extends HttpServlet {

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
            
            String tipoEstadistica=request.getParameter("consulta")==null?"":request.getParameter("consulta");
            String serverResponse="";
            if(!tipoEstadistica.equals(""))
            {
                switch(tipoEstadistica)
                {
                    
                    case "1"://Datos para la gráfica 'lo más posteado'
                       serverResponse=interesesMasPosteados();
                        break;
                    case "2"://Artículos más consultados
                        serverResponse=articulosMasConsultados();
                        break;
                    default :
                        serverResponse="Peticion no reconocida";
                        break;
                }
                out.write(serverResponse);
            }else
                out.write("Petición no disponible");
        }
    }
    
    //Método que hace la consulta para traer los intereses más posteados
    private String interesesMasPosteados()
    {
        String resultado="";
        ldn.cLogica consulta=new ldn.cLogica();
        resultado=consulta.traerInteresesMasPosteados();
        return resultado;
    }
    
    //Aquí se genera la consulta para traer los 5 artículos de teoría más
    //consultados
    private String articulosMasConsultados()
    {
        String resultado="";
        ldn.cLogica consulta=new ldn.cLogica();
        resultado=consulta.traerArtMasConsultados();
        return resultado;
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
