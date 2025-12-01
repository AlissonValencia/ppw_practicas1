package com.productos.datos;

import java.sql.*;

public class Conexion {

    private Statement St; 
    private String driver;
    private String user;
    private String pwd;
    private String cadena;
    private Connection con;

    // --- Getters ---
    String getDriver() {
        return this.driver;
    }

    String getUser() {
        return this.user;
    }

    String getPwd() {
        return this.pwd;
    }

    String getCadena() {
        return this.cadena;
    }

    public Connection getConexion() { 
        return this.con; 
    }

    // --- Constructor ---
    public Conexion() {
        this.driver = "org.postgresql.Driver";
        this.user = "postgres";
        this.pwd = "1234";
        this.cadena = "jdbc:postgresql://localhost:5432/bd_productos";
        this.con = this.crearConexion();	
    }

    // --- 🔹 MÉTODO PÚBLICO (corregido) para crear conexión ---
    public Connection crearConexion() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Error cargando driver PostgreSQL: " + e.getMessage());
        }

        try {
            Class.forName(getDriver()).newInstance();
            Connection con = DriverManager.getConnection(getCadena(), getUser(), getPwd());
            return con;
        } catch (Exception ee) {
            System.out.println("Error creando conexión: " + ee.getMessage());
            return null;
        }
    }

    // --- Ejecutar INSERT, UPDATE o DELETE ---
    public String Ejecutar(String sql) {
        String result = "";
        try {
            St = getConexion().createStatement();
            int filas = St.executeUpdate(sql);
            if (filas > 0) {
                result = "Operacion realizada con exito";
            } else {
                result = "No se realizaron cambios";
            }
        } catch (Exception ex) {
            result = "Error al ejecutar SQL: " + ex.getMessage();
        }
        return result;
    }

    // --- Ejecutar consultas SELECT ---
    public ResultSet Consulta(String sql) {
        ResultSet reg = null;
        try {
            St = getConexion().createStatement();
            reg = St.executeQuery(sql);
        } catch (Exception ee) {
            System.out.println("Error en consulta: " + ee.getMessage());
        }
        return reg;
    }

    // --- Cerrar conexión manualmente ---
    public void cerrarConexion() {
        try {
            if (St != null) St.close();
            if (con != null && !con.isClosed()) con.close();
        } catch (SQLException e) {
            System.out.println("Error al cerrar conexión: " + e.getMessage());
        }
    }
}
