package com.productos.negocio;

import com.productos.datos.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Categoria {
    
    private int id_cat;
    private String descripcion_cat;

    // 🔹 Constructor vacío
    public Categoria() {
    }

    // 🔹 Constructor con parámetros
    public Categoria(int id_cat, String descripcion_cat) {
        this.id_cat = id_cat;
        this.descripcion_cat = descripcion_cat;
    }

    // 🔹 Getters y Setters
    public int getId_cat() {
        return id_cat;
    }

    public void setId_cat(int id_cat) {
        this.id_cat = id_cat;
    }

    public String getDescripcion_cat() {
        return descripcion_cat;
    }

    public void setDescripcion_cat(String descripcion_cat) {
        this.descripcion_cat = descripcion_cat;
    }

    // 🔹 toString() para mostrar correctamente en listas o selects
    @Override
    public String toString() {
        return descripcion_cat;
    }

    // ===========================================================
    // 🔹 Método para obtener todas las categorías desde la BD
    // ===========================================================
    public static List<Categoria> obtenerCategorias() {
        List<Categoria> lista = new ArrayList<>();
        Conexion con = new Conexion();
        Connection conexion = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conexion = con.crearConexion();
            stmt = conexion.createStatement();
            String sql = "SELECT id_cat, descripcion_cat FROM tb_categoria ORDER BY id_cat;";
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Categoria cat = new Categoria(
                    rs.getInt("id_cat"),
                    rs.getString("descripcion_cat")
                );
                lista.add(cat);
            }
        } catch (Exception e) {
            System.out.println("❌ Error al obtener categorías: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conexion != null) conexion.close();
            } catch (SQLException ex) {
                System.out.println("⚠️ Error al cerrar conexión: " + ex.getMessage());
            }
        }

        return lista;
    }
}
