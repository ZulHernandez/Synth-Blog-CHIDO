/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
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

/**
 *
 * @author Saul
 */
@WebServlet(name = "agregaDatos", urlPatterns = {"/agregaDatos"})
@MultipartConfig
public class agregaDatos extends HttpServlet {

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
       
        try (PrintWriter out = response.getWriter()){
             String tipoPeticion=request.getParameter("tipoPeticion")==null?"":request.getParameter("tipoPeticion");
             //peticion 0 de consulta de intereses
             String idUsr=request.getParameter("user")==null?"":request.getParameter("user"); 
             String visita=request.getParameter("visita")==null?"":request.getParameter("visita");
             String visitante=request.getParameter("visitante")==null?"":request.getParameter("visitante");
             String clavUsr=request.getParameter("clavUsr")==null?"":request.getParameter("clavUsr"); 
             String nvoDato=request.getParameter("nvoDato")==null?"":request.getParameter("nvoDato");
             String tipo=request.getParameter("tipo")==null?"":request.getParameter("tipo");
             String token=request.getParameter("token")==null?"":request.getParameter("token");
             String paramBsq=request.getParameter("paramBsq")==null?"":request.getParameter("paramBsq");
             String respuesta="";
             HttpSession sesion=request.getSession();
             int bd=Integer.parseInt(sesion.getAttribute("bd").toString());
             ldn.cLogica trae=new ldn.cLogica(bd);
             Clases.cCifrado cred=new Clases.cCifrado();
                //valor asignado por default, debe traerse el valor desde 
             //la sesion
             //validar usuario y contraseña en el ss 
             if(tipoPeticion.equals("0"))
             {
                 
                
                 respuesta=trae.getIntereses(idUsr);
                 out.print(respuesta);
             }else
                 if(tipoPeticion.equals("1") && !idUsr.equals(""))
                 {
                     //hacer JSON para regresar todo el array
                     // con los datos para recibirlos 
                     //con jquery
                     
                     String data[]=new String[5];
                     
                     data=trae.traePerfil(idUsr,1);
                     String values[]={"usr","psw","mail","descrip","preview"};
                     JsonObject jsPerfil=trae.perfilToJson(values,data);
                     //s.addAll(data);
                     if(data[0].equals(""))
                         out.print("Datos no encontrados");
                     else
                         out.print(jsPerfil.toString());
                 }else
                   if(tipoPeticion.equals("2")){
                       System.out.println("Estos son los intereses");
                       Gson s=new Gson();
                      
                     
                       
                     String datos []={idUsr,clavUsr,tipo,nvoDato};
                     if(!trae.datosVacios(datos))
                     {
                         respuesta=trae.modifDatosCta(idUsr,nvoDato, clavUsr, tipo);
                         out.write(respuesta+trae.getError());
                         if(respuesta.equals("Clave modificada")|| respuesta.equals("Correo modificado")){
                            if(tipo.equals("2")||tipo.equals("3")){
                                tipo=cred.Encriptar(tipo);
                                idUsr=cred.Encriptar(idUsr);
                                clavUsr=cred.Encriptar(clavUsr);
                                nvoDato=cred.Encriptar(nvoDato);
                                respuesta="5"+tipo+"|"+idUsr+"||"+clavUsr+"|||"+nvoDato;
                                out.write(cred.pedirClave(respuesta));
                            }
                         }
                     }else
                         out.print(trae.getError());
                   }else
                    if(tipoPeticion.equals("3")){
                        //activar cuenta
                       String us="";
                       String cl="";
                       respuesta=trae.activarCuenta(token);
                       //us=respuesta.substring(0,respuesta.indexOf("|"));
                      // System.out.println(us);
                       System.out.println(respuesta);
                       if(!respuesta.equals("No se encontro la cuenta")){
                           System.out.println("See");
                           us=respuesta.substring(respuesta.indexOf("|")+1,respuesta.indexOf("||"));
                           cl=respuesta.substring(respuesta.indexOf("||")+2);
                           us=cred.Encriptar(us);
                           cl=cred.Encriptar(cl);
                           respuesta="2"+us+"|"+cl;
                           out.write(cred.pedirClave(respuesta));
                       }else
                           out.write(respuesta);
                   }
                    else
                        if(tipoPeticion.equals("4"))
                        {
                                String data[]=new String[4];

                                
                                String values[]={"nombre","correo","descripcion","imgPerfil"};
                                String disableSeguir="false";
                                
                                if(Boolean.valueOf(visita))
                                {
                                   data=trae.traePerfil(visitante,0);
                                   if(trae.seSiguen(visitante,idUsr))
                                        disableSeguir="true";
                                }else
                                    data=trae.traePerfil(idUsr,0);
                                JsonObject jsPerfil=trae.perfilToJson(values,data);
                                jsPerfil.addProperty("seguir",disableSeguir);
                                //s.addAll(data);
                                if(data[0].equals(""))
                                    out.print("Datos no encontrados");
                                else
                                    out.print(jsPerfil.toString());
                        }else
                            if(tipoPeticion.equals("5") && paramBsq!=null)
                            {
                                out.write(trae.busquedaGeneral(paramBsq));
                            }else
                                if(tipoPeticion.equals("6"))
                                {
                                    String estatusSeguimiento="";
                                    if(Boolean.valueOf(visita))
                                    {
                                       //if(!trae.seSiguen(visitante,idUsr))
                                        estatusSeguimiento=trae.seguirCuenta(visitante, idUsr);
                                        out.write(estatusSeguimiento);
                                           
                                    }
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
