<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.productos.negocio.Bitacora"%>

<%-- Después del registro exitoso --%>
<%
Bitacora bitacora = new Bitacora();
bitacora.registrarRegistroUsuario(0, "CLIENTE", request);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Nuevo Cliente - Baguette y Pastelería</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 
    <style>
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        td {
            padding: 8px;
        }
        .required-label:after {
            content: " *";
            color: red;
        }
        /* 🔹 Estilos del mensaje de error o éxito */
        #mensajeRegistro {
            margin-top: 10px;
            margin-bottom: 10px;
        }
        .message {
            padding: 10px;
            margin: 15px 0;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
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
            <a href="construccion.jsp">Ver Productos</a>
            <a href="construccion.jsp">Buscar Por Categoría</a>
        </nav>

        <div class="content">
            <section>
                <article>
                    <h3>Registro de nuevo Cliente</h3>

                    <!-- 🔹 CONTENEDOR para mostrar mensajes dentro de la página -->
                    <div id="mensajeRegistro"></div>
                    
                    <form action="nuevoCliente.jsp" method="post" id="formCliente">
                        <table border="1">
                            <tr>
                                <td class="required-label">Nombre:</td>
                                <td><input type="text" id="nombre" name="txtNombre" required /></td>
                            </tr>
                            <tr>
                                <td class="required-label">Cédula:</td>
                                <td>
                                    <input 
                                        type="text" 
                                        id="cedula" 
                                        name="txtCedula" 
                                        maxlength="10"
                                        required
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td class="required-label">Estado Civil:</td>
                                <td>
                                    <select id="estado" name="cmbEstado" required>
                                        <option value="">Seleccione...</option>
                                        <option value="Soltero">Soltero</option>
                                        <option value="Casado">Casado</option>
                                        <option value="Divorciado">Divorciado</option>
                                        <option value="Viudo">Viudo</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="required-label">Lugar de Residencia:</td>
                                <td>
                                    <input type="radio" id="residenciaSur" name="rdResidencia" value="Sur" required/> Sur 
                                    <input type="radio" id="residenciaNorte" name="rdResidencia" value="Norte"/> Norte 
                                    <input type="radio" id="residenciaCentro" name="rdResidencia" value="Centro"/> Centro
                                </td>
                            </tr>
                            <tr>
                                <td>Foto:</td>
                                <td>
                                    <input type="file" id="foto" name="fileFoto" accept=".jpg, .jpeg, .png"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="required-label">Fecha de Nacimiento:</td>
                                <td>
                                    <input type="date" id="fecha" name="mFecha" required/>
                                </td>
                            </tr>
                            <tr>
                                <td class="required-label">Color Favorito:</td>
                                <td>
                                    <input type="color" id="color" name="cColor" required/>
                                </td>
                            </tr>
                            <tr>
                                <td class="required-label">Correo Electrónico:</td>
                                <td>
                                    <input type="email" id="email" name="txtEmail" required placeholder="usuario@nombreProveedor.dominio" />
                                </td>
                            </tr>
                            <tr>
                                <td class="required-label">Contraseña:</td>
                                <td>
                                    <input
                                        type="password"
                                        id="clave" 
                                        name="txtClave"
                                        minlength="8"
                                        required
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td><input type="submit" value="Enviar"/></td>
                                <td><input type="reset" value="Restablecer"/></td>
                            </tr>
                        </table>
                    </form>
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

    <!-- 🔹 Script colocado al final (asegura que todo el DOM esté listo) -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("formCliente");
            const mensajeDiv = document.getElementById("mensajeRegistro");

            form.addEventListener("submit", function(e) {
                const clave = document.getElementById("clave").value.trim();
                const cedula = document.getElementById("cedula").value.trim();
                const email = document.getElementById("email").value.trim();

                // limpiar mensajes previos
                mensajeDiv.innerHTML = "";

                const emailRegex = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

                if (!/^\d{10}$/.test(cedula)) {
                    e.preventDefault();
                    mensajeDiv.innerHTML = "<div class='message error-message'>La cédula debe tener exactamente 10 dígitos numéricos.</div>";
                    alert("⚠️ La cédula debe tener exactamente 10 dígitos numéricos.");
                    document.getElementById("cedula").focus();
                    return;
                }

                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    mensajeDiv.innerHTML = "<div class='message error-message'>Por favor, ingrese un correo electrónico válido.</div>";
                    alert("⚠️ Por favor, ingrese un correo electrónico válido.");
                    document.getElementById("email").focus();
                    return;
                }

                if (clave.length < 8) {
                    e.preventDefault();
                    mensajeDiv.innerHTML = "<div class='message error-message'>La contraseña debe tener al menos 8 caracteres.</div>";
                    alert("⚠️ La contraseña debe tener al menos 8 caracteres.");
                    document.getElementById("clave").focus();
                    return;
                }
            });
        });
    </script>
</body>
</html>
