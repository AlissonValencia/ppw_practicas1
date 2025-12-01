<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.productos.seguridad.Usuario" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Datos de un Nuevo Cliente</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/>
    <style>
        /* 🔹 Mensajes visuales dentro de la página */
        .mensaje {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-weight: bold;
            text-align: center;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }
        .exito {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        /* 🔹 Estilo para el enlace de login */
        .btn-login {
            display: inline-block;
            margin-top: 15px;
            background-color: #795548;
            color: white;
            padding: 10px 25px;
            border-radius: 25px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 3px 8px rgba(0,0,0,0.2);
        }
        .btn-login:hover {
            background-color: #a97456;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0,0,0,0.3);
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }
        td {
            padding: 8px;
            border: 1px solid #ddd;
        }
        main {
            padding: 30px;
            background: #fffdf9;
            border-radius: 12px;
            max-width: 700px;
            margin: 40px auto;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h3 {
            text-align: center;
            color: #5d4037;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
<main>
    <div class="content">
        <section>
            <article>
                <h3>Datos de un Nuevo Cliente</h3>

                <%
                    // --- 1️⃣ Capturar todos los datos del formulario ---
                    String nombre = request.getParameter("txtNombre");
                    String cedula = request.getParameter("txtCedula");
                    String estadoCivil = request.getParameter("cmbEstado");
                    String residencia = request.getParameter("rdResidencia");
                    String foto = request.getParameter("fileFoto");
                    String mFecha = request.getParameter("mFecha");
                    String color = request.getParameter("cColor");
                    String email = request.getParameter("txtEmail");
                    String clave = request.getParameter("txtClave");

                    // --- 2️⃣ Registrar en la base de datos ---
                    Usuario nuevoUsuario = new Usuario();
                    nuevoUsuario.setNombre(nombre);
                    nuevoUsuario.setCorreo(email);
                    nuevoUsuario.setClave(clave);
                    nuevoUsuario.setCedula(cedula);
                    nuevoUsuario.setPerfil(2); // 🔹 2 = Cliente
                    nuevoUsuario.setEstado(1); // 🔹 1 = Activo

                    String mensajeRegistro = nuevoUsuario.ingresarCliente();
                %>

                <!-- 🔹 3️⃣ Mostrar mensaje dentro de la página -->
                <%
                    if ("OK".equals(mensajeRegistro)) {
                %>
                    <div class="mensaje exito">
                        ✅ Registro exitoso. ¡Bienvenido, <%= nombre %>!<br>
                        <a href="login.jsp" class="btn-login">Ir al login</a>
                    </div>
                <%
                    } else {
                %>
                    <div class="mensaje error">
                        ❌ Error al registrar el usuario: <%= mensajeRegistro %>
                    </div>
                <%
                    }
                %>

                <!-- 🔹 4️⃣ Mostrar todos los datos visualmente -->
                <table>
                    <tr>
                        <td><strong>Nombre:</strong></td>
                        <td><%= nombre %></td>
                    </tr>
                    <tr>
                        <td><strong>Cédula:</strong></td>
                        <td><%= cedula %></td>
                    </tr>
                    <tr>
                        <td><strong>Estado Civil:</strong></td>
                        <td><%= estadoCivil %></td>
                    </tr>
                    <tr>
                        <td><strong>Lugar de Residencia:</strong></td>
                        <td><%= residencia %></td>
                    </tr>
                    <tr>
                        <td><strong>Foto del Perfil:</strong></td>
                        <td><u><%= foto %></u></td>
                    </tr>
                    <tr>
                        <td><strong>Fecha de Nacimiento:</strong></td>
                        <td><%= mFecha %></td>
                    </tr>
                    <tr>
                        <td><strong>Color Favorito:</strong></td>
                        <td><font color="<%= color %>">Este es tu color favorito</font></td>
                    </tr>
                    <tr>
                        <td><strong>Correo Electrónico:</strong></td>
                        <td><%= email %></td>
                    </tr>
                </table>
            </article>
        </section>
    </div>
</main>
</body>
</html>
