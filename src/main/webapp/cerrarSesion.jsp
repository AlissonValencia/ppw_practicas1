<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder" %>

<%
    // 1. Invalidar la sesión
    session.invalidate();
    
    // 2. Redirección a login.jsp con mensaje de éxito
    String mensajeExito = "Has cerrado sesión exitosamente.";
    response.sendRedirect("login.jsp?error=" + URLEncoder.encode(mensajeExito, "UTF-8"));
%>