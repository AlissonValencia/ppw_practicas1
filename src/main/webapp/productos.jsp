<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Productos - Baguette y Pastelería</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 
    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>

    <style>
    /* Contenedor principal para la cuadrícula */
    .grid-productos {
        display: flex;
        flex-wrap: wrap; 
        gap: 30px; 
        padding: 10px;
    }

    /* Estilo para cada item/columna (50% de ancho) */
    .producto-item {
        flex: 0 0 calc(50% - 15px); 
        box-sizing: border-box;
        text-align: center;
        padding: 15px;
        border: 1px solid #ffcc80; 
        border-radius: 8px;
        box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
    }
    
    /* 1. Estilo UNIFICADO: Aplica el mismo tamaño y borde a model-viewer y al contenedor de Sketchfab */
    .producto-item model-viewer,
    .visor-3d-container {
        width: 100%; 
        height: 250px; 
        display: block;
        margin: 0 auto 15px auto;
        border-radius: 8px;
        border: 4px solid #795548; /* Borde visual */
        overflow: hidden; /* Importante para que el iframe respete el borde redondeado */
    }

    /* 2. Estilo específico para el iframe de Sketchfab dentro de su contenedor */
    .visor-3d-container iframe {
        width: 100%;
        height: 100%;
        border: none; /* Elimina el borde por defecto del iframe */
    }

    /* Estilo para títulos */
    .producto-item h4 {
        color: #795548;
        margin-top: 5px;
        margin-bottom: 10px;
    }
    
    /* Media Query para una columna en móviles */
    @media (max-width: 768px) {
        .producto-item {
            flex: 0 0 100%; 
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
            <a href="productos.jsp" class="active">Productos</a>
            <a href="servicios.jsp">Servicios</a>
            <a href="contacto.jsp">Contacto</a>
        </nav>

        <div class="content">
            <section>
                <article>
                    <h3>Nuestros Productos Estelares</h3>
                    
                    <div class="grid-productos">
                    
                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/chocolate_cake.glb" 
                                alt="Modelo 3D Tarta de Chocolate" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>1. Tarta de Chocolate Triple Capa</h4>
                            <p>Una tarta decadente con tres capas de bizcocho de chocolate y ganache oscuro.</p>
                        </div>
                        
                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/croissants.glb" 
                                alt="Modelo 3D Croissants" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>2. Croissants Clásicos de Mantequilla</h4>
                            <p>Hojaldre francés crujiente y aireado, horneado diariamente.</p>
                        </div>

                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/panmasa_madre.glb" 
                                alt="Modelo 3D Pan de Masa Madre" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>3. Pan de Masa Madre Artesanal</h4>
                            <p>Pan rústico con corteza gruesa y miga alveolada, fermentación lenta.</p>
                        </div>

                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/macarons.glb" 
                                alt="Modelo 3D Macarons" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>4. Macarons Surtidos (Caja de 6)</h4>
                            <p>Delicados merengues de almendra en sabores variados (vainilla, pistacho, frambuesa).</p>
                        </div>
                        
                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/baguette.glb" 
                                alt="Modelo 3D Baguette" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>5. Baguette Tradicional</h4>
                            <p>La clásica baguette francesa: crujiente por fuera, suave por dentro.</p>
                        </div>
                        
                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/cheesecake.glb" 
                                alt="Modelo 3D Cheesecake" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>6. Cheesecake de Frutos Rojos</h4>
                            <p>Tarta de queso cremosa sobre base de galleta, cubierta con mermelada y bayas frescas.</p>
                        </div>

                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/rollo_canela.glb" 
                                alt="Modelo 3D Rolls de Canela" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>7. Rollos de Canela Gigantes</h4>
                            <p>Rollos dulces con glaseado de queso crema, perfectos para el desayuno.</p>
                        </div>

                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/muffin.glb" 
                                alt="Modelo 3D Muffin" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>8. Muffin de Arándanos y Limón</h4>
                            <p>Bizcochito individual esponjoso con arándanos y toque cítrico.</p>
                        </div>

                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/eclair.glb" 
                                alt="Modelo 3D Éclairs de Café" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>9. Éclairs de Café</h4>
                            <p>Pasta choux rellena de crema pastelera de café y cubierta con glaseado de moka.</p>
                        </div>

                        <div class="producto-item">
                            <model-viewer 
                                src="imagenes/3d/tiramisu.glb" 
                                alt="Modelo 3D Tiramisú" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>10. Tiramisú</h4>
                            <p>Postre italiano clásico a base de bizcochos de soletilla, café y crema mascarpone.</p>
                        </div>
                        
                    </div>
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
</body>
</html>