<%-- 
    Document   : despliegaTeoria
    Created on : 25-nov-2016, 13:14:18
    Author     : Bear
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession ss = request.getSession();
    int bd = 0;
    int idT = 0;
    try{
        bd = ss.getAttribute("bd") == null ? -1 : Integer.parseInt(ss.getAttribute("bd").toString());
        idT = request.getParameter("idT") == null ? -1 : Integer.parseInt(request.getParameter("idT"));
        if(bd == -1 || idT == -1) throw new Exception("parametros vacios");
    }catch(Exception e){
        System.out.println(e.getMessage());
        response.sendRedirect("../login.html");
    }
    ldn.cTeoria teoria = new ldn.cTeoria(bd);
    String src = teoria.getTeoria1(idT);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../styles/teoria.css" rel="stylesheet" type="text/css"/>
        <title>JSP Page</title>
    </head>
    <body>
        <%if(teoria.getError().equals("")){%>
        <%=src%>
        <%}else{%>
        <script>alert("<%=teoria.getError()%>");</script>
        <%}%>
    </body>
</html>
