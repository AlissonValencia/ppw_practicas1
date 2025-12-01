const formulario = document.getElementById("formCliente");

formulario.addEventListener("submit", function(event){
    // 1. Ejecuta tu lógica (alert, console.log)
    const nombre = document.getElementById("nombre").value;
    const email = document.getElementById("email").value;
    
    alert("Bienvenido a nuestro sitio web " + nombre + "-" + email);
});
	
	
	
	
	
		