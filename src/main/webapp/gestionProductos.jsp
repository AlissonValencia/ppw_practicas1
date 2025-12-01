<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.List"%>
<%@page import="com.productos.datos.Conexion"%>
<%@page import="com.productos.negocio.Categoria"%>
<%@page import="com.productos.seguridad.Usuario"%>
<%@page import="com.productos.negocio.Bitacora"%>

<%
// Verificar sesión y usuario
Usuario usuario = (Usuario) session.getAttribute("usuario");
if (usuario == null || (usuario.getPerfil() != 1 && usuario.getPerfil() != 2)) {
    response.sendRedirect("login.jsp");
    return;
}

// Registrar acceso a gestión de productos en bitácora
Bitacora bitacora = new Bitacora();
bitacora.registrarBitacora(usuario.getId(), "ACCESO", "PRODUCTOS", 
    "Accedió a la gestión de productos", request);
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Gestión de Productos - Baguette y Pastelería</title>
<link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 

<style>
/* ===== Estilos generales ===== */
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #fcf8f0;
    color: #4b382d;
    margin: 0;
    padding: 20px;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    min-height: 100vh;
}

main {
    background-color: #ffffff;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    max-width: 950px;
    width: 100%;
}

h2 {
    color: #795548;
    text-align: center;
    margin-bottom: 25px;
    border-bottom: 3px solid #f7f3e8;
    padding-bottom: 10px;
}

form {
    background-color: #fff9f0;
    border: 1px solid #e0c9a6;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 30px;
}

label {
    display: block;
    margin-top: 10px;
    font-weight: bold;
}

input, select {
    width: 100%;
    padding: 8px;
    border: 1px solid #d2b48c;
    border-radius: 6px;
    margin-top: 5px;
}

button {
    background-color: #a08069;
    color: white;
    border: none;
    padding: 10px 18px;
    border-radius: 15px;
    font-weight: bold;
    cursor: pointer;
    margin-top: 15px;
}
button:hover {
    background-color: #795548;
}

table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}
th, td {
    padding: 10px;
    text-align: left;
}
th {
    background-color: #795548;
    color: white;
}
tr:nth-child(even) {
    background-color: #f7f3e8;
}
.icono {
    width: 20px;
    transition: 0.3s;
}
.icono:hover {
    transform: scale(1.15);
}

.volver {
    display: inline-block;
    background-color: #a08069;
    color: #ffffff;
    padding: 10px 25px;
    border-radius: 25px;
    text-decoration: none;
    font-weight: bold;
    transition: 0.3s;
    margin-top: 20px;
}
.volver:hover {
    background-color: #795548;
}
</style>

<script>
function validarProducto() {
    const nombre = document.getElementById("nombre").value.trim();
    const cantidad = document.getElementById("cantidad").value.trim();
    const precio = document.getElementById("precio").value.trim();

    if (nombre.length === 0) {
        alert("⚠️ El nombre del producto es obligatorio.");
        return false;
    }
    if (isNaN(cantidad) || cantidad <= 0) {
        alert("⚠️ La cantidad debe ser un número positivo.");
        return false;
    }
    if (isNaN(precio) || precio <= 0) {
        alert("⚠️ El precio debe ser un valor numérico mayor a 0.");
        return false;
    }
    return true;
}
</script>
</head>

<body>
<main>
<h2>Gestión de Productos</h2>

<!-- 🔹 Formulario para registrar productos -->
<form action="registrarProducto.jsp" method="post" enctype="multipart/form-data" onsubmit="return validarProducto();">
    <h3>Registrar nuevo producto</h3>

    <label>Nombre:</label>
    <input type="text" name="nombre" id="nombre" required>

    <label>Categoría:</label>
    <select name="categoria" required>
        <option value="">Seleccione...</option>
        <%
            List<Categoria> categorias = Categoria.obtenerCategorias();
            for (Categoria c : categorias) {
        %>
            <option value="<%= c.getId_cat() %>"><%= c.getDescripcion_cat() %></option>
        <%
            }
        %>
    </select>

    <label>Cantidad:</label>
    <input type="number" name="cantidad" id="cantidad" min="1" required>

    <label>Precio ($):</label>
    <input type="number" name="precio" id="precio" step="0.01" min="0.01" required>

    <label>Foto del producto (opcional):</label>
    <input type="file" name="foto" accept="image/*">

    <button type="submit">➕ Registrar Producto</button>
</form>

<!-- 🔹 Tabla de productos -->
<table>
    <tr>
        <th>ID</th>
        <th>Categoría</th>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Precio</th>
        <th>Actualizar</th>
        <th>Eliminar</th>
    </tr>

<%
Conexion con = new Conexion();
Connection conexion = null;
Statement stmt = null;
ResultSet rs = null;

try {
    conexion = con.crearConexion();
    stmt = conexion.createStatement();
    String sql = "SELECT p.id_pr, c.descripcion_cat AS categoria, p.nombre_pr, p.cantidad_pr, p.precio_pr " +
                 "FROM tb_producto p " +
                 "JOIN tb_categoria c ON p.id_cat = c.id_cat ORDER BY p.id_pr;";
    rs = stmt.executeQuery(sql);

    boolean hayDatos = false;
    while (rs.next()) {
        hayDatos = true;
%>
    <tr>
        <td><%= rs.getInt("id_pr") %></td>
        <td><%= rs.getString("categoria") %></td>
        <td><%= rs.getString("nombre_pr") %></td>
        <td><%= rs.getInt("cantidad_pr") %></td>
        <td>$<%= rs.getDouble("precio_pr") %></td>
        <td><a href="actualizarProducto.jsp?id=<%= rs.getInt("id_pr") %>"><img src="iconos/actualizar.jpg" class="icono" alt="Actualizar"></a></td>
        <td><a href="eliminarProducto.jsp?id=<%= rs.getInt("id_pr") %>" onclick="return confirm('¿Deseas eliminar este producto?');"><img src="iconos/eliminar.jpg" class="icono" alt="Eliminar"></a></td>
    </tr>
<%
    }
    if (!hayDatos) {
%>
    <tr><td colspan="7" style="text-align:center; color:gray;">No hay productos registrados.</td></tr>
<%
    }
} catch (Exception e) {
%>
    <tr><td colspan="7" style="color:red;">Error al cargar productos: <%= e.getMessage() %></td></tr>
<%
} finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conexion != null) conexion.close();
}
%>
</table>

<a href="menu.jsp" class="volver">⬅ Volver al menú</a>
</main>
</body>
</html>