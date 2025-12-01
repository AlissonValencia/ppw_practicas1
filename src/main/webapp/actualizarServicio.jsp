<%@ page import="com.productos.negocio.Servicio,com.productos.negocio.Categoria,com.productos.negocio.Bitacora" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Servicio</title>
    <link rel="stylesheet" href="estilos.css">

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
        padding: 35px 40px;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        width: 450px;
        text-align: center;
        border-top: 6px solid #d2b48c;
    }

    h2 {
        color: #795548;
        margin-bottom: 25px;
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
        background-color: #fffaf3;
    }

    input:focus, select:focus {
        outline: none;
        border-color: #a08069;
        box-shadow: 0 0 5px rgba(160,128,105,0.3);
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
        margin-top: 25px;
        text-align: center;
        text-decoration: none;
        font-weight: bold;
        color: #4b382d;
        transition: 0.3s;
    }

    a:hover {
        color: #795548;
    }

    .thumb {
        width: 120px;
        border-radius: 8px;
        margin-bottom: 10px;
    }
    </style>
</head>
<body>

<div class="contenedor">
    <h2>Actualizar Servicio</h2>

    <%
        // ✅ Verificar sesión
        if (session.getAttribute("id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int idUsuario = (Integer) session.getAttribute("id");

        String idParam = request.getParameter("id");
        if (idParam == null) {
            out.println("<p>ID no especificado.</p>");
        } else {
            int id = Integer.parseInt(idParam);

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String nombre = request.getParameter("nombre_ser");
                int id_cat = Integer.parseInt(request.getParameter("id_cat"));
                double precio = Double.parseDouble(request.getParameter("precio_base"));
                String unidad = request.getParameter("unidad_medida");
                String foto = request.getParameter("foto_actual");

                // Obtener datos antiguos del servicio
                Servicio servicioAntiguo = Servicio.obtenerServicioPorId(id);
                String datosAntiguos = "";
                if (servicioAntiguo != null) {
                    datosAntiguos = "Antes: " + servicioAntiguo.getNombre_ser() + ", Precio: $" + 
                                   servicioAntiguo.getPrecio_base() + ", Unidad: " + servicioAntiguo.getUnidad_medida();
                }

                Servicio s = new Servicio();
                s.setId_ser(id);
                s.setNombre_ser(nombre);
                s.setId_cat(id_cat);
                s.setPrecio_base(precio);
                s.setUnidad_medida(unidad);
                s.setFoto_ser(foto);

                String resultado = s.actualizarServicio();
                
                // ✅ REGISTRAR EN BITÁCORA - ACTUALIZAR SERVICIO
                Bitacora bitacora = new Bitacora();
                String detalles = "Servicio ID " + id + " actualizado. " + datosAntiguos + " → Ahora: " + nombre + ", Precio: $" + precio + ", Unidad: " + unidad;
                bitacora.registrarBitacora(idUsuario, "ACTUALIZAR_SERVICIO", "tb_servicio", detalles, request);
                
                out.println("<p><b>" + resultado + "</b></p>");
                out.println("<p><a href=\"gestionServicios.jsp\">Volver al listado</a></p>");

            } else {
                Servicio s = Servicio.obtenerServicioPorId(id);
                if (s == null) {
                    out.println("<p>Servicio no encontrado.</p>");
                } else {
    %>

    <form method="post" enctype="multipart/form-data">
        <label>Nombre:</label>
        <input type="text" name="nombre_ser" value="<%= s.getNombre_ser() %>" required>

        <label>Categoría:</label>
        <select name="id_cat" required>
            <option value="">Seleccione...</option>
            <%
                java.util.List<Categoria> cats = Categoria.obtenerCategorias();
                for (Categoria c : cats) {
                    if (c.getId_cat() >= 4 && c.getId_cat() <= 6) {
            %>
                <option value="<%= c.getId_cat() %>" <%= (c.getId_cat() == s.getId_cat() ? "selected" : "") %>><%= c.getDescripcion_cat() %></option>
            <%
                    }
                }
            %>
        </select>

        <label>Precio Base:</label>
        <input type="number" step="0.01" name="precio_base" value="<%= s.getPrecio_base() %>" required>

        <label>Unidad de Medida:</label>
        <input type="text" name="unidad_medida" value="<%= s.getUnidad_medida() %>" required>

        <label>Foto actual:</label>
        <%
            String fotoActual = s.getFoto_ser();
            if (fotoActual != null && !fotoActual.trim().isEmpty()) {
        %>
            <img src="uploads/servicios/<%= fotoActual %>" alt="foto" class="thumb">
        <%
            } else {
                out.print("<span>No hay foto</span>");
            }
        %>

        <input type="hidden" name="foto_actual" value="<%= (fotoActual == null ? "" : fotoActual) %>">
        <label>Subir nueva foto (opcional):</label>
        <input type="file" name="foto_ser" accept="image/*">

        <button type="submit">&#128190; Actualizar Servicio</button>
        <a href="gestionServicios.jsp">&#11013; Volver al listado</a>
    </form>

    <%
                }
            }
        }
    %>

</div>

</body>
</html>