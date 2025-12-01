<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.productos.negocio.Carrito"%>
<%@page import="com.productos.negocio.ItemCarrito"%>
<%@page import="com.productos.seguridad.Usuario"%>
<%@page import="com.productos.negocio.Bitacora"%>
<%@page import="java.text.DecimalFormat"%>

<%
// Obtener usuario de sesión para bitácora
Usuario usuario = (Usuario) session.getAttribute("usuario");

// Registrar acceso al carrito en bitácora
if (usuario != null) {
    Bitacora bitacora = new Bitacora();
    bitacora.registrarBitacora(usuario.getId(), "ACCESO", "CARRITO", 
        "Accedió al carrito de compras", request);
}

Carrito carrito = (Carrito) session.getAttribute("carrito");
DecimalFormat df = new DecimalFormat("#,##0.00");

if (carrito == null || carrito.getItems().size() == 0) {
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrito Vacío - Panadería Artesanal</title>
    <style>
        :root {
            --primary: #a08069;
            --primary-dark: #795548;
            --secondary: #fcf8f0;
            --text: #5d4037;
            --text-light: #8d6e63;
            --white: #ffffff;
            --border: #e0c9a6;
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 40px;
            max-width: 500px;
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        
        .empty-icon {
            font-size: 6rem;
            margin-bottom: 25px;
            opacity: 0.7;
        }
        
        .empty-cart h2 {
            color: var(--primary-dark);
            margin-bottom: 15px;
            font-size: 2rem;
        }
        
        .empty-cart p {
            color: var(--text-light);
            margin-bottom: 35px;
            font-size: 1.2rem;
        }
        
        .btn-primary {
            background: var(--primary);
            color: var(--white);
            padding: 16px 35px;
            border-radius: 12px;
            text-decoration: none;
            display: inline-block;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(160, 128, 105, 0.3);
        }
    </style>
</head>
<body>
    <div class="empty-cart">
        <div class="empty-icon">🛒</div>
        <h2>Tu carrito está vacío</h2>
        <p>Agrega algunos productos deliciosos a tu pedido</p>
        <a href="nuevo_pedido.jsp" class="btn-primary">Explorar Productos</a>
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
<title>Mi Carrito - Panadería Artesanal</title>

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
    --danger: #f44336;
    --shadow: 0 4px 12px rgba(0,0,0,0.1);
    --shadow-lg: 0 8px 32px rgba(0,0,0,0.1);
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
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

/* Header */
.cart-header {
    text-align: center;
    margin-bottom: 40px;
    padding: 30px 0;
}

.cart-header h1 {
    color: var(--primary-dark);
    font-size: 2.8rem;
    margin-bottom: 10px;
    font-weight: 700;
}

.cart-header p {
    color: var(--text-light);
    font-size: 1.2rem;
}

.cart-count {
    background: var(--primary);
    color: white;
    padding: 5px 15px;
    border-radius: 20px;
    font-size: 0.9rem;
    margin-left: 10px;
}

/* Layout */
.cart-layout {
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 40px;
    align-items: start;
}

/* Cart Items */
.cart-items {
    background: var(--white);
    border-radius: 20px;
    box-shadow: var(--shadow-lg);
    overflow: hidden;
}

.cart-items-header {
    background: var(--primary);
    color: white;
    padding: 20px 25px;
    font-size: 1.3rem;
    font-weight: 600;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.cart-item {
    display: grid;
    grid-template-columns: 1fr auto auto;
    gap: 25px;
    padding: 25px;
    border-bottom: 1px solid var(--border);
    align-items: center;
    transition: all 0.3s ease;
    position: relative;
}

.cart-item:hover {
    background-color: #fffaf3;
    transform: translateX(5px);
}

.cart-item:last-child {
    border-bottom: none;
}

.item-details {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.item-details h3 {
    color: var(--primary-dark);
    font-size: 1.3rem;
    font-weight: 600;
    margin: 0;
}

.item-category {
    font-size: 0.9rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-weight: 600;
    padding: 4px 12px;
    border-radius: 15px;
    display: inline-block;
    width: fit-content;
}

.item-category.producto {
    background: #e8f5e8;
    color: #2e7d32;
    border: 1px solid #c8e6c9;
}

.item-category.servicio {
    background: #e3f2fd;
    color: #1565c0;
    border: 1px solid #bbdefb;
}

.item-price {
    color: var(--text-light);
    font-weight: 600;
    font-size: 1.1rem;
}

.item-quantity {
    display: flex;
    align-items: center;
    gap: 12px;
    background: #f8f9fa;
    padding: 8px 12px;
    border-radius: 10px;
}

.quantity-btn {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid var(--border);
    background: var(--white);
    color: var(--primary);
    font-weight: bold;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    font-size: 1.1rem;
}

.quantity-btn:hover {
    background: var(--primary);
    color: var(--white);
    transform: scale(1.1);
}

.quantity-display {
    font-weight: 700;
    min-width: 30px;
    text-align: center;
    font-size: 1.1rem;
}

.item-subtotal {
    font-weight: 700;
    color: var(--primary-dark);
    font-size: 1.3rem;
    text-align: right;
}

.remove-btn {
    position: absolute;
    top: 15px;
    right: 15px;
    background: none;
    border: none;
    color: var(--text-light);
    cursor: pointer;
    font-size: 1.2rem;
    transition: color 0.3s ease;
}

.remove-btn:hover {
    color: var(--danger);
}

/* Summary Card */
.summary-card {
    background: var(--white);
    border-radius: 20px;
    box-shadow: var(--shadow-lg);
    padding: 30px;
    position: sticky;
    top: 20px;
}

.summary-card h2 {
    color: var(--primary-dark);
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 2px solid var(--border);
    font-size: 1.5rem;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 15px;
    padding: 12px 0;
    font-size: 1.1rem;
}

.summary-row.highlight {
    background: #f8f9fa;
    padding: 15px;
    border-radius: 10px;
    margin: 20px -15px;
}

.summary-row.total {
    font-size: 1.4rem;
    font-weight: 700;
    color: var(--primary-dark);
    border-top: 2px solid var(--border);
    padding-top: 20px;
    margin-top: 15px;
}

/* Payment Form */
.payment-form {
    margin-top: 30px;
    padding-top: 30px;
    border-top: 2px solid var(--border);
}

.payment-form h3 {
    color: var(--primary-dark);
    margin-bottom: 25px;
    font-size: 1.3rem;
}

.form-group {
    margin-bottom: 25px;
}

.form-group label {
    display: block;
    margin-bottom: 10px;
    font-weight: 600;
    color: var(--text);
    font-size: 1rem;
}

.form-control {
    width: 100%;
    padding: 15px 20px;
    border: 2px solid var(--border);
    border-radius: 12px;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: #fcfcfc;
}

.form-control:focus {
    outline: none;
    border-color: var(--primary);
    background: var(--white);
    box-shadow: 0 0 0 3px rgba(160, 128, 105, 0.1);
}

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
}

.card-type-display {
    background: var(--secondary);
    padding: 15px 20px;
    border-radius: 12px;
    font-weight: 600;
    color: var(--primary-dark);
    text-align: center;
    border: 2px solid var(--border);
    font-size: 1.1rem;
}

/* Buttons */
.btn-primary {
    background: var(--primary);
    color: var(--white);
    border: none;
    padding: 18px 25px;
    border-radius: 12px;
    font-size: 1.2rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    width: 100%;
    text-align: center;
    display: block;
    text-decoration: none;
    margin-top: 10px;
}

.btn-primary:hover {
    background: var(--primary-dark);
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(160, 128, 105, 0.3);
}

.btn-secondary {
    background: transparent;
    color: var(--primary);
    border: 2px solid var(--primary);
    padding: 15px 25px;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-block;
    text-align: center;
    width: 100%;
    margin-top: 15px;
}

.btn-secondary:hover {
    background: var(--primary);
    color: var(--white);
    transform: translateY(-2px);
}

/* Responsive */
@media (max-width: 968px) {
    .cart-layout {
        grid-template-columns: 1fr;
        gap: 30px;
    }
    
    .cart-item {
        grid-template-columns: 1fr auto;
        grid-template-rows: auto auto;
        gap: 20px;
    }
    
    .item-quantity {
        grid-column: 1;
        justify-self: start;
    }
    
    .item-subtotal {
        grid-column: 2;
        grid-row: 1;
        justify-self: end;
    }
}

@media (max-width: 768px) {
    .container {
        padding: 15px;
    }
    
    .cart-header h1 {
        font-size: 2.2rem;
    }
    
    .cart-item {
        padding: 20px;
        grid-template-columns: 1fr;
        text-align: center;
    }
    
    .item-subtotal {
        justify-self: center;
        grid-column: 1;
        grid-row: 3;
    }
    
    .item-quantity {
        justify-self: center;
    }
    
    .form-row {
        grid-template-columns: 1fr;
    }
}

/* Animations */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.cart-item {
    animation: fadeIn 0.5s ease forwards;
}

/* Progress Bar */
.checkout-progress {
    display: flex;
    justify-content: space-between;
    margin-bottom: 40px;
    position: relative;
    max-width: 500px;
    margin-left: auto;
    margin-right: auto;
}

.checkout-progress::before {
    content: '';
    position: absolute;
    top: 15px;
    left: 0;
    right: 0;
    height: 2px;
    background: var(--border);
    z-index: 1;
}

.progress-step {
    position: relative;
    z-index: 2;
    text-align: center;
    flex: 1;
}

.progress-step .step-number {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: var(--white);
    border: 2px solid var(--border);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 8px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.progress-step.active .step-number {
    background: var(--primary);
    border-color: var(--primary);
    color: white;
}

.progress-step .step-label {
    font-size: 0.9rem;
    color: var(--text-light);
}

.progress-step.active .step-label {
    color: var(--primary-dark);
    font-weight: 600;
}
</style>
</head>

<body>
    <div class="container">
        <!-- Header -->
        <div class="cart-header">
            <h1>🛒 Mi Carrito <span class="cart-count"><%= carrito.getItems().size() %> items</span></h1>
            <p>Revisa tu pedido y completa tu compra</p>
        </div>

        <!-- Checkout Progress -->
        <div class="checkout-progress">
            <div class="progress-step active">
                <div class="step-number">1</div>
                <div class="step-label">Carrito</div>
            </div>
            <div class="progress-step">
                <div class="step-number">2</div>
                <div class="step-label">Pago</div>
            </div>
            <div class="progress-step">
                <div class="step-number">3</div>
                <div class="step-label">Confirmación</div>
            </div>
        </div>

        <div class="cart-layout">
            <!-- Cart Items -->
            <div class="cart-items">
                <div class="cart-items-header">
                    <span>Tu Pedido</span>
                    <span><%= carrito.getItems().size() %> productos</span>
                </div>
                
                <%
                for (ItemCarrito item : carrito.getItems()) {
                    // CORREGIDO: Determinar correctamente si es PRODUCTO o SERVICIO
                    String categoria = "PRODUCTO";
                    String claseCss = "producto";
                    
                    // Si el ID está en el rango de servicios (por ejemplo, IDs mayores a 1000)
                    // o si el nombre contiene "servicio" o palabras relacionadas
                    if (item.getId() >= 1000 || 
                        (item.getNombre() != null && 
                         (item.getNombre().toLowerCase().contains("servicio") ||
                          item.getNombre().toLowerCase().contains("catering") ||
                          item.getNombre().toLowerCase().contains("evento") ||
                          item.getNombre().toLowerCase().contains("entrega")))) {
                        categoria = "SERVICIO";
                        claseCss = "servicio";
                    }
                %>
                <div class="cart-item">
                    <button class="remove-btn" title="Eliminar producto">×</button>
                    
                    <div class="item-details">
                        <h3><%= item.getNombre() %></h3>
                        <div class="item-category <%= claseCss %>">
                            <%= categoria %>
                        </div>
                        <div class="item-price">$<%= df.format(item.getPrecio()) %> c/u</div>
                    </div>
                    
                    <div class="item-quantity">
                        <button class="quantity-btn" onclick="updateQuantity(<%= item.getId() %>, -1)">-</button>
                        <span class="quantity-display"><%= item.getCantidad() %></span>
                        <button class="quantity-btn" onclick="updateQuantity(<%= item.getId() %>, 1)">+</button>
                    </div>
                    
                    <div class="item-subtotal">
                        $<%= df.format(item.getSubtotal()) %>
                    </div>
                </div>
                <%
                }
                %>
            </div>

            <!-- Summary & Payment -->
            <div class="summary-card">
                <h2>Resumen del Pedido</h2>
                
                <div class="summary-row">
                    <span>Subtotal (<%= carrito.getItems().size() %> items):</span>
                    <span>$<%= df.format(carrito.getTotal()) %></span>
                </div>
                
                <div class="summary-row">
                    <span>Envío:</span>
                    <span>Gratis</span>
                </div>
                
                <div class="summary-row highlight">
                    <span>Impuestos (12%):</span>
                    <span>$<%= df.format(carrito.getTotal() * 0.12) %></span>
                </div>
                
                <div class="summary-row total">
                    <span>Total a Pagar:</span>
                    <span>$<%= df.format(carrito.getTotal() * 1.12) %></span>
                </div>

                <!-- Payment Form -->
                <form action="procesarPago.jsp" method="post" onsubmit="return validarPago()" class="payment-form">
                    <h3>Información de Pago</h3>
                    
                    <div class="form-group">
                        <label for="num">Número de Tarjeta</label>
                        <input type="text" id="num" name="num" class="form-control" 
                               maxlength="19" placeholder="1234 5678 9012 3456"
                               oninput="formatCardNumber(this)" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Tipo de Tarjeta</label>
                        <div id="tipo" class="card-type-display">Ingrese el número</div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="mes">Mes de Expiración</label>
                            <select id="mes" name="mes" class="form-control" required>
                                <option value="">Mes</option>
                                <%
                                for (int i = 1; i <= 12; i++) {
                                    String month = i < 10 ? "0" + i : String.valueOf(i);
                                %>
                                <option value="<%= month %>"><%= month %></option>
                                <%
                                }
                                %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="anio">Año de Expiración</label>
                            <select id="anio" name="anio" class="form-control" required>
                                <option value="">Año</option>
                                <%
                                int currentYear = java.time.Year.now().getValue();
                                for (int i = 0; i <= 7; i++) {
                                %>
                                <option value="<%= currentYear + i %>"><%= currentYear + i %></option>
                                <%
                                }
                                %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="cvv">CVV</label>
                        <input type="password" id="cvv" name="cvv" class="form-control" 
                               maxlength="4" placeholder="123" 
                               oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                    </div>
                    
                    <button type="submit" class="btn-primary">
                        💳 Proceder al Pago - $<%= df.format(carrito.getTotal() * 1.12) %>
                    </button>
                </form>
                
                <a href="nuevo_pedido.jsp" class="btn-secondary">← Continuar Comprando</a>
            </div>
        </div>
    </div>

    <script>
    // Funciones para el formato de tarjeta
    function formatCardNumber(input) {
        let value = input.value.replace(/\D/g, '');
        let formattedValue = '';
        
        for (let i = 0; i < value.length; i++) {
            if (i > 0 && i % 4 === 0) {
                formattedValue += ' ';
            }
            formattedValue += value[i];
        }
        
        input.value = formattedValue;
        detectCardType(value);
    }

    function detectCardType(cardNumber) {
        const cleanNumber = cardNumber.replace(/\D/g, '');
        let cardType = "Ingrese el número";
        
        if (/^4/.test(cleanNumber)) {
            cardType = "💳 VISA";
        } else if (/^5[1-5]/.test(cleanNumber)) {
            cardType = "💳 MasterCard";
        } else if (/^3[47]/.test(cleanNumber)) {
            cardType = "💳 American Express";
        } else if (/^6(?:011|5)/.test(cleanNumber)) {
            cardType = "💳 Discover";
        } else if (cleanNumber.length > 0) {
            cardType = "🔍 Tarjeta no reconocida";
        }
        
        document.getElementById("tipo").textContent = cardType;
        return cardType;
    }

    // Validación del pago
    function validarPago() {
        let num = document.getElementById("num").value.replace(/\s/g, "");
        let cvv = document.getElementById("cvv").value;
        let mes = document.getElementById("mes").value;
        let anio = document.getElementById("anio").value;

        if (!/^\d{16}$/.test(num)) {
            alert("El número de tarjeta debe tener exactamente 16 dígitos.");
            return false;
        }

        if (!/^\d{3,4}$/.test(cvv)) {
            alert("El CVV debe tener 3 o 4 dígitos.");
            return false;
        }

        if (!mes || !anio) {
            alert("Por favor, selecciona la fecha de expiración.");
            return false;
        }

        let fechaActual = new Date();
        let añoActual = fechaActual.getFullYear();
        let mesActual = fechaActual.getMonth() + 1;

        if (parseInt(anio) < añoActual || (parseInt(anio) === añoActual && parseInt(mes) < mesActual)) {
            alert("La tarjeta ha caducado. Por favor, verifica la fecha de expiración.");
            return false;
        }

        return true;
    }

    // Función para actualizar cantidad
    function updateQuantity(itemId, change) {
        // En una implementación real, esto haría una petición AJAX al servidor
        alert(`Actualizando cantidad del producto ${itemId}. Cambio: ${change}`);
        // window.location.href = `actualizarCarrito.jsp?id=${itemId}&cambio=${change}`;
    }

    // Botones de eliminar
    document.querySelectorAll('.remove-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const item = this.closest('.cart-item');
            if (confirm('¿Estás seguro de que quieres eliminar este producto del carrito?')) {
                item.style.animation = 'fadeOut 0.3s ease forwards';
                setTimeout(() => {
                    // En una implementación real, aquí iría una petición AJAX para eliminar
                    item.remove();
                    // Recargar la página o actualizar el total
                    if (document.querySelectorAll('.cart-item').length === 0) {
                        location.reload();
                    }
                }, 300);
            }
        });
    });

    // Agregar animación de fadeOut
    const style = document.createElement('style');
    style.textContent = `
        @keyframes fadeOut {
            from { opacity: 1; transform: translateX(0); }
            to { opacity: 0; transform: translateX(-100px); }
        }
    `;
    document.head.appendChild(style);
    </script>
</body>
</html>