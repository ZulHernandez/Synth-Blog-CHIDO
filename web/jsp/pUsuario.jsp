<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion=request.getSession();
    String scr="";
    String s=sesion.getAttribute("usuario").toString()==null?"":sesion.getAttribute("usuario").toString();
    if(s.equals(""))
        response.sendRedirect("../login");
    
 %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Perfil de Usuario</title>
        <script src="../scripts/sweetalert.min.js" type="text/javascript"></script>
        <link href="../styles/sweetalert.css" rel="stylesheet" type="text/css"/>
       
    <style>
        input[type="radio"] {
          display: none;
        }
        label {
          color: grey;
        }
        .cal {
          direction: rtl;
          unicode-bidi: bidi-override;
        }
        label:hover,
        label:hover ~ label {
          color: black;
        }
        input[type="radio"]:checked ~ label {
          color: black;
        }
    </style>
    </head>
    <body>
        <div id="todo">
            <br/><br/>
            <div id="cabecera">
                <table>
                    <tr>
                        <td>
                            <img id="fotoP" height="200" width="200" src="../imgs/twitter.png"/>
                        </td>
                        <td>
                            <p>Nombre de la cuenta</p><br>
                            <p>Descripción de la cuenta</p>
                            <input type="button" id="follow" value="Seguir">
                        </td>
                    </tr>
                </table>
            </div>
            <div id="cuerpo">
                <table>
                    <tr>
                        <td>
                            <p>Publicación</p>
                            <p>Descripción</p>
                            <img height="300" width="300" src="../imgs/facebook.png"/>
                        </td>
                        <td>
                            <p>Intereses</p>
                            <table title="Intereses">
                                <td>
                                    <tr>
                                    Interes1
                                    </tr>
                                    <tr>
                                    Interes2
                                    </tr>
                                    <tr>
                                    Interes3
                                    </tr>
                                </td>
                            </table> <br/><br/>
                            <input type="button" id="Descargar" value="Descargar" ><br/><br/> 
                            <p class="cal">
                                <input id="radio1" type="radio" name="stars" value="5">
                                <label for="radio1">★</label>
                                <input id="radio2" type="radio" name="stars" value="4">
                                <label for="radio2">★</label>
                                <input id="radio3" type="radio" name="stars" value="3">
                                <label for="radio3">★</label>
                                <input id="radio4" type="radio" name="stars" value="2">
                                <label for="radio4">★</label>
                                <input id="radio5" type="radio" name="stars" value="1">
                                <label for="radio5">★</label>
                            </p>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        saludar();
    </body>
</html>
