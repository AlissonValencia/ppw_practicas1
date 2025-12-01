<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.productos.datos.Conexion, com.productos.negocio.Bitacora"%>

<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

if (session.getAttribute("id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int idUsuario = (Integer) session.getAttribute("id");

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String claveActual = request.getParameter("clave_actual");
    String nuevaClave = request.getParameter("nueva_clave");
    String confirmarClave = request.getParameter("confirmar_clave");
    
    Conexion con = new Conexion();
    Connection conexion = con.crearConexion();
    
    try {
        // Verificar clave actual
        String sql = "SELECT clave_us FROM tb_usuario WHERE id_us = ?";
        PreparedStatement ps = conexion.prepareStatement(sql);
        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            String claveBD = rs.getString("clave_us");
            
            if (claveBD.equals(claveActual)) {
                if (nuevaClave.equals(confirmarClave)) {
                    // Actualizar contraseña
                    String updateSql = "UPDATE tb_usuario SET clave_us = ? WHERE id_us = ?";
                    PreparedStatement updatePs = conexion.prepareStatement(updateSql);
                    updatePs.setString(1, nuevaClave);
                    updatePs.setInt(2, idUsuario);
                    updatePs.executeUpdate();
                    
                    // ✅ REGISTRAR EN BITÁCORA - CAMBIO CLAVE
                    Bitacora bitacora = new Bitacora();
                    bitacora.registrarBitacora(idUsuario, "CAMBIO_CLAVE", "tb_usuario", "Usuario cambió su contraseña", request);
                    
                    out.println("<script>alert('✅ Contraseña cambiada exitosamente.'); window.location='menu.jsp';</script>");
                } else {
                    out.println("<script>alert('⚠️ Las contraseñas nuevas no coinciden.');</script>");
                }
            } else {
                out.println("<script>alert('⚠️ La contraseña actual es incorrecta.');</script>");
            }
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (conexion != null) {
            try { conexion.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cambiar Contraseña</title>
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
        input {
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
</head>
<body>
    <div class="contenedor">
        <h2>🔐 Cambiar Contraseña</h2>
        <form method="post">
            <label>Contraseña Actual:</label>
            <input type="password" name="clave_actual" required>
            
            <label>Nueva Contraseña:</label>
            <input type="password" name="nueva_clave" required>
            
            <label>Confirmar Nueva Contraseña:</label>
            <input type="password" name="confirmar_clave" required>
            
            <button type="submit">&#128273; Cambiar Contraseña</button>
</form>
<a href="menu.jsp">&#11013; Volver al menú</a>
    </div>
</body>
</html>
