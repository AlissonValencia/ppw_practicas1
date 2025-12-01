<%@page import="java.io.*, java.sql.*"%>
<%@page import="com.productos.datos.Conexion"%>

<%
request.setCharacterEncoding("UTF-8");
String nombre = request.getParameter("nombre");
int categoria = Integer.parseInt(request.getParameter("categoria"));
int cantidad = Integer.parseInt(request.getParameter("cantidad"));
double precio = Double.parseDouble(request.getParameter("precio"));

// Guardar foto si existe
Part foto = request.getPart("foto");
String nombreArchivo = null;
if (foto != null && foto.getSize() > 0) {
    nombreArchivo = "producto_" + System.currentTimeMillis() + ".jpg";
    String ruta = application.getRealPath("/") + "imagenes/productos/" + nombreArchivo;
    foto.write(ruta);
}

Conexion con = new Conexion();
Connection conexion = con.crearConexion();
String sql = "INSERT INTO tb_producto (id_cat, nombre_pr, cantidad_pr, precio_pr, foto_pr) VALUES (?,?,?,?,?)";
PreparedStatement ps = conexion.prepareStatement(sql);
ps.setInt(1, categoria);
ps.setString(2, nombre);
ps.setInt(3, cantidad);
ps.setDouble(4, precio);
ps.setString(5, nombreArchivo);
ps.executeUpdate();
conexion.close();

response.sendRedirect("gestionProductos.jsp");
%>
