<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.productos.seguridad.Usuario" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="com.productos.negocio.Bitacora"%>

<%
    // 1️⃣ Obtener parámetros
    String correo = request.getParameter("txtUsuario");
    String clave = request.getParameter("txtClave");

    // 2️⃣ Validar campos básicos
    if (correo == null || correo.trim().isEmpty() || clave == null || clave.trim().isEmpty()) {
        String mensajeError = "⚠️ Ingrese su usuario y contraseña.";
        response.sendRedirect("login.jsp?error=" + URLEncoder.encode(mensajeError, "UTF-8"));
        return;
    }

    // 3️⃣ Validar longitud de clave (excepto usuario especial "batman")
    if (clave.length() < 8 && !clave.equals("batman")) {
        String mensajeError = "⚠️ La contraseña debe tener al menos 8 caracteres.";
        response.sendRedirect("login.jsp?error=" + URLEncoder.encode(mensajeError, "UTF-8"));
        return;
    }

    // 4️⃣ Verificar usuario con la clase Usuario
    Usuario usuario = new Usuario();
    if (usuario.verificarUsuario(correo, clave)) {

        // 🔥 REGISTRAR EN BITÁCORA - LOGIN EXITOSO
        Bitacora bitacora = new Bitacora();
        bitacora.registrarLogin(usuario.getId(), true, request);

        // 5️⃣ Crear sesión y guardar todos los datos necesarios
        HttpSession sesion = request.getSession();
        session.setAttribute("id", usuario.getId());                  // ✅ Necesario para actualizar perfil y cambiar clave
        session.setAttribute("correo", correo);                       // ✅ Necesario para actualizar perfil
        session.setAttribute("perfil", usuario.getPerfil());
        session.setAttribute("nombre", usuario.getNombre());
        session.setAttribute("descripcionPerfil", usuario.getDescripcionPerfil());
        
        // ✅ AÑADIDO: Guardar objeto Usuario completo para bitacora.jsp
        session.setAttribute("usuario", usuario);

        response.sendRedirect("menu.jsp");

    } else {
        // 🔥 REGISTRAR EN BITÁCORA - LOGIN FALLIDO
        Bitacora bitacora = new Bitacora();
        bitacora.registrarLogin(0, false, request); // ID 0 para usuarios no autenticados

        // 6️⃣ Credenciales incorrectas
        String mensajeError = "❌ Usuario o clave incorrectos.";
        response.sendRedirect("login.jsp?error=" + URLEncoder.encode(mensajeError, "UTF-8"));
    }
%>