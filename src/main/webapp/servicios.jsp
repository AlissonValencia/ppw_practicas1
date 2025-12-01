<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Servicios - Baguette y Pastelería</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/> 
    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
    
    <style>
        /* Contenedor principal para la cuadrícula */
        .grid-servicios {
            display: flex;
            flex-wrap: wrap; 
            gap: 30px; 
            padding: 10px;
        }

        /* Estilo para cada item/columna (50% de ancho) */
        .servicio-item {
            flex: 0 0 calc(50% - 15px); 
            box-sizing: border-box;
            text-align: center;
            padding: 15px;
            border: 1px solid #ffcc80; 
            border-radius: 8px;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
        }
        
        /* Estilo para el Visor 3D */
        .servicio-item model-viewer {
            width: 100%; 
            height: 250px; 
            display: block;
            margin: 0 auto 15px auto;
            border-radius: 8px;
            border: 4px solid #795548;
        }

        /* Estilo para títulos */
        .servicio-item h4 {
            color: #795548;
            margin-top: 5px;
            margin-bottom: 10px;
        }
        
        /* Media Query para una columna en móviles */
        @media (max-width: 768px) {
            .servicio-item {
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
            <a href="productos.jsp">Productos</a>
            <a href="servicios.jsp" class="active">Servicios</a>
            <a href="contacto.jsp">Contacto</a>
        </nav>

        <div class="content">
            <section>
                <article>
                    <h3>Nuestros Servicios Premium</h3>
                    
                    <div class="grid-servicios">

                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/catering.glb" 
                                alt="Modelo 3D Catering" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>1. Catering para Eventos (Dulce)</h4>
                            <p>Suministro de mini-pasteles, petit fours y muffins para fiestas y reuniones.</p>
                        </div>
                        
                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/pasteles_personalizados.glb" 
                                alt="Modelo 3D Pasteles Personalizados" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>2. Pasteles Personalizados (Bodas/Cumpleaños)</h4>
                            <p>Creación de tartas temáticas y multinivel a medida, bajo encargo especial.</p>
                        </div>

                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/desayunos.glb" 
                                alt="Modelo 3D Desayunos a Domicilio" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>3. Desayunos a Domicilio</h4>
                            <p>Cajas de desayuno completas (pan, jugo, café, bollería) entregadas al amanecer.</p>
                        </div>

                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/cursos_panaderia.glb" 
                                alt="Modelo 3D Cursos de Panadería" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>4. Cursos de Panadería Básica</h4>
                            <p>Talleres presenciales o virtuales para aprender a hacer pan casero.</p>
                        </div>
                        
                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/suscripcion_pan.glb" 
                                alt="Modelo 3D Suscripción" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>5. Suscripción Mensual de Pan</h4>
                            <p>Envío semanal de una selección de panes artesanales a casa.</p>
                        </div>
                        
                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/degustacion_local.glb" 
                                alt="Modelo 3D Degustación en Local" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>6. Café y Degustación en Local</h4>
                            <p>Servicio de café gourmet y pastelería para consumir en mesa.</p>
                        </div>

                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/mesa_postres.glb" 
                                alt="Modelo 3D Mesa de Postres" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>7. Mesa de Postres Temática</h4>
                            <p>Diseño y montaje completo de una mesa dulce para celebraciones.</p>
                        </div>

                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/venta_mayorista.glb" 
                                alt="Modelo 3D Venta Mayorista" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>8. Venta Mayorista a Restaurantes</h4>
                            <p>Suministro regular de pan y bollería a hoteles y cafeterías.</p>
                        </div>

                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/recogida_rapida.glb" 
                                alt="Modelo 3D Recogida Rápida" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>9. Recogida Rápida (Click & Collect)</h4>
                            <p>Servicio de pedido online para recoger el producto listo en tienda.</p>
                        </div>

                        <div class="servicio-item">
                            <model-viewer 
                                src="imagenes/3d/empaque_regalo.glb" 
                                alt="Modelo 3D Empaque de Regalo" 
                                shadow-intensity="1" 
                                camera-controls 
                                auto-rotate>
                            </model-viewer>
                            <h4>10. Empaque de Regalo Gourmet</h4>
                            <p>Preparación de cajas de regalo con una selección de productos premium.</p>
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