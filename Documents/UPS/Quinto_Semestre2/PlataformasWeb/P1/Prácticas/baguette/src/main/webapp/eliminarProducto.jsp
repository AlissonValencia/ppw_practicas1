<%@page import="java.sql.*, com.productos.datos.Conexion"%>

<%
int id = Integer.parseInt(request.getParameter("id"));
Conexion con = new Conexion();
Connection conexion = con.crearConexion();

PreparedStatement ps = conexion.prepareStatement("DELETE FROM tb_producto WHERE id_pr=?");
ps.setInt(1, id);
ps.executeUpdate();
conexion.close();

response.sendRedirect("gestionProductos.jsp");
%>
