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
import javax.servlet.http.HttpSession;

/**
 *
 * @author Daniel Castillo
 */
@WebServlet(name = "login", urlPatterns = {"/login"})
public class login extends HttpServlet {
    private String src = "";
    private String message = "";
    private int error = 0;
    private ldn.cLogica gatito = new ldn.cLogica();
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
            createSrc();
            out.println(this.src);
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
        String correo = request.getParameter("correo") == null ? "" : request.getParameter("correo");
        String contra = request.getParameter("contra") == null ? "" : request.getParameter("contra");
        String base = request.getParameter("base") == null ? "" : request.getParameter("base");
        if(correo.equals("") || contra.equals("") || base.equals("")){
            processRequest(request, response);
        }else{
            try{
                Clases.cCifrado credenciales=new Clases.cCifrado();
                String xUsr=credenciales.Encriptar(correo);
                String xPsw=credenciales.Encriptar(contra);
                String datos="1"+xUsr+"|"+xPsw;
                if(credenciales.pedirClave(datos).length()>1){
                    //System.out.println("Si llegó!");
                    this.error=2;
                    processRequest(request,response);
                }
                int bd = Integer.parseInt(base);
                System.out.println(bd);
                gatito = new ldn.cLogica(bd);
                int id = gatito.getLogin(correo, contra);
                if(!gatito.getError().equals("")){
                    this.error = 3;
                    processRequest(request, response);
                }else{
                    if(id == 0){
                        this.error = 2;
                        processRequest(request, response);
                    }else{
                        if(id==404){
                            this.error=4;
                            processRequest(request, response);
                        }else{
                            HttpSession ss = request.getSession();
                            ss.setAttribute("id", id);
                            ss.setAttribute("bd", bd);
                            ss.setAttribute("usuario", gatito.getUsuario());
                            ss.setAttribute("tipous",gatito.getTipous());
                            response.sendRedirect("blog.jsp");
                        }
                    }
                }
            }catch(Exception e){
                System.out.println(e.getMessage());
                processRequest(request, response);
            }
        }
    }
    public void createSrc(){
        if(this.error == 0){
            message = "";
        }else
        if(this.error == 1){
            //datos vacios...
            message = "<div id=\"alerta\" name=\"alerta\" style=\"display: block; padding: 15px; background-color: rgba(232,27,38,0.5)\">" +
                      "<center>DATOS ENVIADOS NO PUEDEN SER VACIOS</center>" +
                      "</div>";
        }else
        if(this.error == 2){
            //no existe cuenta...
            message = "<div id=\"alerta\" name=\"alerta\" style=\"display: block; padding: 15px; background-color: rgba(232,27,38,0.5)\">" +
                      "<center>CORREO O CONTRASEÑA INCORRECTOS.\n (Asegúrate de haber activado tu cuenta)</center>" +
                      "</div>";
        }else
        if(this.error == 3){
            //error del servidor...
            message = "<div id=\"alerta\" name=\"alerta\" style=\"display: block; padding: 15px; background-color: rgba(232,27,38,0.5)\">" +
                      "<center>ERROR DEL SERVIDOR: "+gatito.getError()+" </center>" +
                      "</div>";
        }else
         if(this.error==4){
                //cuenta no activada
                message = "<div id=\"alerta\" name=\"alerta\" style=\"display: block; padding: 15px; background-color: rgba(232,27,38,0.5)\">" +
                      "<center>INGRESA A TU CORREO PARA ACTIVAR TU CUENTA Y PODER INGRESAR.</center>" +
                      "</div>";
            }
        src = "<!doctype html>\n" +
            "<html>\n" +
            "    <head>\n" +
            "        <title>Sytnh!WebCommunity</title>\n" +
            "        <script type=\"text/javascript\" src=\"scripts/login.js\"></script>\n" +
            "        <script src=\"css/sweetalert-master/dist/sweetalert.min.js\" type=\"text/javascript\"></script>\n" +
            "        <link href=\"css/sweetalert-master/dist/sweetalert.css\" rel=\"stylesheet\" type=\"text/css\"/>\n" +
            "        <link rel=\"stylesheet\" href=\"css/material.min.css\">\n" +
            "        <script src=\"css/material.min.js\"></script>\n" +
            "        <link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/icon?family=Material+Icons\">\n" +
            "        <link href=\"css/login.css\" rel=\"stylesheet\" type=\"text/css\"/>\n" +
            "        <link rel=\"icon\" type=\"image/png\" href=\"imgs/sico.ico\"/>\n" +
            "        <link href=\"styles/login.css\" rel=\"stylesheet\" type=\"text/css\"/>\n" +
            "    </head>\n" +
            "    <body>\n" +
            "        <div id=\"todo\">\n" +
            "    "+ message +
            "            <div id=\"cabeza\">\n" +
            "                <center>\n" +
            "                    <img src=\"imgs/syntw.png\" style=\"width: 25%;\" align=\"middle\" />\n" +
            "                </center>\n" +
            "            </div>\n" +
            "            <div id=\"cuerpo\">\n" +
            "                <div id=\"usuario\">\n" +
            "                    <center>\n" +
            "                        <p><txt><b>Iniciar sesi&oacute;n</b></txt></p>        \n" +
            "                        <form method=\"POST\" action=\"\" autocomplete=\"off\" id=\"elform\">\n" +
            "                            <div class=\"mdl-textfield mdl-js-textfield mdl-textfield--floating-label\">\n" +
            "                                <input id=\"correo\" name=\"correo\" class=\"mdl-textfield__input\" type=\"email\">\n" +
            "                                <label class=\"mdl-textfield__label\"><b>Correo...</b></label>\n" +
            "                            </div><br><br>\n" +
            "                            <div class=\"mdl-textfield mdl-js-textfield mdl-textfield--floating-label\">\n" +
            "                                <input class=\"mdl-textfield__input\" id=\"contra\" name=\"contra\" type=\"password\">\n" +
            "                                <label class=\"mdl-textfield__label\"><b>Contrase&ntilde;a...</b></label>\n" +
            "                            </div>\n" +
            "                            <br/><br/>\n" +
            "                            <input type=\"button\" value=\"Ingresar\" id=\"boton\" onclick=\"valida();\"/>\n" +
            "                            <br/>\n" +
            "                            <select id=\"base\" name=\"base\">" +
            "                                <option value=\"0\">MySQL (recomendado)</option>" +
            "                                <option value=\"1\">PostgreSQL</option>" +
            "                                <option value=\"2\">MariaDB</option>" +
            "                                <option value=\"3\">SQL server</option>" +
            "                            </select>" +
            "                            <br/>\n" +
            "                            <hr/>\n" +
            "                        </form>\n" +
            "                        <table>\n" +
            "                            <tr>\n" +
            "                                <td id=\"rc\">\n" +
            "                                    <a href=\"jsp/recuperar.jsp\"><b>Recuperar Cuenta</b></a>\n" +
            "                                </td>\n" +
            "                                <td>\n" +
            "                                    |\n" +
            "                                </td>\n" +
            "                                <td id=\"r\">\n" +
            "                                    <a href=\"jsp/registro.jsp\"><b>Registrarse</b></a>\n" +
            "                                </td>\n" +
            "                                </tr>\n" +
            "                        </table>\n" +
            "                        <hr/><br>\n" +
            "                    </center>\n" +
            "                </div>\n" +
            "            </div>\n" +
            "        </div>    \n" +
            "    </body>\n" +
            "</html>";
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
