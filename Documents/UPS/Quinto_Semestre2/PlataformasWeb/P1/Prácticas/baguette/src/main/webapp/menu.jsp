<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.productos.seguridad.Pagina" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Menú Principal - Baguette y Pastelería</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 
    <style>
    .menu-container { max-width: 600px; margin: 20px auto; }
    .user-info {
        background-color: #f7f3e8;
        color: #795548;
        padding: 15px;
        margin: 20px auto;
        border-radius: 8px;
        border: 1px solid #795548;
        font-weight: bold;
        text-align: center;
    }
    .menu-nav a {
        display: block;
        background-color: #f5f5f5;
        color: #795548;
        padding: 12px 15px;
        margin-bottom: 8px;
        border-radius: 5px;
        text-decoration: none;
        border-left: 5px solid #795548;
        transition: all 0.3s ease;
        font-weight: 500;
    }
    .menu-nav a:hover {
        background-color: #e2d8ce;
        transform: translateX(3px);
    }

    /* 🔹 Estilo del enlace “Cerrar Sesión” coherente con el resto */
    .logout-link {
        background-color: #f5f5f5;
        color: #795548;
        border-left: 5px solid #d7b89c;
        margin-top: 15px;
        font-weight: bold;
        text-align: left;
    }
    .logout-link:hover {
        background-color: #e2d8ce;
        border-left-color: #795548;
        transform: translateX(3px);
    }
</style>

</head>
<body>

<%
    // 🔹 1. Verificar si hay sesión activa
    if (session.getAttribute("nombre") == null || session.getAttribute("perfil") == null) {
        String mensajeAdvertencia = "Advertencia: Debe iniciar sesión para acceder al menú.";
        response.sendRedirect("login.jsp?error=" + URLEncoder.encode(mensajeAdvertencia, "UTF-8"));
        return;
    }

    // 🔹 2. Obtener datos de sesión
    String nombreUsuario = (String) session.getAttribute("nombre");
    Integer idPerfil = (Integer) session.getAttribute("perfil");
    String descripcionPerfil = (String) session.getAttribute("descripcionPerfil");
    String correoUsuario = (String) session.getAttribute("correo");
    
    // 🔹 Obtener fecha actual
    String fechaActual = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss").format(new Date());

    // 🔹 3. Cargar menú desde la clase Pagina
    Pagina pagina = new Pagina();
    String menuHTML = pagina.mostrarMenu(idPerfil);
%>

<main>
    <header>
        <img src="imagenes/logo-baguette-pastel.jpg" alt="Logo Baguette y Pastel" width="100" height="auto"/>
        <h1>Baguette y Pastelería</h1>
    </header>

    <nav>
        <!-- 🔹 Barra superior (solo navegación general, sin cerrar sesión) -->
        <a href="index.jsp">Home</a>
        <!--<a href="construccion.jsp">Ver Productos</a>
        <a href="construccion.jsp">Buscar Por Categoría</a> -->
    </nav>

    <div class="content">
        <section>
            <article>
                <h3>Portal Privado</h3>

                <div class="user-info">
                    <p>Usuario: <strong><%= nombreUsuario %></strong></p>
                    <p>Correo: <strong><%= correoUsuario != null ? correoUsuario : "No disponible" %></strong></p>
                    <p>Perfil: <strong><%= descripcionPerfil.toUpperCase() %></strong></p>
                    <p>Fecha: <strong><%= fechaActual %></strong></p>
                </div>

                <h4>Menú de Opciones:</h4>
                <div class="menu-nav">
                    <%= menuHTML %>

                    
                </div>
            </article>
        </section>

        <aside>
            <h3>Conoce a los desarrolladores</h3>
            <div class="aside-icons">
                <a href="https://www.linkedin.com/home" target="_blank">
                    <img src="iconos/linkedin.png" alt="LinkedIn" width="32" height="32"/>
                </a>
                <a href="https://github.com/" target="_blank">
                    <img src="iconos/github.png" alt="GitHub" width="32" height="32"/>
                </a>
            </div>
        </aside>
    </div>

    <footer>
        <ul>
            <li><a href="url-de-facebook"><img src="iconos/facebook.jpg" alt="Facebook" width="32" height="32"/></a></li>
            <li><a href="url-de-instagram"><img src="iconos/instagram.jpg" alt="Instagram" width="32" height="32"/></a></li>
            <li><a href="url-de-twitter"><img src="iconos/x.jpg" alt="X" width="32" height="32"/></a></li>
        </ul>
        <p>© 2025 - Baguette y Pastelería - Alisson Valencia</p>
    </footer>
</main>

</body>
</html>