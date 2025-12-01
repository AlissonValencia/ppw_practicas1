<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*, com.productos.datos.Conexion"%>

<%
Conexion con = new Conexion();
Connection cn = con.crearConexion();

/* ----- LEER PRODUCTOS ----- */
List<Map<String,Object>> listaProd = new ArrayList<>();

String sqlProductos = "SELECT id_pr, nombre_pr, precio_pr, cantidad_pr, foto_pr FROM tb_producto";
PreparedStatement pstProd = cn.prepareStatement(sqlProductos);
ResultSet rsProd = pstProd.executeQuery();

while (rsProd.next()) {
    Map<String,Object> p = new HashMap<>();
    p.put("id", rsProd.getInt("id_pr"));
    p.put("nombre", rsProd.getString("nombre_pr"));
    p.put("precio", rsProd.getDouble("precio_pr"));
    p.put("stock", rsProd.getInt("cantidad_pr"));

    String foto = rsProd.getString("foto_pr");
    p.put("foto", (foto == null || foto.trim().equals("")) ? "noimg.glb" : foto);

    listaProd.add(p);
}
rsProd.close();
pstProd.close();

/* COMPLETAR 10 PRODUCTOS */
while (listaProd.size() < 10 && listaProd.size() > 0) {
    listaProd.add(listaProd.get(listaProd.size() % listaProd.size()));
}

/* ----- LEER SERVICIOS ----- */
List<Map<String,Object>> listaServ = new ArrayList<>();

String sqlServicios = "SELECT id_ser, nombre_ser, precio_base, foto_ser FROM tb_servicio";
PreparedStatement pstServ = cn.prepareStatement(sqlServicios);
ResultSet rsServ = pstServ.executeQuery();

while (rsServ.next()) {
    Map<String,Object> s = new HashMap<>();
    s.put("id", rsServ.getInt("id_ser"));
    s.put("nombre", rsServ.getString("nombre_ser"));
    s.put("precio", rsServ.getDouble("precio_base"));

    String foto = rsServ.getString("foto_ser");
    s.put("foto", (foto == null || foto.trim().equals("")) ? "noimg.glb" : foto);

    listaServ.add(s);
}
rsServ.close();
pstServ.close();

/* COMPLETAR 10 SERVICIOS */
while (listaServ.size() < 10 && listaServ.size() > 0) {
    listaServ.add(listaServ.get(listaServ.size() % listaServ.size()));
}

cn.close();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo Pedido - Panadería Artesanal</title>

    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>

    <style>
        :root {
            --primary: #a08069;
            --primary-dark: #795548;
            --primary-light: #d7ccc8;
            --secondary: #fcf8f0;
            --accent: #8d6e63;
            --text: #5d4037;
            --text-light: #8d6e63;
            --white: #ffffff;
            --border: #e0c9a6;
            --success: #4caf50;
            --warning: #ff9800;
            --danger: #f44336;
            --shadow: 0 4px 12px rgba(0,0,0,0.1);
            --shadow-lg: 0 8px 32px rgba(0,0,0,0.15);
            --radius: 16px;
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
            padding: 0;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header */
        .page-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px 0;
            position: relative;
        }

        .page-header h1 {
            color: var(--primary-dark);
            font-size: 2.8rem;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .page-header p {
            color: var(--text-light);
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Back Button */
        .back-button {
            position: absolute;
            top: 30px;
            left: 0;
            background: var(--primary);
            color: var(--white);
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: var(--shadow);
        }

        .back-button:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Navigation Tabs */
        .category-tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 40px;
            gap: 10px;
        }

        .tab-btn {
            background: var(--white);
            border: 2px solid var(--border);
            padding: 12px 30px;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-light);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .tab-btn.active {
            background: var(--primary);
            color: var(--white);
            border-color: var(--primary);
        }

        .tab-btn:hover:not(.active) {
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Grid Layout */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
        }

        /* Product Cards */
        .product-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .product-card.featured {
            border: 2px solid var(--primary);
        }

        .product-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--primary);
            color: var(--white);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            z-index: 2;
        }

        .model-container {
            width: 100%;
            height: 220px;
            background: linear-gradient(135deg, #f5f5f5, #e0e0e0);
            position: relative;
            overflow: hidden;
        }

        model-viewer {
            width: 100%;
            height: 100%;
        }

        .product-info {
            padding: 20px;
        }

        .product-title {
            color: var(--primary-dark);
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 8px;
            line-height: 1.3;
        }

        .product-price {
            color: var(--primary);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .product-stock {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 15px;
        }

        .stock-available {
            color: var(--success);
        }

        .stock-low {
            color: var(--warning);
        }

        .stock-out {
            color: var(--danger);
        }

        /* Quantity Controls */
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 15px;
        }

        .qty-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid var(--border);
            background: var(--white);
            color: var(--primary);
            font-size: 1.2rem;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .qty-btn:hover:not(:disabled) {
            background: var(--primary);
            color: var(--white);
            border-color: var(--primary);
        }

        .qty-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .quantity-input {
            width: 60px;
            height: 40px;
            border: 2px solid var(--border);
            border-radius: 8px;
            text-align: center;
            font-size: 1.1rem;
            font-weight: 600;
            background: var(--white);
        }

        .quantity-input:focus {
            outline: none;
            border-color: var(--primary);
        }

        /* Error Message */
        .error-msg {
            color: var(--danger);
            font-size: 0.8rem;
            margin-top: 8px;
            display: none;
            text-align: center;
        }

        /* Cart Summary */
        .cart-summary {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: var(--white);
            padding: 20px;
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            z-index: 1000;
            min-width: 250px;
        }

        .cart-summary h3 {
            color: var(--primary-dark);
            margin-bottom: 10px;
            font-size: 1.2rem;
        }

        .cart-items-count {
            color: var(--text-light);
            margin-bottom: 15px;
        }

        .cart-total {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 15px;
        }

        .submit-btn {
            background: var(--primary);
            color: var(--white);
            border: none;
            padding: 15px 25px;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }

        .submit-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        /* Category Sections */
        .category-section {
            display: none;
        }

        .category-section.active {
            display: block;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-light);
        }

        .empty-state .icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .products-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }

            .page-header h1 {
                font-size: 2.2rem;
            }

            .back-button {
                position: relative;
                top: auto;
                left: auto;
                margin-bottom: 20px;
                display: inline-block;
            }

            .category-tabs {
                flex-wrap: wrap;
            }

            .products-grid {
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 15px;
            }

            .cart-summary {
                position: static;
                margin-top: 30px;
            }
        }

        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .product-card {
            animation: fadeIn 0.5s ease forwards;
        }

        /* Loading States */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .pulse {
            animation: pulse 1.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.6; }
            100% { opacity: 1; }
        }
    </style>
</head>

<body>
    <div class="container">
        <!-- Header with Back Button -->
        <div class="page-header">
            <a href="menu.jsp" class="back-button">
                &#11013; Volver al menú
            </a>
            <h1>🍞 Realizar Nuevo Pedido</h1>
            <p>Descubre nuestros productos artesanales y servicios especializados</p>
        </div>

        <!-- Navigation Tabs -->
        <div class="category-tabs">
            <button class="tab-btn active" onclick="showCategory('productos')">🥖 Productos</button>
            <button class="tab-btn" onclick="showCategory('servicios')">🎂 Servicios</button>
            <button class="tab-btn" onclick="showCategory('todos')">📦 Todos los Items</button>
        </div>

        <form action="guardarCarrito.jsp" method="post" id="orderForm">
            <!-- Productos Section -->
            <div class="category-section active" id="productos-section">
                <h2 style="color: var(--primary-dark); margin-bottom: 25px; font-size: 1.8rem;">Nuestros Productos</h2>
                
                <div class="products-grid">
                    <%
                    for (int i = 0; i < listaProd.size(); i++) {
                        Map<String,Object> p = listaProd.get(i);
                        // 🔥 CAMBIO: Usar "cant_" en lugar de "prod_" para que coincida con guardarCarrito.jsp
                        String idCampo = "cant_" + p.get("id");
                        int stock = (Integer) p.get("stock");
                        String stockClass = stock > 10 ? "stock-available" : stock > 0 ? "stock-low" : "stock-out";
                        String stockText = stock > 10 ? "Disponible" : stock > 0 ? "Últimas unidades" : "Agotado";
                    %>
                    <div class="product-card <%= i < 3 ? "featured" : "" %>">
                        <% if (i < 3) { %>
                        <div class="product-badge">⭐ Popular</div>
                        <% } %>
                        
                        <div class="model-container">
                            <model-viewer 
                                src="imagenes/3d/<%= p.get("foto") %>" 
                                alt="<%= p.get("nombre") %>"
                                auto-rotate 
                                camera-controls
                                environment-image="neutral"
                                shadow-intensity="1">
                            </model-viewer>
                        </div>

                        <div class="product-info">
                            <h3 class="product-title"><%= p.get("nombre") %></h3>
                            <div class="product-price">$<%= String.format("%.2f", p.get("precio")) %></div>
                            <div class="product-stock <%= stockClass %>">📦 <%= stockText %> (<%= stock %> en stock)</div>

                            <div class="quantity-controls">
                                <button type="button" class="qty-btn" onclick="restar('<%= idCampo %>')" <%= stock == 0 ? "disabled" : "" %>>
                                    −
                                </button>
                                
                                <input type="number" 
                                       id="<%= idCampo %>" 
                                       name="<%= idCampo %>"
                                       value="0" 
                                       min="0" 
                                       max="<%= stock %>" 
                                       readonly 
                                       class="quantity-input"
                                       <%= stock == 0 ? "disabled" : "" %>>

                                <button type="button" class="qty-btn" onclick="sumar('<%= idCampo %>', <%= stock %>)" <%= stock == 0 ? "disabled" : "" %>>
                                    +
                                </button>
                            </div>

                            <div id="err_<%= idCampo %>" class="error-msg">
                                No puedes exceder el stock disponible
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Servicios Section -->
            <div class="category-section" id="servicios-section">
                <h2 style="color: var(--primary-dark); margin-bottom: 25px; font-size: 1.8rem;">Nuestros Servicios</h2>
                
                <div class="products-grid">
                    <%
                    for (int i = 0; i < listaServ.size(); i++) {
                        Map<String,Object> s = listaServ.get(i);
                        // 🔥 CAMBIO: Usar "serv_" para servicios (igual que antes)
                        String idCampo = "serv_" + s.get("id");
                    %>
                    <div class="product-card <%= i < 2 ? "featured" : "" %>">
                        <% if (i < 2) { %>
                        <div class="product-badge">🔥 Destacado</div>
                        <% } %>
                        
                        <div class="model-container">
                            <model-viewer 
                                src="imagenes/3d/<%= s.get("foto") %>" 
                                alt="<%= s.get("nombre") %>"
                                auto-rotate 
                                camera-controls
                                environment-image="neutral"
                                shadow-intensity="1">
                            </model-viewer>
                        </div>

                        <div class="product-info">
                            <h3 class="product-title"><%= s.get("nombre") %></h3>
                            <div class="product-price">$<%= String.format("%.2f", s.get("precio")) %></div>
                            <div class="product-stock stock-available">✅ Disponible</div>

                            <div class="quantity-controls">
                                <button type="button" class="qty-btn" onclick="restar('<%= idCampo %>')">
                                    −
                                </button>
                                
                                <input type="number" 
                                       id="<%= idCampo %>" 
                                       name="<%= idCampo %>"
                                       value="0" 
                                       min="0" 
                                       readonly 
                                       class="quantity-input">

                                <button type="button" class="qty-btn" onclick="sumar('<%= idCampo %>', 50)">
                                    +
                                </button>
                            </div>

                            <div id="err_<%= idCampo %>" class="error-msg">
                                Límite máximo alcanzado
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Todos Section -->
            <div class="category-section" id="todos-section">
                <h2 style="color: var(--primary-dark); margin-bottom: 25px; font-size: 1.8rem;">Todos los Productos y Servicios</h2>
                
                <div class="products-grid">
                    <!-- Products -->
                    <% for (Map<String,Object> p : listaProd) { 
                        // 🔥 CAMBIO: Usar "cant_" en lugar de "prod_" para productos
                        String idCampo = "cant_" + p.get("id");
                        int stock = (Integer) p.get("stock");
                        String stockClass = stock > 10 ? "stock-available" : stock > 0 ? "stock-low" : "stock-out";
                        String stockText = stock > 10 ? "Disponible" : stock > 0 ? "Últimas unidades" : "Agotado";
                    %>
                    <div class="product-card">
                        <div class="product-badge">🥖 Producto</div>
                        <div class="model-container">
                            <model-viewer src="imagenes/3d/<%= p.get("foto") %>" auto-rotate camera-controls></model-viewer>
                        </div>
                        <div class="product-info">
                            <h3 class="product-title"><%= p.get("nombre") %></h3>
                            <div class="product-price">$<%= String.format("%.2f", p.get("precio")) %></div>
                            <div class="product-stock <%= stockClass %>">📦 <%= stockText %></div>
                            <div class="quantity-controls">
                                <button type="button" class="qty-btn" onclick="restar('<%= idCampo %>')" <%= stock == 0 ? "disabled" : "" %>>−</button>
                                <input type="number" id="<%= idCampo %>" name="<%= idCampo %>" value="0" min="0" max="<%= stock %>" readonly class="quantity-input" <%= stock == 0 ? "disabled" : "" %>>
                                <button type="button" class="qty-btn" onclick="sumar('<%= idCampo %>', <%= stock %>)" <%= stock == 0 ? "disabled" : "" %>>+</button>
                            </div>
                            <div id="err_<%= idCampo %>" class="error-msg">No puedes exceder el stock</div>
                        </div>
                    </div>
                    <% } %>

                    <!-- Services -->
                    <% for (Map<String,Object> s : listaServ) { 
                        // 🔥 CAMBIO: Usar "serv_" para servicios (igual que antes)
                        String idCampo = "serv_" + s.get("id");
                    %>
                    <div class="product-card">
                        <div class="product-badge">🎂 Servicio</div>
                        <div class="model-container">
                            <model-viewer src="imagenes/3d/<%= s.get("foto") %>" auto-rotate camera-controls></model-viewer>
                        </div>
                        <div class="product-info">
                            <h3 class="product-title"><%= s.get("nombre") %></h3>
                            <div class="product-price">$<%= String.format("%.2f", s.get("precio")) %></div>
                            <div class="product-stock stock-available">✅ Disponible</div>
                            <div class="quantity-controls">
                                <button type="button" class="qty-btn" onclick="restar('<%= idCampo %>')">−</button>
                                <input type="number" id="<%= idCampo %>" name="<%= idCampo %>" value="0" min="0" readonly class="quantity-input">
                                <button type="button" class="qty-btn" onclick="sumar('<%= idCampo %>', 50)">+</button>
                            </div>
                            <div id="err_<%= idCampo %>" class="error-msg">Límite máximo</div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Cart Summary -->
            <div class="cart-summary">
                <h3>🛒 Resumen del Carrito</h3>
                <div class="cart-items-count" id="cartCount">0 items seleccionados</div>
                <div class="cart-total" id="cartTotal">Total: $0.00</div>
                <button type="submit" class="submit-btn" onclick="confirmarCarrito()">
                    Agregar al Carrito
                </button>
                <a href="menu.jsp" style="display: block; text-align: center; margin-top: 10px; color: var(--primary); text-decoration: none; font-weight: 600;">
                    &#11013; Volver al menú
                </a>
            </div>
        </form>
    </div>

    <script>
        // Category Navigation
        function showCategory(category) {
            // Update tabs
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Show selected section
            document.querySelectorAll('.category-section').forEach(section => section.classList.remove('active'));
            document.getElementById(category + '-section').classList.add('active');
            
            // Update cart summary position
            updateCartSummary();
        }

        // Quantity Functions
        function sumar(id, max) {
            let box = document.getElementById(id);
            let current = parseInt(box.value);
            if (current < max) {
                box.value = current + 1;
                updateCartSummary();
            } else {
                mostrarError(id);
            }
        }

        function restar(id) {
            let box = document.getElementById(id);
            let current = parseInt(box.value);
            if (current > 0) {
                box.value = current - 1;
                updateCartSummary();
            }
        }

        function mostrarError(id) {
            let error = document.getElementById("err_" + id);
            error.style.display = 'block';
            setTimeout(() => error.style.display = 'none', 2000);
        }

        // Cart Summary
        function updateCartSummary() {
            let totalItems = 0;
            let totalPrice = 0;
            
            // Count all quantity inputs
            document.querySelectorAll('input[type="number"]').forEach(input => {
                if (!input.disabled) {
                    let quantity = parseInt(input.value) || 0;
                    totalItems += quantity;
                    
                    // Find price from the product card
                    let card = input.closest('.product-card');
                    if (card) {
                        let priceElement = card.querySelector('.product-price');
                        if (priceElement) {
                            let priceText = priceElement.textContent.replace('$', '').trim();
                            let price = parseFloat(priceText) || 0;
                            totalPrice += price * quantity;
                        }
                    }
                }
            });
            
            // Update display
            document.getElementById('cartCount').textContent = totalItems + ' item' + (totalItems !== 1 ? 's' : '') + ' seleccionado' + (totalItems !== 1 ? 's' : '');
            document.getElementById('cartTotal').textContent = 'Total: $' + totalPrice.toFixed(2);
        }

        // Form Submission
        function confirmarCarrito() {
            let totalItems = 0;
            document.querySelectorAll('input[type="number"]').forEach(input => {
                totalItems += parseInt(input.value) || 0;
            });
            
            if (totalItems === 0) {
                alert('⚠️ Por favor, selecciona al menos un producto o servicio antes de continuar.');
                event.preventDefault();
            } else {
                alert('✅ ¡Productos agregados al carrito correctamente!');
                // Form will submit normally
            }
        }

        // Initialize cart summary
        document.addEventListener('DOMContentLoaded', function() {
            updateCartSummary();
            
            // Add input event listeners for manual updates
            document.querySelectorAll('input[type="number"]').forEach(input => {
                input.addEventListener('change', updateCartSummary);
            });
        });

        // Model viewer error handling
        document.addEventListener('DOMContentLoaded', function() {
            const modelViewers = document.querySelectorAll('model-viewer');
            modelViewers.forEach(viewer => {
                viewer.addEventListener('error', (e) => {
                    console.log('Error loading 3D model:', e);
                    viewer.style.background = 'linear-gradient(135deg, #e0c9a6, #d7ccc8)';
                });
            });
        });
    </script>
</body>
</html>