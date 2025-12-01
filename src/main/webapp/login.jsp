<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Al inicio del JSP --%>
<%@page import="com.productos.negocio.Bitacora"%>

<%-- Después de la validación fallida --%>
<%
Bitacora bitacora = new Bitacora();
bitacora.registrarLogin(0, false, request);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login - Baguette y Pastelería</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 
    <style>
        .login-form-table {
            max-width: 400px;
            margin: 20px auto;
            border-collapse: collapse;
        }
        .login-form-table td {
            padding: 10px;
        }
        .login-form-table input[type="submit"] {
            background-color: #795548;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
            display: block;
            margin: 0 auto;
        }
        .login-form-table input[type="submit"]:hover {
            background-color: #5d4037;
        }

        .register-button-container {
            text-align: center;
            margin-top: 15px;
            padding: 10px;
        }
        .register-button-container a {
            text-decoration: underline;
            background: none;
            border: none;
            color: #795548;
            font-weight: bold;
        }
        .register-button-container a:hover {
            color: #5d4037;
            background: none;
        }

        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .warning-message {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
    </style>
</head>
<body>
    <main>
        <header>
            <img src="imagenes/logo-baguette-pastel.jpg" alt="Logo Baguette y Pastel" width="100" height="auto"/>
            <h1>Baguette y Pastelería</h1>
        </header>

        <nav>
            <a href="index.jsp">Home</a>
            <a href="login.jsp" class="active">Login</a>
            <a href="construccion.jsp">Ver Productos</a>
            <a href="construccion.jsp">Buscar Por Categoría</a>
        </nav>

        <div class="content">
            <section>
                <article>

                    <%
                        String mensaje = request.getParameter("error");
                        if(mensaje != null && !mensaje.isEmpty()) {
                            String cssClass = (mensaje.contains("Error") || mensaje.contains("Advertencia")) ? "error-message" : "warning-message";
                            out.println("<div class='message " + cssClass + "'>" + mensaje + "</div>");
                        }
                    %>

                    <h3>Ingreso del Sistema</h3>

                    <!-- 🔹 CAMBIO: validación JavaScript -->
                    <form action="validarLogin.jsp" method="post" onsubmit="return validarClave();">
                        <script>
                            function validarClave() {
                                const clave = document.getElementById("clave").value;

                                // Permite "batman" como excepción
                                if (clave === "batman") {
                                    return true;
                                }

                                // Aplica validación normal
                                if (clave.length < 8) {
                                    alert("La contraseña debe tener al menos 8 caracteres.");
                                    return false;
                                }
                                return true;
                            }
                        </script>
                        <table class="login-form-table" border="1">
                            <tr>
                                <td>Usuario:</td>
                                <td>
                                    <input type="email" id="usuario" name="txtUsuario" required placeholder="tucorreo@dominio.com" />
                                </td>
                            </tr>
                            <tr>
                                <td>Contraseña:</td>
                                <td>
                                    <!-- 🔹 CAMBIO: quitado minlength para no bloquear 'batman' -->
                                    <input type="password" id="clave" name="txtClave" required />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type="submit" value="Ingresar"/>
                                </td>
                            </tr>
                        </table>
                    </form>

                    <div class="register-button-container">
                        ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
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
