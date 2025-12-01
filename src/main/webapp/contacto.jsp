<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Contacto - Baguette y Pastelería</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 
    
    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>

    <style>
        /* CSS para centrar y dar estilo al visor de la mascota */
        .mascota-container {
            text-align: center;
            padding: 30px;
            border-bottom: 2px solid #ffcc80;
            margin-bottom: 30px;
        }

        .mascota-viewer {
            width: 80%; 
            max-width: 400px;
            height: 400px; 
            margin: 20px auto;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            border: 5px solid #795548;
        }

        /* Estilos para el contenido y aside (tomados de productos.jsp) */
        .content {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
        }

        section {
            flex: 2; 
            min-width: 300px;
        }

        aside {
            flex: 1; 
            min-width: 200px;
            padding: 20px;
            background-color: #f7f3e8;
            border-radius: 8px;
            box-shadow: 1px 1px 3px rgba(0,0,0,0.1);
        }
        
        /* Estilo para los iconos de desarrolladores */
        .aside-icons a {
            margin-right: 10px;
        }
        
        /* Media Query para móvil */
        @media (max-width: 768px) {
            .content {
                flex-direction: column;
            }
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
            <a href="productos.jsp">Productos</a>
            <a href="servicios.jsp">Servicios</a>
            <a href="contacto.jsp" class="active">Contacto</a>
        </nav>

        <div class="content">
            <section>
                <h2>¡Conoce a nuestra Mascota! 🐾</h2>
                <div class="mascota-container">
                    <p>Esta es nuestra mascota digital. Puedes rotarla y moverla. ¡Esperamos verte pronto!</p>
                    
                    <model-viewer 
                        class="mascota-viewer"
                        src="imagenes/3d/mascota.glb" 
                        alt="Mascota Digital de la Pastelería" 
                        shadow-intensity="1" 
                        camera-controls 
                        auto-rotate 
                        autoplay 
                        rotation-per-second="10deg"
                        
                        camera-orbit="0deg 90deg 900.1m"
    					camera-target="0.0m 50.5m 0.0m"
    					field-of-view="5deg"
   						ar> 
                    </model-viewer>
                </div>
                
                <h3>Nuestra Ubicación</h3>
                <p>Visítanos en la Av. General Jose Gallardo y S44A, Cuidadela del Ejército.</p>
                <p>Teléfono: (555) 123-4567</p>
            </section>

            <aside>
                <h3>Conoce a los Desarrolladores 👩‍💻👨‍💻</h3>
                <p>Si tienes alguna pregunta sobre el desarrollo de esta web, contacta con:</p>
                
                <p>
                    **Alisson Valencia** (Líder de Proyecto)
                </p>
                
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