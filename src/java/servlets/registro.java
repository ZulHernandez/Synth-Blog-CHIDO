/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
import javax.servlet.ServletException;
import static javax.servlet.SessionTrackingMode.URL;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author Saul
 */
    
@WebServlet(name = "registro", urlPatterns = {"/registro"})
public class registro extends HttpServlet {
        private String corr="";
        private String clav="";
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
            ldn.cValida validacion=new ldn.cValida();
                String tipoPet=request.getParameter("tipoPeticion")==null?"":request.getParameter("tipoPeticion");
                if(tipoPet.equals("0"))
                {
                    String nombre=request.getParameter("nombre")==null?"":request.getParameter("nombre");
                    String apellidos=request.getParameter("apell")==null?"":request.getParameter("apell");;
                    String user=request.getParameter("usr")==null?"":request.getParameter("usr");;
                    String clave=request.getParameter("psw")==null?"":request.getParameter("psw");;
                    String claveC=request.getParameter("pswC")==null?"":request.getParameter("pswC");;
                    String correo=request.getParameter("correo")==null?"":request.getParameter("correo");;
                    String correoR=request.getParameter("correoR")==null?"":request.getParameter("correoR");;
                    String anio=request.getParameter("anio")==null?"":request.getParameter("anio");;
                    String mes=request.getParameter("mes")==null?"":request.getParameter("mes");;
                    String dia=request.getParameter("dia")==null?"":request.getParameter("dia");;
                    String contenido=request.getParameter("contenido")==null?"":request.getParameter("contenido");
                    String [] elements={nombre,apellidos,user,clave,claveC,correo,
                                     correoR,anio,mes,dia,contenido};
                    if(validacion.validaVacios(elements))
                    {
                        if( validacion.coinciden(elements[3],elements[4],0) && 
                            validacion.coinciden(elements[5],elements[6],1))
                            {
                                for(int i=0;i<elements.length;i++)
                                {
                                    if(!validacion.valida(elements[i],i))
                                    {
                                        out.print("Campo con datos invalidos: "+validacion.obtenCampo(i));
                                        break;
                                    }
                                }
                                if(validacion.getError().equals("")){
                                    ldn.cLogica regis=new ldn.cLogica(0);
                                    String fecha=anio+"-"+regis.getMes(mes)+"-"+dia+"-";
                                    //out.print(fecha);
                                    String res=regis.registrar(nombre,apellidos, user,clave,fecha,correo,correoR,contenido);
                                    if(res.equals("Registro exitoso.")){
                                        Clases.cCifrado cred=new Clases.cCifrado();
                                        String corr=cred.Encriptar(correo);
                                        String cla=cred.Encriptar(clave);
                                        String tipo=cred.Encriptar("2");
                                        res="0"+tipo+"|"+corr+"||"+cla;
                                        System.out.println(cred.pedirClave(res));
                                        //Agregar método para agregar a todas las bases
                                        out.print("Espera nuestro correo de confirmacion \n\n");
                                        out.print(regis.mandaMailConfirm(correo,"Bienvenido a Synth BLOG!"));
                                    }
                                    else{
                                        out.print("Registro fallido, intentalo más tarde"+res);
                                        out.println(regis.getError());
                                    }
                                }else
                                    out.println(validacion.getError());
                                    
                            }else
                                out.print(validacion.getError()+" esta vacio");
                    }else
                        out.print(validacion.getError());
                }else
                    response.sendRedirect("login");
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
