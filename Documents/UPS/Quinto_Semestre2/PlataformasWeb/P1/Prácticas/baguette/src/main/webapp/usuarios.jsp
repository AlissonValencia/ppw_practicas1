<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.productos.datos.Conexion" %>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Administrar Usuarios - Baguette y Pastelería</title>
<link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 
<style>
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
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    max-width: 900px;
    width: 100%;
}
h2 {
    color: #795548;
    text-align: center;
    margin-bottom: 25px;
    border-bottom: 3px solid #f7f3e8;
    padding-bottom: 15px;
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
}

/* 🔹 Estilo del enlace “Volver al menú” */
a[href="menu.jsp"] {
    display: inline-block;
    background-color: #a08069;
    color: #ffffff;
    padding: 10px 25px;
    border-radius: 25px;
    text-decoration: none;
    font-weight: bold;
    transition: all 0.3s ease;
    box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
    margin-top: 20px;
}
a[href="menu.jsp"]:hover {
    background-color: #795548;
    transform: translateY(-2px);
}
</style>
<script>
function validarFormulario() {
    const cedula = document.getElementById("cedula").value.trim();
    const correo = document.getElementById("correo").value.trim();
    const clave = document.getElementById("clave").value.trim();

    if (cedula.length !== 10 || isNaN(cedula)) {
        alert("⚠️ La cédula debe tener exactamente 10 dígitos numéricos.");
        return false;
    }
    const emailValido = /^[^@]+@[^@]+\.[a-zA-Z]{2,}$/;
    if (!emailValido.test(correo)) {
        alert("⚠️ El correo ingresado no es válido.");
        return false;
    }
    if (clave.length < 8) {
        alert("⚠️ La contraseña debe tener al menos 8 caracteres.");
        return false;
    }
    return true;
}
</script>
</head>
<body>
<main>
<h2>Administrar Usuarios</h2>

<form action="registrarUsuario.jsp" method="post" onsubmit="return validarFormulario();">
    <h3>Registrar nuevo usuario (Administrador o Vendedor)</h3>

    <label>Nombre:</label>
    <input type="text" name="nombre" required>

    <label>Cédula:</label>
    <input type="text" name="cedula" id="cedula" maxlength="10" required>

    <label>Correo:</label>
    <input type="email" name="correo" id="correo" required>

    <label>Contraseña:</label>
    <input type="password" name="clave" id="clave" minlength="8" required>

    <label>Tipo de Perfil:</label>
    <select name="perfil" required>
        <option value="">Seleccione...</option>
        <option value="1">Administrador</option>
        <option value="2">Vendedor</option>
    </select>

    <label>Estado Civil:</label>
    <select name="estado_civil" required>
        <option value="">Seleccione...</option>
        <%
            Conexion conEC = new Conexion();
            Connection conx = conEC.crearConexion();
            Statement stEC = conx.createStatement();
            ResultSet rsEC = stEC.executeQuery("SELECT id_est, descripcion_est FROM tb_estadocivil");
            while (rsEC.next()) {
        %>
            <option value="<%= rsEC.getInt("id_est") %>"><%= rsEC.getString("descripcion_est") %></option>
        <% } conx.close(); %>
    </select>

    <button type="submit">Registrar Usuario</button>
</form>

<table>
    <tr>
        <th>ID</th>
        <th>Perfil</th>
        <th>Nombre</th>
        <th>Cédula</th>
        <th>Correo</th>
        <th>Estado Civil</th>
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
    String sql = "SELECT u.id_us, p.descripcion_per AS perfil, u.nombre_us, u.cedula_us, u.correo_us, e.descripcion_est AS estado_civil " +
                 "FROM tb_usuario u " +
                 "JOIN tb_perfil p ON u.id_per = p.id_per " +
                 "JOIN tb_estadocivil e ON u.id_est = e.id_est ORDER BY u.id_us;";
    rs = stmt.executeQuery(sql);
    while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("id_us") %></td>
    <td><%= rs.getString("perfil") %></td>
    <td><%= rs.getString("nombre_us") %></td>
    <td><%= rs.getString("cedula_us") %></td>
    <td><%= rs.getString("correo_us") %></td>
    <td><%= rs.getString("estado_civil") %></td>
    <td><a href="actualizarUsuario.jsp?id=<%= rs.getInt("id_us") %>"><img src="iconos/actualizar.jpg" class="icono" alt="Editar"></a></td>
    <td><a href="eliminarUsuario.jsp?id=<%= rs.getInt("id_us") %>" onclick="return confirm('¿Desea eliminar este usuario?');"><img src="iconos/eliminar.jpg" class="icono" alt="Eliminar"></a></td>
</tr>
<% }
} catch (Exception e) {
    out.println("<tr><td colspan='8' style='color:red'>Error: " + e.getMessage() + "</td></tr>");
} finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conexion != null) conexion.close();
}
%>
</table>
<a href="menu.jsp">⬅ Volver al menú</a>
</main>
</body>
</html>
