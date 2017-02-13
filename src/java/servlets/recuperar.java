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
@WebServlet(name = "recuperar", urlPatterns = {"/recuperar"})
public class recuperar extends HttpServlet {

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
            Clases.cCifrado cred=new Clases.cCifrado();
            String paso=request.getParameter("peticion")==null?"":request.getParameter("peticion");
            String correoC=request.getParameter("correoC")==null?"":request.getParameter("correoC");
            String correoR=request.getParameter("correoR")==null?"":request.getParameter("correoR");
            String nvaClav=request.getParameter("claveRecuperacion")==null?"":request.getParameter("claveRecuperacion");
            if(correoR.equals("")||correoC.equals("")||paso.equals("")||nvaClav.equals(""))
            {
                out.print("Datos vacios o faltantes");
            }else{
                if(paso.equals("0")){
                    ldn.cValida validacion=new ldn.cValida();
                    if(validacion.correoValido(correoC) && validacion.correoValido(correoR))
                    {
                        ldn.cLogica recup=new ldn.cLogica(0);
                        String valido=recup.validarRecuperacion(correoC, correoR);
                        if(!valido.equals("") && !validacion.tieneEspeciales(nvaClav))
                        {
                            String token=recup.recuperarCuenta(correoC, correoR, nvaClav);
                            if(token.equals(""))
                                out.write("Algo salió mal... inténtalo de nuevo.");
                            else{
                                
                                out.print(recup.mandaMailRecup(correoC,"Recuperacion de cuenta",token));
                                correoC=cred.Encriptar(correoC);
                                nvaClav=cred.Encriptar(nvaClav);
                                correoR="4"+correoC+"|"+nvaClav;
                                System.out.println(cred.pedirClave(correoR));
                            }
                        }else
                            out.print("No hay usuario con esos correos");
                    }else
                        out.print("Correos no validos");
                }
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
