<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Baguette y Pastelería</title>
    <link href="css/estilos3.css" rel="stylesheet" type="text/css"/>
    
    <!-- Librería del visor 3D -->
    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>

    <style>
        /* ===== Estilos del visor de Realidad Aumentada ===== */
        .vr-model-viewer {
            width: 100%;
            height: 420px;
            margin: 20px 0 -280px 0; /* 🔹 margen inferior reducido */
            border-radius: 12px;
            border: 3px solid #ffcc80;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
            background-image: url('imagenes/3d/fondo_panaderia.jpg');
            background-size: cover;
            background-position: center;
        }

        /* Botón flotante debajo del visor */
        .vr-button {
            display: inline-block;
            background-color: #ffb74d;
            color: #4b382d;
            font-weight: bold;
            padding: 10px 25px;
            border-radius: 25px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
            text-decoration: none;
            margin: 0 auto;
            display: block;
            text-align: center;
        }

        .vr-button:hover {
            background-color: #ff9800;
            transform: translateY(-2px);
        }

        /* ===== Estructura general ===== */
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

        /* Adaptable para móviles */
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
            <img src="imagenes/logo-baguette-pastel.jpg" alt="Logo Baguette y Pastelería" width="100" height="auto"/>
            <h1>Baguette y Pastelería</h1>
            <h2 class="destacado">Un toque secreto, con el sabor perfecto</h2>
            <h4 id="favorito">Panadería Artesanal y Pastelería Creativa en tu Barrio</h4>
        </header>

        <nav>
            <a href="index.jsp" class="active">Home</a>
            <a href="login.jsp">Login</a>
            <a href="productos.jsp">Productos</a>
            <a href="servicios.jsp">Servicios</a>
            <a href="contacto.jsp">Contacto</a>
        </nav>

        <div class="content">
            <section>
                <article>
                    <h3>¡Conoce al Panadero en Realidad Aumentada! 👨‍🍳</h3>
                    <p>
                        Usa este visor para ver a nuestro panadero virtual en el ambiente de nuestra pastelería. 
                        Si usas un móvil, toca el icono de RA (Realidad Aumentada) para ponerlo en tu cocina o mesa.
                    </p>

                    <!-- 🔹 Modelo 3D centrado y mirando al frente -->
                    <model-viewer 
                        id="panadero-vr"
                        class="vr-model-viewer"
                        src="imagenes/3d/persona_panadero.glb"          
                        alt="Panadero de la Pastelería en Realidad Aumentada" 

                        ar 
                        ar-modes="webxr scene-viewer quick-look"
                        camera-controls
                        auto-rotate
                        autoplay="false"
                        shadow-intensity="1"
                        exposure="1.4"
                        >
                    </model-viewer>

                        <!-- 🔹 Centrado y mirando al frente -->
                        <model-viewer 
                        orientation="0deg 180deg 0deg"
                        camera-orbit="0deg 90deg 2.3m"
                        camera-target="0m 1m 0m"
                        field-of-view="25deg"
                        >
                    </model-viewer>

                        <!-- 🔹 Fondo tipo panadería -->
                        <model-viewer 
                        skybox-image="imagenes/3d/fondo_panaderia.jpg"
                    >
                    </model-viewer>

                </article>

                <article>
                    <h3>Nuestra Misión</h3>
                    <p>
                        En Baguette y Pastel, nuestro toque secreto es la pasión y el uso de ingredientes de primera calidad. 
                        Somos la panadería artesanal de tu barrio, dedicados a hornear pan fresco cada mañana y crear pasteles que hacen inolvidables tus celebraciones.
                    </p>
                    <img src="imagenes/baguette_pasteleria.jpg" alt="Baguette y Pastelería" width="400" height="300"/>
                </article>

                <article>
                    <h3>Encuéntranos</h3>
                    <iframe src="https://www.google.com/maps/d/u/0/embed?mid=1Pe899pZc6_csHV7npwglogOAB8XmsCo&ehbc=2E312F" 
                            width="100%" 
                            height="450" 
                            style="border:0;" 
                            allowfullscreen 
                            loading="lazy">
                    </iframe>
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

        <!-- 🔹 Script para manejar animaciones del modelo -->
        <script>
        document.addEventListener('DOMContentLoaded', () => {
            const modelViewer = document.querySelector('#panadero-vr');

            // Nombres exactos de las animaciones en el modelo GLB
            const ANIMATION_WALK = "SK_Baker_Head|A_Baker_Walk_SK_Baker_Body";
            const ANIMATION_SMILE = "SK_Baker_Head|A_Baker_SmileAtCat_Cycle_03_SK_Baker_Body";

            // Secuencia: animación + duración (en ms)
            const cycle = [
                { name: ANIMATION_WALK, duration: 7000 },
                { name: ANIMATION_SMILE, duration: 3000 }
            ];

            let currentIndex = 0;
            let timer;

            const cycleAnimations = () => {
                const currentAnim = cycle[currentIndex];
                modelViewer.animationName = currentAnim.name;
                modelViewer.play();

                clearTimeout(timer);
                timer = setTimeout(() => {
                    currentIndex = (currentIndex + 1) % cycle.length;
                    cycleAnimations();
                }, currentAnim.duration);
            };

            modelViewer.addEventListener('load', () => cycleAnimations());
            if (modelViewer.hasLoaded) cycleAnimations();
        });
        </script>

        <footer>
            <ul>
                <li>
                    <a href="https://www.facebook.com/?locale=es_LA">
                        <img src="iconos/facebook.jpg" alt="Facebook" width="32" height="32"/>
                    </a>
                </li>
                <li>
                    <a href="https://www.instagram.com/">
                        <img src="iconos/instagram.jpg" alt="Instagram" width="32" height="32"/>
                    </a>
                </li>
                <li>
                    <a href="https://x.com/?lang=es">
                        <img src="iconos/x.jpg" alt="X" width="32" height="32"/>
                    </a>
                </li>
            </ul>
            <p>© 2025 - Baguette y Pastelería - Alisson Valencia</p>
        </footer>
    </main>
</body>
</html>
