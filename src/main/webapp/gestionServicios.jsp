<%@ page import="java.util.*,com.productos.negocio.Servicio,com.productos.negocio.Categoria,com.productos.seguridad.Usuario,com.productos.negocio.Bitacora" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
// Verificar sesión y usuario
Usuario usuario = (Usuario) session.getAttribute("usuario");
if (usuario == null || (usuario.getPerfil() != 1 && usuario.getPerfil() != 2)) {
    response.sendRedirect("login.jsp");
    return;
}

// Registrar acceso a gestión de servicios en bitácora
Bitacora bitacora = new Bitacora();
bitacora.registrarBitacora(usuario.getId(), "ACCESO", "SERVICIOS", 
    "Accedió a la gestión de servicios", request);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Servicios</title>
    <link rel="stylesheet" href="estilos.css">

    <!-- Estilos EXACTOS que pediste para gestionServicios.jsp -->
    <style>
    /* ===== Estilos generales ===== */
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
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        max-width: 950px;
        width: 100%;
    }

    h2 {
        color: #795548;
        text-align: center;
        margin-bottom: 25px;
        border-bottom: 3px solid #f7f3e8;
        padding-bottom: 10px;
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
        margin-top: 5px;
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
        transition: 0.3s;
    }
    .icono:hover {
        transform: scale(1.15);
    }

    .volver {
        display: inline-block;
        background-color: #a08069;
        color: #ffffff;
        padding: 10px 25px;
        border-radius: 25px;
        text-decoration: none;
        font-weight: bold;
        transition: 0.3s;
        margin-top: 20px;
    }
    .volver:hover {
        background-color: #795548;
    }
    </style>
</head>
<body>

<main>
    <h2>Gestión de Servicios</h2>

    <!-- Formulario - registro -->
    <form method="post" enctype="multipart/form-data">
        <label>Nombre del servicio:</label>
        <input type="text" name="nombre_ser" required>

        <label>Categoría:</label>
        <select name="id_cat" required>
            <option value="">Seleccione...</option>
            <%
                List<Categoria> cats = Categoria.obtenerCategorias();
                for (Categoria c : cats) {
                    if (c.getId_cat() >= 4 && c.getId_cat() <= 6) {
            %>
                <option value="<%=c.getId_cat()%>"><%=c.getDescripcion_cat()%></option>
            <%
                    }
                }
            %>
        </select>

        <label>Precio Base:</label>
        <input type="number" step="0.01" name="precio_base" required>

        <label>Unidad de Medida:</label>
        <input type="text" name="unidad_medida" required>

        <label>Foto (opcional):</label>
        <input type="file" name="foto_ser" accept="image/*">

        <button type="submit">➕ Registrar Servicio</button>
    </form>

    <%-- Inserción servidor (mantengo la lógica anterior) --%>
    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String nombre = request.getParameter("nombre_ser");
            int id_cat = Integer.parseInt(request.getParameter("id_cat"));
            double precio = Double.parseDouble(request.getParameter("precio_base"));
            String unidad = request.getParameter("unidad_medida");

            Servicio s = new Servicio();
            s.setNombre_ser(nombre);
            s.setId_cat(id_cat);
            s.setPrecio_base(precio);
            s.setUnidad_medida(unidad);
            s.setFoto_ser(null); // si subes foto, mantén lógica de guardado

            out.println("<p><b>" + s.insertarServicio() + "</b></p>");
            
            // Registrar creación de servicio en bitácora
            if (usuario != null) {
                Bitacora bitacoraRegistro = new Bitacora();
                bitacoraRegistro.registrarGestionServicio(usuario.getId(), "CREACION", nombre, request);
            }
        }
    %>

    <h2>Listado de Servicios</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Categoría</th>
            <th>Nombre</th>
            <th>Precio Base</th>
            <th>Unidad</th>
            <th>Actualizar</th>
            <th>Eliminar</th>
        </tr>

        <%
            List<Servicio> lista = Servicio.obtenerServicios();
            for (Servicio sv : lista) {
                String nombreCat = "";
                for (Categoria c : cats) {
                    if (c.getId_cat() == sv.getId_cat()) nombreCat = c.getDescripcion_cat();
                }
        %>
        <tr>
            <td><%= sv.getId_ser() %></td>
            <td><%= nombreCat %></td>
            <td><%= sv.getNombre_ser() %></td>
            <td>$<%= sv.getPrecio_base() %></td>
            <td><%= sv.getUnidad_medida() %></td>
            <td>
                <a href="actualizarServicio.jsp?id=<%= sv.getId_ser() %>">
                    <img src="iconos/actualizar.jpg" class="icono" alt="Actualizar">
                </a>
            </td>
            <td>
                <a href="eliminarServicio.jsp?id=<%= sv.getId_ser() %>" onclick="return confirm('¿Deseas eliminar este servicio?');">
                    <img src="iconos/eliminar.jpg" class="icono" alt="Eliminar">
                </a>
            </td>
        </tr>
        <% } %>
    </table>

    <a href="menu.jsp" class="volver">⬅ Volver al menú</a>
</main>

</body>
</html>