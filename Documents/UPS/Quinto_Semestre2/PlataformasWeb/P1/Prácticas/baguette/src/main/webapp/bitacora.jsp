<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*, com.productos.datos.Conexion, com.productos.negocio.*, com.productos.seguridad.Usuario"%>

<%
// DEBUG: Verificar sesión y usuario
System.out.println("=== DEBUG BITACORA.JSP ===");
Usuario usuario = (Usuario) session.getAttribute("usuario");
System.out.println("Usuario en sesión: " + usuario);

if (usuario != null) {
    System.out.println("ID: " + usuario.getId());
    System.out.println("Nombre: " + usuario.getNombre());
    System.out.println("Perfil: " + usuario.getPerfil());
    System.out.println("Correo: " + usuario.getCorreo());
} else {
    System.out.println("USUARIO ES NULL - Redirigiendo a login");
    response.sendRedirect("login.jsp");
    return;
}

// Verificar si es administrador
if (usuario.getPerfil() != 1) {
    System.out.println("PERFIL NO ES ADMIN (" + usuario.getPerfil() + ") - Redirigiendo a login");
    response.sendRedirect("login.jsp");
    return;
}

System.out.println("ACCESO PERMITIDO - Usuario es administrador");
%>

<%
// Parámetros de filtro
String filtroModulo = request.getParameter("modulo");
String filtroFecha = request.getParameter("fecha");
String buscar = request.getParameter("buscar");

List<Map<String, Object>> registros = new ArrayList<>();
int totalRegistros = 0;

try {
    Conexion con = new Conexion();
    Connection cn = con.crearConexion();
    
    System.out.println("DEBUG - Conexión a BD establecida");
    
    // Construir consulta con filtros
    StringBuilder sql = new StringBuilder(
        "SELECT b.*, u.nombre_us, u.correo_us " +
        "FROM tb_bitacora b " +
        "JOIN tb_usuario u ON b.id_usuario = u.id_us " +
        "WHERE 1=1"
    );
    
    List<Object> parametros = new ArrayList<>();
    
    if (filtroModulo != null && !filtroModulo.isEmpty()) {
        sql.append(" AND b.modulo = ?");
        parametros.add(filtroModulo);
    }
    
    if (filtroFecha != null && !filtroFecha.isEmpty()) {
        sql.append(" AND DATE(b.fecha) = ?");
        parametros.add(filtroFecha);
    }
    
    if (buscar != null && !buscar.isEmpty()) {
        sql.append(" AND (b.accion LIKE ? OR b.descripcion LIKE ? OR u.nombre_us LIKE ?)");
        String likeParam = "%" + buscar + "%";
        parametros.add(likeParam);
        parametros.add(likeParam);
        parametros.add(likeParam);
    }
    
    sql.append(" ORDER BY b.fecha DESC");
    
    System.out.println("DEBUG - SQL: " + sql.toString());
    System.out.println("DEBUG - Parámetros: " + parametros.size());
    
    PreparedStatement pst = cn.prepareStatement(sql.toString());
    
    for (int i = 0; i < parametros.size(); i++) {
        pst.setObject(i + 1, parametros.get(i));
    }
    
    ResultSet rs = pst.executeQuery();
    
    while (rs.next()) {
        Map<String, Object> registro = new HashMap<>();
        registro.put("id_bitacora", rs.getInt("id_bitacora"));
        registro.put("nombre_usuario", rs.getString("nombre_us"));
        registro.put("email", rs.getString("correo_us"));
        registro.put("accion", rs.getString("accion"));
        registro.put("modulo", rs.getString("modulo"));
        registro.put("descripcion", rs.getString("descripcion"));
        registro.put("fecha", rs.getTimestamp("fecha"));
        registro.put("ip_address", rs.getString("ip_address"));
        
        registros.add(registro);
        totalRegistros++;
    }
    
    System.out.println("DEBUG - Registros encontrados: " + totalRegistros);
    
    rs.close();
    pst.close();
    cn.close();
    
} catch (SQLException e) {
    System.out.println("ERROR en consulta: " + e.getMessage());
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitácora del Sistema - Baguette y Pastelería</title>
    
    <style>
        :root {
            --primary: #8B4513;
            --primary-dark: #654321;
            --primary-light: #D2B48C;
            --secondary: #FFF8DC;
            --accent: #A0522D;
            --text: #5D4037;
            --text-light: #8D6E63;
            --white: #FFFFFF;
            --border: #DEB887;
            --success: #4CAF50;
            --warning: #FF9800;
            --danger: #F44336;
            --info: #2196F3;
            --shadow: 0 4px 12px rgba(139, 69, 19, 0.1);
            --shadow-lg: 0 8px 32px rgba(139, 69, 19, 0.15);
            --radius: 12px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #FFF8DC 0%, #FFEBCD 100%);
            color: var(--text);
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header */
        .page-header {
            text-align: center;
            margin-bottom: 30px;
            padding: 40px 30px;
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border-left: 6px solid var(--primary);
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--primary-light));
        }

        .page-header h1 {
            color: var(--primary-dark);
            font-size: 2.8rem;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .page-header p {
            color: var(--text-light);
            font-size: 1.2rem;
            margin-bottom: 20px;
        }

        .user-info {
            background: var(--secondary);
            padding: 15px 25px;
            border-radius: 8px;
            display: inline-block;
            border: 2px solid var(--border);
        }

        .user-info strong {
            color: var(--primary-dark);
        }

        /* Filtros */
        .filters-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border: 1px solid var(--border);
        }

        .filters-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 25px;
        }

        .filters-header h3 {
            color: var(--primary-dark);
            font-size: 1.4rem;
        }

        .filters-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text);
            font-size: 0.95rem;
        }

        .form-control {
            padding: 14px 16px;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 1rem;
            background: var(--white);
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-family: inherit;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: var(--white);
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 19, 0.4);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--primary);
            border: 2px solid var(--primary);
        }

        .btn-secondary:hover {
            background: var(--primary);
            color: var(--white);
        }

        .btn-export {
            background: linear-gradient(135deg, var(--success), #45a049);
            color: var(--white);
            padding: 10px 20px;
            font-size: 0.9rem;
        }

        /* Estadísticas */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            border-left: 4px solid var(--primary);
            transition: transform 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary);
        }

        .stat-number {
            font-size: 2.8rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 10px;
            line-height: 1;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 1rem;
            font-weight: 500;
        }

        /* Tabla */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            border: 1px solid var(--border);
        }

        .table-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .table-header h3 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 600;
        }

        .table-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
        }

        .data-table th {
            background: var(--primary-light);
            color: var(--primary-dark);
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid var(--border);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 16px 15px;
            border-bottom: 1px solid var(--border);
            vertical-align: top;
        }

        .data-table tr:hover {
            background: #FFF8F0;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        /* Badges */
        .badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-productos {
            background: #E8F5E8;
            color: var(--success);
            border: 1px solid #C8E6C9;
        }

        .badge-servicios {
            background: #E3F2FD;
            color: var(--info);
            border: 1px solid #BBDEFB;
        }

        .badge-usuarios {
            background: #FFF3E0;
            color: var(--warning);
            border: 1px solid #FFE0B2;
        }

        .badge-carrito {
            background: #FCE4EC;
            color: #E91E63;
            border: 1px solid #F8BBD0;
        }

        .badge-seguridad {
            background: #FFF8E1;
            color: #FFC107;
            border: 1px solid #FFECB3;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }

            .filters-form {
                grid-template-columns: 1fr;
            }

            .data-table {
                display: block;
                overflow-x: auto;
            }

            .page-header h1 {
                font-size: 2.2rem;
            }

            .table-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .table-actions {
                justify-content: center;
            }

            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }

            .stat-number {
                font-size: 2.2rem;
            }
        }

        /* Animaciones */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .stat-card, .filters-card, .table-container {
            animation: fadeIn 0.6s ease forwards;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: var(--text-light);
        }

        .empty-state .icon {
            font-size: 5rem;
            margin-bottom: 25px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--text);
        }

        .empty-state p {
            font-size: 1.1rem;
        }

        /* Timestamp */
        .timestamp {
            font-size: 0.85rem;
            color: var(--text-light);
            white-space: nowrap;
        }

        .timestamp-detalle {
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            background: #f5f5f5;
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
            text-align: center;
            line-height: 1.4;
        }

        .fecha {
            font-weight: 600;
            color: var(--primary-dark);
            display: block;
        }

        .hora {
            color: var(--text-light);
            font-size: 0.8rem;
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="page-header">
            <h1>📊 Bitácora del Sistema</h1>
            <p>Registro completo de todas las actividades administrativas</p>
            <div class="user-info">
                <strong>Usuario:</strong> <%= usuario.getNombre() %> | 
                <strong>Correo:</strong> <%= usuario.getCorreo() %> | 
                <strong>Perfil:</strong> Administrador
            </div>
        </div>

        <!-- Filtros -->
        <div class="filters-card">
            <div class="filters-header">
                <h3>🔍 Filtros de Búsqueda</h3>
                <div class="table-actions">
                    <button class="btn btn-export" onclick="exportarCSV()">
                        📥 Exportar CSV
                    </button>
                </div>
            </div>
            <form method="get" class="filters-form">
                <div class="form-group">
                    <label for="modulo">Módulo</label>
                    <select id="modulo" name="modulo" class="form-control">
                        <option value="">Todos los módulos</option>
                        <option value="PRODUCTOS" <%= "PRODUCTOS".equals(filtroModulo) ? "selected" : "" %>>Productos</option>
                        <option value="SERVICIOS" <%= "SERVICIOS".equals(filtroModulo) ? "selected" : "" %>>Servicios</option>
                        <option value="USUARIOS" <%= "USUARIOS".equals(filtroModulo) ? "selected" : "" %>>Usuarios</option>
                        <option value="CARRITO" <%= "CARRITO".equals(filtroModulo) ? "selected" : "" %>>Carrito</option>
                        <option value="SEGURIDAD" <%= "SEGURIDAD".equals(filtroModulo) ? "selected" : "" %>>Seguridad</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="fecha">Fecha</label>
                    <input type="date" id="fecha" name="fecha" value="<%= filtroFecha != null ? filtroFecha : "" %>" class="form-control">
                </div>

                <div class="form-group">
                    <label for="buscar">Buscar en contenido</label>
                    <input type="text" id="buscar" name="buscar" value="<%= buscar != null ? buscar : "" %>" 
                           placeholder="Acción, descripción o usuario..." class="form-control">
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">
                        🔍 Aplicar Filtros
                    </button>
                    <a href="bitacora.jsp" class="btn btn-secondary" style="margin-top: 10px;">
                        🗑️ Limpiar Filtros
                    </a>
                </div>
            </form>
        </div>

        <!-- Estadísticas -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalRegistros %></div>
                <div class="stat-label">Total de Registros</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= calcularRegistrosHoy() %></div>
                <div class="stat-label">Registros de Hoy</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= calcularRegistrosModulo("PRODUCTOS") %></div>
                <div class="stat-label">Actividades de Productos</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= calcularRegistrosModulo("USUARIOS") %></div>
                <div class="stat-label">Actividades de Usuarios</div>
            </div>
        </div>

        <!-- Tabla de Registros -->
        <div class="table-container">
            <div class="table-header">
                <h3>📋 Registros de Actividad del Sistema</h3>
                <div class="table-actions">
                    <span class="total-counter"><%= totalRegistros %> registros encontrados</span>
                </div>
            </div>

            <% if (registros.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">📝</div>
                    <h3>No se encontraron registros</h3>
                    <p>Intenta ajustar los filtros de búsqueda para ver más resultados</p>
                </div>
            <% } else { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Usuario</th>
                            <th>Módulo</th>
                            <th>Acción</th>
                            <th>Descripción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> registro : registros) { 
                            String modulo = (String) registro.get("modulo");
                            String badgeClass = "badge-seguridad";
                            
                            if (modulo != null) {
                                switch(modulo) {
                                    case "PRODUCTOS": badgeClass = "badge-productos"; break;
                                    case "SERVICIOS": badgeClass = "badge-servicios"; break;
                                    case "USUARIOS": badgeClass = "badge-usuarios"; break;
                                    case "CARRITO": badgeClass = "badge-carrito"; break;
                                    case "SEGURIDAD": badgeClass = "badge-seguridad"; break;
                                }
                            }
                            
                            Timestamp fecha = (Timestamp) registro.get("fecha");
                            String fechaStr = "";
                            String horaStr = "";
                            if (fecha != null) {
                                fechaStr = new java.text.SimpleDateFormat("dd/MM/yyyy").format(fecha);
                                horaStr = new java.text.SimpleDateFormat("HH:mm:ss").format(fecha);
                            }
                        %>
                        <tr>
                            <td>
                                <div class="timestamp-detalle">
                                    <span class="fecha"><%= fechaStr %></span>
                                </div>
                            </td>
                            <td>
                                <div class="timestamp-detalle">
                                    <span class="hora"><%= horaStr %></span>
                                </div>
                            </td>
                            <td>
                                <div style="font-weight: 600;"><%= registro.get("nombre_usuario") != null ? registro.get("nombre_usuario") : "N/A" %></div>
                                <div style="font-size: 0.85rem; color: var(--text-light);"><%= registro.get("email") != null ? registro.get("email") : "" %></div>
                            </td>
                            <td>
                                <% if (modulo != null) { %>
                                <span class="badge <%= badgeClass %>">
                                    <%= modulo %>
                                </span>
                                <% } %>
                            </td>
                            <td style="font-weight: 600; color: var(--primary-dark);">
                                <%= registro.get("accion") != null ? registro.get("accion") : "" %>
                            </td>
                            <td style="max-width: 300px; word-wrap: break-word;">
                                <%= registro.get("descripcion") != null ? registro.get("descripcion") : "" %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>

    <script>
        // Exportar a CSV
        function exportarCSV() {
            alert('La funcionalidad de exportación CSV estará disponible próximamente');
        }

        // Auto-recargar cada 5 minutos para ver registros nuevos
        setTimeout(function() {
            if (!document.hidden) {
                window.location.reload();
            }
        }, 300000); // 5 minutos

        // Mejorar la experiencia de filtros
        document.addEventListener('DOMContentLoaded', function() {
            const fechaInput = document.getElementById('fecha');
            if (!fechaInput.value) {
                const today = new Date().toISOString().split('T')[0];
                fechaInput.value = today;
            }
        });
    </script>
</body>
</html>

<%!
// Métodos para calcular estadísticas
public int calcularRegistrosHoy() {
    try {
        Conexion con = new Conexion();
        Connection cn = con.crearConexion();
        String sql = "SELECT COUNT(*) as total FROM tb_bitacora WHERE DATE(fecha) = CURRENT_DATE";
        PreparedStatement pst = cn.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            return rs.getInt("total");
        }
        rs.close();
        pst.close();
        cn.close();
    } catch (Exception e) {
        System.out.println("ERROR calcularRegistrosHoy: " + e.getMessage());
    }
    return 0;
}

public int calcularRegistrosModulo(String modulo) {
    try {
        Conexion con = new Conexion();
        Connection cn = con.crearConexion();
        String sql = "SELECT COUNT(*) as total FROM tb_bitacora WHERE modulo = ?";
        PreparedStatement pst = cn.prepareStatement(sql);
        pst.setString(1, modulo);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            return rs.getInt("total");
        }
        rs.close();
        pst.close();
        cn.close();
    } catch (Exception e) {
        System.out.println("ERROR calcularRegistrosModulo: " + e.getMessage());
    }
    return 0;
}
%>