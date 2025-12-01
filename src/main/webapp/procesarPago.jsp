<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.productos.datos.Conexion"%>
<%@page import="com.productos.negocio.Carrito,com.productos.negocio.ItemCarrito,com.productos.negocio.Bitacora"%>
<%@page import="java.text.DecimalFormat"%>

<%
// Configurar encoding
response.setContentType("text/html;charset=UTF-8");
response.setCharacterEncoding("UTF-8");

// Verificar carrito
Carrito carrito = (Carrito) session.getAttribute("carrito");
if (carrito == null || carrito.getItems().size() == 0) { 
    response.sendRedirect("carrito.jsp"); 
    return; 
}

// ✅ Verificar sesión de usuario
if (session.getAttribute("id") == null) {
    response.sendRedirect("login.jsp");
    return;
}
int idUsuario = (Integer) session.getAttribute("id");

DecimalFormat df = new DecimalFormat("#,##0.00");
double totalConImpuestos = carrito.getTotal() * 1.12;
int idPedido = 0;
boolean exito = false;

try {
    // Obtener ID del cliente de la sesión
    Integer idCliente = (Integer) session.getAttribute("id_cliente");
    
    if (idCliente == null) {
        idCliente = idUsuario; // Usar el ID de usuario si no hay id_cliente específico
    }

    Conexion con = new Conexion();
    Connection cn = con.crearConexion();

    try {
        // Registrar pedido
        PreparedStatement ps = cn.prepareStatement(
            "INSERT INTO tb_pedido(id_cli, fecha, total, estado) VALUES (?, NOW(), ?, 'PENDIENTE')",
            Statement.RETURN_GENERATED_KEYS
        );
        ps.setInt(1, idCliente);
        ps.setDouble(2, carrito.getTotal());
        ps.executeUpdate();
        
        ResultSet keys = ps.getGeneratedKeys();
        if (keys.next()) {
            idPedido = keys.getInt(1);
        }
        ps.close();

        // Insertar detalles del pedido
        for (ItemCarrito item : carrito.getItems()) {
            String tipo = "PRODUCTO";
            if (item.getNombre() != null && item.getNombre().toLowerCase().contains("servicio")) {
                tipo = "SERVICIO";
            }
            
            PreparedStatement det = cn.prepareStatement(
                "INSERT INTO tb_detalle(id_ped, tipo, id_ref, cantidad, precio) VALUES (?, ?, ?, ?, ?)"
            );
            det.setInt(1, idPedido);
            det.setString(2, tipo);
            det.setInt(3, item.getId());
            det.setInt(4, item.getCantidad());
            det.setDouble(5, item.getPrecio());
            det.executeUpdate();
            det.close();

            // Actualizar stock solo si es PRODUCTO
            if (tipo.equals("PRODUCTO") && item.getId() > 0) {
                try {
                    PreparedStatement up = cn.prepareStatement(
                        "UPDATE tb_producto SET cantidad_pr = cantidad_pr - ? WHERE id_pr = ? AND cantidad_pr >= ?"
                    );
                    up.setInt(1, item.getCantidad());
                    up.setInt(2, item.getId());
                    up.setInt(3, item.getCantidad());
                    up.executeUpdate();
                    up.close();
                } catch (SQLException e) {
                    System.err.println("Error actualizando stock: " + e.getMessage());
                }
            }
        }

        // ✅ REGISTRAR EN BITÁCORA - PAGO CARRITO
        Bitacora bitacora = new Bitacora();
        String detallesItems = "";
        for (ItemCarrito item : carrito.getItems()) {
            detallesItems += item.getNombre() + " (x" + item.getCantidad() + "), ";
        }
        String detalles = "Pago exitoso - Pedido #" + idPedido + " - Total: $" + carrito.getTotal() + 
                         " - Items: " + carrito.getItems().size() + " - " + detallesItems;
        bitacora.registrarBitacora(idUsuario, "PAGO_CARRITO", "tb_pedido", detalles, request);

        // Limpiar carrito
        carrito.limpiar();
        exito = true;
        
    } catch (SQLException e) {
        e.printStackTrace();
        throw new ServletException("Error al procesar el pago en la base de datos: " + e.getMessage());
    } finally {
        if (cn != null) {
            try { cn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

} catch (Exception e) {
    e.printStackTrace();
%>
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error en el Pago</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background: #fcf8f0;
                margin: 0;
                padding: 40px 20px;
                text-align: center;
            }
            .error-container {
                background: white;
                padding: 60px 40px;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                max-width: 500px;
                margin: 0 auto;
            }
            .error-icon {
                font-size: 5rem;
                margin-bottom: 20px;
                color: #f44336;
            }
            .btn-primary {
                background: #a08069;
                color: white;
                padding: 15px 30px;
                border-radius: 10px;
                text-decoration: none;
                display: inline-block;
                margin-top: 20px;
                font-weight: 600;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }
            .btn-primary:hover {
                background: #795548;
                transform: translateY(-2px);
            }
            .error-details {
                background: #fff5f5;
                padding: 15px;
                border-radius: 8px;
                margin: 20px 0;
                color: #d32f2f;
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <div class="error-icon">❌</div>
            <h2>Error en el Proceso de Pago</h2>
            <p>Lo sentimos, ha ocurrido un error al procesar tu pedido.</p>
            
            <div class="error-details">
                <strong>Detalles del error:</strong><br>
                <%= e.getMessage() %>
            </div>
            
            <p>Por favor, intenta nuevamente o contacta con soporte.</p>
            
            <a href="carrito.jsp" class="btn-primary">Volver al Carrito</a>
            <br>
            <a href="nuevo_pedido.jsp" style="color: #a08069; text-decoration: none; margin-top: 10px; display: inline-block;">
                Seguir Comprando
            </a>
        </div>
    </body>
    </html>
<%
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pago Exitoso - Panadería Artesanal</title>
    <style>
        :root {
            --primary: #a08069;
            --primary-dark: #795548;
            --secondary: #fcf8f0;
            --accent: #8d6e63;
            --text: #5d4037;
            --text-light: #8d6e63;
            --white: #ffffff;
            --border: #e0c9a6;
            --success: #4caf50;
            --shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--secondary);
            color: var(--text);
            line-height: 1.6;
            padding: 20px;
        }

        .success-container {
            max-width: 600px;
            margin: 0 auto;
            background: var(--white);
            border-radius: 20px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .success-header {
            background: linear-gradient(135deg, var(--success), #45a049);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .success-icon {
            font-size: 4rem;
            margin-bottom: 15px;
        }

        .success-header h1 {
            font-size: 2.2rem;
            margin-bottom: 10px;
        }

        .success-body {
            padding: 30px;
        }

        .order-summary {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin: 25px 0;
            border-left: 4px solid var(--success);
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding: 8px 0;
        }

        .summary-row.total {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-dark);
            border-top: 2px solid var(--border);
            padding-top: 15px;
            margin-top: 10px;
        }

        .order-number {
            background: var(--primary);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            display: inline-block;
            margin: 15px 0;
        }

        .next-steps {
            background: #e8f5e8;
            border-radius: 12px;
            padding: 20px;
            margin: 25px 0;
        }

        .next-steps h3 {
            color: var(--success);
            margin-bottom: 15px;
        }

        .next-steps ul {
            list-style: none;
            padding-left: 0;
        }

        .next-steps li {
            padding: 8px 0;
            padding-left: 30px;
            position: relative;
        }

        .next-steps li:before {
            content: "✓";
            color: var(--success);
            font-weight: bold;
            position: absolute;
            left: 0;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
            border: none;
            padding: 15px 25px;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            flex: 1;
            min-width: 200px;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(160, 128, 105, 0.3);
        }

        .btn-secondary {
            background: transparent;
            color: var(--primary);
            border: 2px solid var(--primary);
            padding: 13px 25px;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            flex: 1;
            min-width: 200px;
        }

        .btn-secondary:hover {
            background: var(--primary);
            color: var(--white);
        }

        .confirmation-message {
            text-align: center;
            color: var(--text-light);
            font-style: italic;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }

        @media (max-width: 768px) {
            .btn-group {
                flex-direction: column;
            }
            
            .btn-primary, .btn-secondary {
                min-width: 100%;
            }
            
            body {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-header">
            <div class="success-icon">🎉</div>
            <h1>¡Pago Exitoso!</h1>
            <p>Tu pedido ha sido procesado correctamente</p>
            <div class="order-number">Orden #<%= idPedido %></div>
        </div>

        <div class="success-body">
            <div class="order-summary">
                <h3>Resumen de tu Compra</h3>
                
                <div class="summary-row">
                    <span>Número de Pedido:</span>
                    <span><strong>#<%= idPedido %></strong></span>
                </div>
                
                <div class="summary-row">
                    <span>Fecha:</span>
                    <span><%= new java.util.Date() %></span>
                </div>
                
                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span>$<%= df.format(carrito.getTotal()) %></span>
                </div>
                
                <div class="summary-row">
                    <span>Impuestos (12%):</span>
                    <span>$<%= df.format(carrito.getTotal() * 0.12) %></span>
                </div>
                
                <div class="summary-row total">
                    <span>Total Pagado:</span>
                    <span>$<%= df.format(totalConImpuestos) %></span>
                </div>
            </div>

            <div class="next-steps">
                <h3>¿Qué sigue?</h3>
                <ul>
                    <li>Hemos enviado un correo con los detalles de tu compra</li>
                    <li>Tu pedido estará listo en aproximadamente 30 minutos</li>
                    <li>Recibirás una notificación cuando esté listo para recoger</li>
                    <li>Presenta tu número de orden al recoger</li>
                </ul>
            </div>

            <div class="btn-group">
                <a href="nuevo_pedido.jsp" class="btn-primary">
                    🛍️ Realizar Otro Pedido
                </a>
                <a href="menu.jsp" class="btn-secondary">
                    🏠 Volver al Inicio
                </a>
            </div>

            <div class="confirmation-message">
                <p>¡Gracias por tu compra! Esperamos verte pronto.</p>
            </div>
        </div>
    </div>
</body>
</html>