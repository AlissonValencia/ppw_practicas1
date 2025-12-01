<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.productos.datos.Conexion, com.productos.negocio.Bitacora" %>

<%
    // ✅ Verificar sesión y permisos de administrador
    if (session.getAttribute("id") == null || session.getAttribute("perfil") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int idUsuarioAdmin = (Integer) session.getAttribute("id");
    int perfilAdmin = (Integer) session.getAttribute("perfil");
    
    // Solo administradores pueden actualizar usuarios
    if (perfilAdmin != 1) {
        response.sendRedirect("menu.jsp?error=No tiene permisos para esta acción");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    Conexion con = new Conexion();
    Connection conexion = con.crearConexion();
    Statement stmt = conexion.createStatement();

    // 🔹 Procesamiento si se envía el formulario
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String cedula = request.getParameter("cedula");
        String perfil = request.getParameter("perfil");
        String estado_civil = request.getParameter("estado_civil");

        boolean error = false;
        String mensaje = "";

        // 🔹 Validaciones servidor
        if (cedula == null || !cedula.matches("[0-9]{10}")) {
            mensaje = "⚠️ La cédula debe tener exactamente 10 dígitos numéricos.";
            error = true;
        } else if (!correo.matches("^[^@]+@[^@]+\\.[a-zA-Z]{2,}$")) {
            mensaje = "⚠️ El correo ingresado no es válido.";
            error = true;
        }

        if (!error) {
            // Obtener datos antiguos del usuario
            String sqlOld = "SELECT * FROM tb_usuario WHERE id_us=" + id;
            ResultSet rsOld = stmt.executeQuery(sqlOld);
            String datosAntiguos = "";
            if (rsOld.next()) {
                datosAntiguos = "Antes: " + rsOld.getString("nombre_us") + ", " + 
                               rsOld.getString("correo_us") + ", Perfil: " + rsOld.getInt("id_per");
            }
            rsOld.close();

            String sqlUpdate = "UPDATE tb_usuario SET nombre_us='" + nombre + 
                               "', correo_us='" + correo + 
                               "', cedula_us='" + cedula + 
                               "', id_per=" + perfil + 
                               ", id_est=" + estado_civil + 
                               " WHERE id_us=" + id;
            stmt.executeUpdate(sqlUpdate);
            
            // ✅ REGISTRAR EN BITÁCORA - ACTUALIZAR USUARIO
            Bitacora bitacora = new Bitacora();
            String perfilTexto = perfil.equals("1") ? "Administrador" : "Vendedor";
            String detalles = "Administrador actualizó usuario ID " + id + ". " + datosAntiguos + " → Ahora: " + nombre + ", " + correo + ", Perfil: " + perfilTexto;
            bitacora.registrarBitacora(idUsuarioAdmin, "ACTUALIZAR_USUARIO", "tb_usuario", detalles, request);
            
            response.sendRedirect("usuarios.jsp");
            return;
        } else {
%>
            <script>alert("<%= mensaje %>");</script>
<%
        }
    }

    // 🔹 Cargar datos del usuario actual
    String sql = "SELECT * FROM tb_usuario WHERE id_us=" + id;
    ResultSet rs = stmt.executeQuery(sql);
    if (rs.next()) {
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Actualizar Usuario</title>
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
    padding: 30px 40px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    width: 450px;
    text-align: center;
}
h2 {
    color: #795548;
    margin-bottom: 20px;
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
    margin-top: 20px;
    text-align: center;
    text-decoration: none;
    font-weight: bold;
    color: #4b382d;
}
a:hover {
    color: #795548;
}
.error {
    color: red;
    font-size: 14px;
    margin-top: 5px;
}
</style>
</head>
<body>
<div class="contenedor">
<h2>Actualizar Usuario</h2>

<form method="post">
    <label>Nombre:</label>
    <input type="text" name="nombre" value="<%= rs.getString("nombre_us") %>" required>

    <label>Cédula:</label>
    <input type="text" name="cedula" maxlength="10" pattern="[0-9]{10}"
           title="Debe tener exactamente 10 dígitos numéricos"
           value="<%= rs.getString("cedula_us") %>" required>

    <label>Correo:</label>
    <input type="email" name="correo" value="<%= rs.getString("correo_us") %>" 
           title="Ejemplo: usuario@correo.com" required>

    <label>Perfil:</label>
    <select name="perfil" required>
        <option value="1" <%= (rs.getInt("id_per")==1?"selected":"") %>>Administrador</option>
        <option value="2" <%= (rs.getInt("id_per")==2?"selected":"") %>>Vendedor</option>
    </select>

    <label>Estado Civil:</label>
    <select name="estado_civil" required>
        <%
            String sqlEstado = "SELECT * FROM tb_estadocivil ORDER BY id_est;";
            Statement stmt2 = conexion.createStatement();
            ResultSet rs2 = stmt2.executeQuery(sqlEstado);
            int estadoActual = rs.getInt("id_est");
            while (rs2.next()) {
                int idEst = rs2.getInt("id_est");
                String descEst = rs2.getString("descripcion_est");
        %>
            <option value="<%= idEst %>" <%= (estadoActual == idEst ? "selected" : "") %>><%= descEst %></option>
        <%
            }
            rs2.close();
            stmt2.close();
        %>
    </select>

    <button type="submit">💾 Actualizar Usuario</button>
</form>

<a href="usuarios.jsp">⬅ Volver al listado</a>
</div>
</body>
</html>

<%
    }
    conexion.close();
%>