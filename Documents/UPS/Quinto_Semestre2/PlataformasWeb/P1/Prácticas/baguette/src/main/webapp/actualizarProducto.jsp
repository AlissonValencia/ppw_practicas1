<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.productos.datos.Conexion, com.productos.negocio.Bitacora"%>

<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

// ✅ Verificar sesión
if (session.getAttribute("id") == null) {
    response.sendRedirect("login.jsp");
    return;
}
int idUsuario = (Integer) session.getAttribute("id");

int id = Integer.parseInt(request.getParameter("id"));
Conexion con = new Conexion();
Connection conexion = con.crearConexion();
Statement stmt = conexion.createStatement();

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String nombre = request.getParameter("nombre");
    int categoria = Integer.parseInt(request.getParameter("categoria"));
    int cantidad = Integer.parseInt(request.getParameter("cantidad"));
    double precio = Double.parseDouble(request.getParameter("precio"));

    // Obtener datos antiguos del producto
    String sqlOld = "SELECT * FROM tb_producto WHERE id_pr=" + id;
    ResultSet rsOld = stmt.executeQuery(sqlOld);
    String datosAntiguos = "";
    if (rsOld.next()) {
        datosAntiguos = "Antes: " + rsOld.getString("nombre_pr") + ", Cant: " + 
                       rsOld.getInt("cantidad_pr") + ", Precio: $" + rsOld.getDouble("precio_pr");
    }
    rsOld.close();

    String sqlUpdate = "UPDATE tb_producto SET nombre_pr='" + nombre + "', id_cat=" + categoria +
                       ", cantidad_pr=" + cantidad + ", precio_pr=" + precio +
                       " WHERE id_pr=" + id;
    stmt.executeUpdate(sqlUpdate);
    
    // ✅ REGISTRAR EN BITÁCORA - ACTUALIZAR PRODUCTO
    Bitacora bitacora = new Bitacora();
    String detalles = "Producto ID " + id + " actualizado. " + datosAntiguos + " → Ahora: " + nombre + ", Cant: " + cantidad + ", Precio: $" + precio;
    bitacora.registrarBitacora(idUsuario, "ACTUALIZAR_PRODUCTO", "tb_producto", detalles, request);
    
    response.sendRedirect("gestionProductos.jsp");
    return;
}

String sql = "SELECT * FROM tb_producto WHERE id_pr=" + id;
ResultSet rs = stmt.executeQuery(sql);
if (rs.next()) {
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Actualizar Producto</title>
<link href="css/estilos3.css" rel="stylesheet" type="text/css"/>
<style>
body {
    background-color: #fcf8f0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    min-height: 100vh;
    padding: 40px;
}

.contenedor {
    background-color: #ffffff;
    padding: 35px 40px;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    width: 450px;
    text-align: center;
    border-top: 6px solid #d2b48c;
}

h2 {
    color: #795548;
    margin-bottom: 25px;
    border-bottom: 3px solid #f7f3e8;
    padding-bottom: 10px;
}

form {
    text-align: left;
}

label {
    display: block;
    margin-top: 15px;
    font-weight: bold;
    color: #4b382d;
}

input, select {
    width: 100%;
    padding: 10px;
    margin-top: 6px;
    border-radius: 8px;
    border: 1px solid #d2b48c;
    box-sizing: border-box;
    font-size: 15px;
    background-color: #fffaf3;
}

input:focus, select:focus {
    outline: none;
    border-color: #a08069;
    box-shadow: 0 0 5px rgba(160,128,105,0.3);
}

button {
    display: block;
    width: 100%;
    background-color: #a08069;
    color: #fff;
    border: none;
    padding: 12px;
    border-radius: 25px;
    margin-top: 25px;
    cursor: pointer;
    font-size: 16px;
    font-weight: bold;
    transition: 0.3s;
}

button:hover {
    background-color: #795548;
}

a {
    display: block;
    margin-top: 25px;
    text-align: center;
    text-decoration: none;
    font-weight: bold;
    color: #4b382d;
    transition: 0.3s;
}

a:hover {
    color: #795548;
}
</style>
</head>
<body>
<div class="contenedor">
    <h2>Actualizar Producto</h2>
    <form method="post">
        <label>Nombre:</label>
        <input type="text" name="nombre" value="<%= rs.getString("nombre_pr") %>" required>

        <label>Categoría:</label>
        <select name="categoria" required>
            <option value="1" <%= (rs.getInt("id_cat")==1?"selected":"") %>>Panadería Artesanal</option>
            <option value="2" <%= (rs.getInt("id_cat")==2?"selected":"") %>>Pastelería Fina y Postres</option>
            <option value="3" <%= (rs.getInt("id_cat")==3?"selected":"") %>>Repostería y Dulces Individuales</option>
        </select>

        <label>Cantidad:</label>
        <input type="number" name="cantidad" min="0" value="<%= rs.getInt("cantidad_pr") %>" required>

        <label>Precio ($):</label>
        <input type="number" name="precio" step="0.01" min="0" value="<%= rs.getDouble("precio_pr") %>" required>

        <button type="submit">&#128190; Actualizar Producto</button>
    </form>

    <a href="gestionProductos.jsp">&#11013; Volver al listado</a>
</div>
</body>
</html>
<%
}
conexion.close();
%>