<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.productos.datos.Conexion, com.productos.negocio.Bitacora"%>

<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

// ✅ Verificar sesión activa
if (session.getAttribute("id") == null || session.getAttribute("perfil") == null) {
    response.sendRedirect("login.jsp?error=Debe iniciar sesión para acceder a esta página.");
    return;
}

// ✅ Obtener ID de usuario desde sesión
int idUsuario = (Integer) session.getAttribute("id");

Conexion con = new Conexion();
Connection conexion = con.crearConexion();
Statement stmt = conexion.createStatement();

// ✅ Si se envió el formulario (POST)
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String nombre = request.getParameter("nombre");
    String correo = request.getParameter("correo");
    String cedula = request.getParameter("cedula");
    String residencia = request.getParameter("residencia");
    String estadoCivil = request.getParameter("estado_civil");

    boolean error = false;
    String mensaje = "";

    if (cedula == null || !cedula.matches("\\d{10}")) {
        mensaje = "⚠️ La cédula debe tener exactamente 10 dígitos numéricos.";
        error = true;
    } else if (correo == null || !correo.matches("^[^@]+@[^@]+\\.[a-zA-Z]{2,}$")) {
        mensaje = "⚠️ El correo ingresado no es válido.";
        error = true;
    }

    if (!error) {
        // Obtener datos antiguos para el registro en bitácora
        String sqlOld = "SELECT * FROM tb_usuario WHERE id_us=" + idUsuario;
        ResultSet rsOld = stmt.executeQuery(sqlOld);
        String datosAntiguos = "";
        if (rsOld.next()) {
            datosAntiguos = "Antes: " + rsOld.getString("nombre_us") + ", " + 
                           rsOld.getString("correo_us") + ", " + 
                           rsOld.getString("residencia_us");
        }
        rsOld.close();

        String sqlUpdate = "UPDATE tb_usuario SET nombre_us='" + nombre + "', correo_us='" + correo +
                           "', cedula_us='" + cedula + "', residencia_us='" + residencia +
                           "', id_est=" + estadoCivil +
                           " WHERE id_us=" + idUsuario;

        stmt.executeUpdate(sqlUpdate);
        
        // ✅ REGISTRAR EN BITÁCORA - ACTUALIZAR PERFIL
        Bitacora bitacora = new Bitacora();
        String detalles = "Usuario actualizó su perfil. " + datosAntiguos + " → Ahora: " + nombre + ", " + correo + ", " + residencia;
        bitacora.registrarBitacora(idUsuario, "ACTUALIZAR_PERFIL", "tb_usuario", detalles, request);
        
        out.println("<script>alert('✅ Cambios guardados correctamente.'); window.location='menu.jsp';</script>");
        return;
    } else {
        out.println("<script>alert('" + mensaje + "');</script>");
    }
}

// ✅ Obtener datos actuales del usuario
String sql = "SELECT * FROM tb_usuario WHERE id_us=" + idUsuario;
ResultSet rs = stmt.executeQuery(sql);
if (!rs.next()) {
    out.println("<script>alert('No se pudo cargar la información del usuario.'); window.location='menu.jsp';</script>");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Actualizar Perfil</title>
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
    background-color: #fff;
    padding: 35px 40px;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    width: 480px;
    border-top: 6px solid #d2b48c;
}
h2 {
    color: #795548;
    margin-bottom: 25px;
    border-bottom: 3px solid #f7f3e8;
    padding-bottom: 10px;
    text-align: center;
}
form { text-align: left; }
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
    font-size: 15px;
    background-color: #fffaf3;
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
button:hover { background-color: #795548; }
a {
    display: block;
    text-align: center;
    margin-top: 20px;
    color: #4b382d;
    text-decoration: none;
    font-weight: bold;
}
a:hover { color: #795548; }
</style>
<script>
function confirmarGuardado() {
    return confirm("¿Está seguro de guardar los cambios en su perfil?");
}
</script>
</head>
<body>
<div class="contenedor">
<h2>Actualizar Perfil</h2>

<form method="post" onsubmit="return confirmarGuardado();">
    <label>Nombre:</label>
    <input type="text" name="nombre" value="<%= rs.getString("nombre_us") %>" required>

    <label>Cédula:</label>
    <input type="text" name="cedula" maxlength="10" value="<%= rs.getString("cedula_us") %>" required>

    <label>Correo:</label>
    <input type="email" name="correo" value="<%= rs.getString("correo_us") %>" required>

    <label>Estado Civil:</label>
    <select name="estado_civil" required>
        <%
        Statement stmt2 = conexion.createStatement();
        ResultSet rs2 = stmt2.executeQuery("SELECT * FROM tb_estadocivil ORDER BY id_est");
        int estadoActual = rs.getInt("id_est");
        while (rs2.next()) {
            int idEst = rs2.getInt("id_est");
            String desc = rs2.getString("descripcion_est");
        %>
        <option value="<%= idEst %>" <%= (idEst==estadoActual?"selected":"") %>><%= desc %></option>
        <% }
        rs2.close(); stmt2.close();
        %>
    </select>

    <label>Lugar de Residencia:</label>
    <select name="residencia" required>
        <option value="Sur" <%= "Sur".equalsIgnoreCase(rs.getString("residencia_us")) ? "selected" : "" %>>Sur</option>
        <option value="Norte" <%= "Norte".equalsIgnoreCase(rs.getString("residencia_us")) ? "selected" : "" %>>Norte</option>
        <option value="Centro" <%= "Centro".equalsIgnoreCase(rs.getString("residencia_us")) ? "selected" : "" %>>Centro</option>
    </select>

    <button type="submit">&#128190; Guardar Cambios</button>
</form>

<a href="menu.jsp">&#11013; Volver al menú</a>
</div>
</body>
</html>

<%
conexion.close();
%>