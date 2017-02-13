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
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author Alumno
 */
@WebServlet(name = "agregaImg", urlPatterns = {"/agregaImg"})
@MultipartConfig
public class agregaImg extends HttpServlet {

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
            String dir=request.getParameter("dir")==null?"":request.getParameter("dir"); 
            String pass=request.getParameter("pass")==null?"":request.getParameter("pass");
            HttpSession sesion=request.getSession();
            int bd=Integer.parseInt(sesion.getAttribute("bd").toString());
           Part archivo=request.getPart("nuevaImg");
            if(dir.equals("")||pass.equals(""))
                out.print("Error de peticion");
            else
            {
                URL rutaca = agregaImg.class.getProtectionDomain().getCodeSource().getLocation(); // traigo dirreccion
                System.out.println(rutaca);
                String rutama = rutaca.toString();
                String newruta = rutama.substring(6,rutama.length());
                System.out.println(newruta);
                String newnewruta = newruta.substring(0,newruta.length()-42);
                System.out.println(newnewruta);
                String absolute = newnewruta.replace("%20"," ");
                System.out.println(absolute);
                String sss=absolute.substring(0,absolute.indexOf("build"));
                System.out.println(sss);
                sss+="build/web/imgs";
                System.out.println("esta"+sss);
                absolute=sss;
                absolute=absolute.replace("//","/");
                System.out.println("La chidisima \n"+absolute);
                String rutaimagen = "";
                 if(!archivo.getContentType().equals("application/octet-stream")){
                    InputStream isimagen = archivo.getInputStream();
                    File destinoimagen = new File(absolute);
                            System.out.println(destinoimagen.getAbsolutePath());
                            
                    if(!destinoimagen.exists()){
                        destinoimagen.mkdirs();
                        System.out.println("Ya se creo");
                    }
                    File[] ficherosimagen = destinoimagen.listFiles();
                    int numimagen = ficherosimagen.length + 1;
                    System.out.println(ficherosimagen.length);
                    File fimagen = new File(destinoimagen+"\\"+"usr"+dir+"foto"+numimagen+".jpg");
                    String xrutaimagen = absolute+"\\usr"+dir+"foto"+numimagen+".jpg";
                    rutaimagen = xrutaimagen.replace("\\","/");
                     System.out.println("RUTITA");
                     System.out.println(rutaimagen);
                     String xRuta= rutaimagen.substring(rutaimagen.indexOf("/Synth BLOG"));
                     System.out.println(xRuta);
                     xRuta=xRuta.replace("/web","");
                     xRuta=xRuta.replace("//","/");
                     System.out.println("La chida" +xRuta);
                    FileOutputStream outimagen = new FileOutputStream(fimagen);
                    int dataimagen = isimagen.read();
                    while(dataimagen != -1){
                        outimagen.write(dataimagen);
                        dataimagen = isimagen.read();
                    }
                    isimagen.close();
                    outimagen.close();
                    ldn.cLogica agrega=new ldn.cLogica(bd);
                    xRuta=xRuta.replace("Synth BLOG BETA 1","Synth_BLOG");
                    xRuta=xRuta.replace("/build","");
                    agrega.modifDatosCta(dir,xRuta,pass,"6");
                    response.sendRedirect("jsp/perfil.jsp");
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
