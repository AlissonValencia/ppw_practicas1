package com.productos.seguridad;

import com.productos.datos.Conexion;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

public class Pagina {

	public String mostrarMenu(Integer nperfil) {
	    StringBuilder menu = new StringBuilder();
	    String logout = ""; 
	    String productos = "";  
	    String servicios = "";  
	    String sql = "SELECT pag.path_pag, pag.descripcion_pag "
	               + "FROM tb_pagina pag "
	               + "JOIN tb_perfilpagina pper ON pag.id_pag = pper.id_pag "
	               + "WHERE pper.id_per = " + nperfil;

	    Conexion con = new Conexion();
	    ResultSet rs = null;

	    try {
	        rs = con.Consulta(sql);
	        List<String> otros = new LinkedList<>();

	        while (rs.next()) {

	            String path = rs.getString("path_pag");
	            String descripcion = rs.getString("descripcion_pag");

	            // --- Guardar Cerrar Sesion ---
	            if (descripcion.equalsIgnoreCase("Cerrar Sesión") ||
	                descripcion.equalsIgnoreCase("Cerrar Sesion")) {
	                logout = "<a href='" + path + "' class='logout-link'>" + descripcion + "</a>";
	            }

	            // --- Primero: Administrar Productos ---
	            else if (descripcion.equalsIgnoreCase("Administrar Productos")) {
	                productos = "<a href='" + path + "'>" + descripcion + "</a>";
	            }

	            // --- Segundo: Administrar Servicios (nuevo orden especial) ---
	            else if (descripcion.equalsIgnoreCase("Administrar Servicios")) {
	                servicios = "<a href='" + path + "'>" + descripcion + "</a>";
	            }

	            // --- Otros enlaces ---
	            else {
	                otros.add("<a href='" + path + "'>" + descripcion + "</a>");
	            }
	        }

	        // --- Construcción del menú en el orden solicitado ---

	        // 1️⃣ Administrar Productos
	        if (!productos.isEmpty()) menu.append(productos);

	        // 2️⃣ Administrar Servicios
	        if (!servicios.isEmpty()) menu.append(servicios);

	        // 3️⃣ Resto de páginas
	        for (String item : otros) menu.append(item);

	        // 4️⃣ Si es cliente, agregar Cambiar Clave
	        if (nperfil == 3) {
	            menu.append("<a href='cambiarClave.jsp'>Cambiar Clave</a>");
	        }

	    } catch (SQLException e) {
	        System.out.println("Error al generar el menú: " + e.getMessage());
	    }

	    // 5️⃣ Cerrar Sesión al final
	    return menu.toString() + logout;
	}

}
