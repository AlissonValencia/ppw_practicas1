<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.productos.datos.Conexion"%>
<%@page import="com.productos.negocio.*"%>

<%
Carrito carrito = (Carrito) session.getAttribute("carrito");
if (carrito == null) {
    carrito = new Carrito();
    session.setAttribute("carrito", carrito);
}

Conexion con = new Conexion();
Connection cn = con.crearConexion();

// Procesar productos
Statement st = cn.createStatement();
ResultSet productos = st.executeQuery("SELECT id_pr, nombre_pr, precio_pr, foto_pr FROM tb_producto");

while (productos.next()) {
    int id = productos.getInt("id_pr");
    String param = "cant_" + id; // 🔥 Busca "cant_" + id

    if (request.getParameter(param) != null) {
        int cant = Integer.parseInt(request.getParameter(param));
        if (cant > 0) {
            carrito.agregarItem(new ItemCarrito(
                id,
                productos.getString("nombre_pr"),
                productos.getDouble("precio_pr"),
                cant,
                productos.getString("foto_pr")
            ));
        }
    }
}

// Procesar servicios
ResultSet servicios = st.executeQuery("SELECT id_ser, nombre_ser, precio_base, foto_ser FROM tb_servicio");

while (servicios.next()) {
    int id = servicios.getInt("id_ser");
    String param = "serv_" + id; // 🔥 Busca "serv_" + id

    if (request.getParameter(param) != null) {
        int cant = Integer.parseInt(request.getParameter(param));
        if (cant > 0) {
            carrito.agregarItem(new ItemCarrito(
                id + 10000, // Sumar 10000 para diferenciar servicios
                servicios.getString("nombre_ser"),
                servicios.getDouble("precio_base"),
                cant,
                servicios.getString("foto_ser")
            ));
        }
    }
}

// Registrar en bitácora si hay usuario logueado
com.productos.seguridad.Usuario usuario = (com.productos.seguridad.Usuario) session.getAttribute("usuario");
if (usuario != null && carrito.getItems().size() > 0) {
    Bitacora bitacora = new Bitacora();
    bitacora.registrarAccionCarrito(usuario.getId(), "AGREGAR_CARRITO", 
        "Agregó " + carrito.getItems().size() + " items al carrito", request);
}

response.sendRedirect("carrito.jsp");
%>