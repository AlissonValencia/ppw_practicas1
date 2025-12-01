<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.productos.datos.Conexion"%>
<%@page import="com.productos.seguridad.Usuario"%>
<%@page import="com.productos.negocio.Bitacora"%>

<%
// Obtener usuario de sesión para bitácora
Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Registrar Usuario - Baguette y Pastelería</title>
<link href="css/estilos3.css" rel="stylesheet" type="text/css"/>
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #fcf8f0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}
.contenedor {
    background-color: #fff;
    padding: 30px 40px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    width: 450px;
    text-align: center;
}
h2 {
    color: #795548;
    margin-bottom: 20px;
}
.mensaje {
    padding: 15px;
    border-radius: 8px;
    font-weight: bold;
}
.ok {
    background-color: #d7ffd9;
    color: #256029;
}
.error {
    background-color: #ffd7d7;
    color: #a10000;
}
a {
    display: inline-block;
    margin-top: 20px;
    text-decoration: none;
    color: #4b382d;
    font-weight: bold;
}
a:hover {
    color: #795548;
}
</style>
</head>
<body>
<div class="contenedor">
<h2>Registro de Usuario</h2>

<%
    request.setCharacterEncoding("UTF-8");

    String nombre = request.getParameter("nombre");
    String cedula = request.getParameter("cedula");
    String correo = request.getParameter("correo");
    String clave = request.getParameter("clave");
    String perfil = request.getParameter("perfil");
    String estadoCivil = request.getParameter("estado_civil");

    if (nombre == null || cedula == null || correo == null || clave == null || perfil == null || estadoCivil == null) {
%>
    <div class="mensaje error">❌ Error: faltan campos requeridos.</div>
    <a href="usuarios.jsp">⬅ Volver</a>
<%
    } else {
        boolean error = false;
        String mensaje = "";

        // 🔹 Validaciones en servidor
        if (cedula.length() != 10 || !cedula.matches("\\d+")) {
            mensaje = "⚠️ La cédula debe tener exactamente 10 dígitos numéricos.";
            error = true;
        } else if (!correo.matches("^[^@]+@[^@]+\\.[a-zA-Z]{2,}$")) {
            mensaje = "⚠️ El correo ingresado no es válido.";
            error = true;
        } else if (clave.length() < 8) {
            mensaje = "⚠️ La contraseña debe tener al menos 8 caracteres.";
            error = true;
        }

        if (!error) {
            try {
                Conexion con = new Conexion();
                Connection conexion = con.crearConexion();

                String sql = "INSERT INTO tb_usuario (id_per, id_est, nombre_us, cedula_us, correo_us, clave_us) " +
                             "VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conexion.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(perfil));        // 1 = admin, 2 = vendedor
                ps.setInt(2, Integer.parseInt(estadoCivil));   // id_est de tb_estadocivil
                ps.setString(3, nombre);
                ps.setString(4, cedula);
                ps.setString(5, correo);
                ps.setString(6, clave);

                int filas = ps.executeUpdate();

                if (filas > 0) {
                    // 🔥 REGISTRAR EN BITÁCORA - NUEVO USUARIO
                    if (usuarioSesion != null) {
                        Bitacora bitacora = new Bitacora();
                        String tipoPerfil = "CLIENTE";
                        if (perfil.equals("1")) tipoPerfil = "ADMINISTRADOR";
                        else if (perfil.equals("2")) tipoPerfil = "EMPLEADO";
                        bitacora.registrarBitacora(usuarioSesion.getId(), "CREACION", "USUARIOS", 
                            "Registró nuevo usuario: " + nombre + " (" + tipoPerfil + ")", request);
                    }
%>
                    <div class="mensaje ok">✅ Usuario registrado correctamente.</div>
                    <meta http-equiv="refresh" content="2;URL=usuarios.jsp">
<%
                } else {
%>
                    <div class="mensaje error">❌ No se pudo registrar el usuario.</div>
                    <a href="usuarios.jsp">⬅ Volver</a>
<%
                }
                conexion.close();
            } catch (SQLException e) {
%>
                <div class="mensaje error">❌ Error en la base de datos: <%= e.getMessage() %></div>
                <a href="usuarios.jsp">⬅ Volver</a>
<%
            }
        } else {
%>
            <div class="mensaje error"><%= mensaje %></div>
            <a href="usuarios.jsp">⬅ Volver</a>
<%
        }
    }
%>
</div>
</body>
</html>