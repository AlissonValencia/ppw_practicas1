<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.productos.datos.Conexion" %>

<%
int id = Integer.parseInt(request.getParameter("id"));
Conexion con = new Conexion();
Connection conexion = con.crearConexion();
Statement stmt = conexion.createStatement();

String sql = "DELETE FROM tb_usuario WHERE id_us=" + id;
stmt.executeUpdate(sql);
conexion.close();
response.sendRedirect("usuarios.jsp");
%>
