package com.productos.seguridad;

import com.productos.datos.Conexion;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Usuario {

    // --- Atributos ---
    private Integer id;                  // ✅ id_us
    private String correo;
    private String clave;
    private Integer perfil;              // id_per
    private String nombre;               // nombre_us
    private String descripcionPerfil;    // descripción del perfil (rol)
    private Integer estado;              // id_est
    private String cedula;               // cedula_us

    // --- Getters y Setters ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getClave() { return clave; }
    public void setClave(String clave) { this.clave = clave; }

    public Integer getPerfil() { return perfil; }
    public void setPerfil(Integer perfil) { this.perfil = perfil; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcionPerfil() { return descripcionPerfil; }
    public void setDescripcionPerfil(String descripcionPerfil) { this.descripcionPerfil = descripcionPerfil; }

    public Integer getEstado() { return estado; }
    public void setEstado(Integer estado) { this.estado = estado; }

    public String getCedula() { return cedula; }
    public void setCedula(String cedula) { this.cedula = cedula; }

    // ============================================================
    // 🔐 Método para verificar las credenciales del usuario
    // ============================================================
    public boolean verificarUsuario(String ncorreo, String nclave) {
        boolean respuesta = false;

        // Validar longitud mínima de contraseña, excepto "batman"
        if (nclave.length() < 8 && !nclave.equals("batman")) {
            return false;
        }

        // ✅ USAR PREPARED STATEMENT PARA EVITAR SQL INJECTION
        String sql = "SELECT u.id_us, u.id_per, u.nombre_us, p.descripcion_per, u.id_est, u.cedula_us " +
                     "FROM tb_usuario u " +
                     "JOIN tb_perfil p ON u.id_per = p.id_per " +
                     "WHERE u.correo_us = ? AND u.clave_us = ?";

        Conexion con = new Conexion();
        ResultSet rs = null;

        try {
            java.sql.PreparedStatement pst = con.getConexion().prepareStatement(sql);
            pst.setString(1, ncorreo);
            pst.setString(2, nclave);
            
            rs = pst.executeQuery();
            
            if (rs.next()) {
                respuesta = true;
                this.setId(rs.getInt("id_us"));                  
                this.setPerfil(rs.getInt("id_per"));             
                this.setNombre(rs.getString("nombre_us"));       
                this.setDescripcionPerfil(rs.getString("descripcion_per")); 
                this.setEstado(rs.getInt("id_est"));             
                this.setCedula(rs.getString("cedula_us"));
                this.setCorreo(ncorreo);                         
            }
            pst.close();
        } catch (SQLException ex) {
            System.out.println("❌ Error al verificar usuario: " + ex.getMessage());
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (SQLException e) { }
            }
        }

        return respuesta;
    }

    // ============================================================
    // 🧾 Método para registrar un nuevo cliente
    // ============================================================
    public String ingresarCliente() {
        String resultado = "";
        Conexion con = new Conexion();
        java.sql.PreparedStatement pst = null;
        
        try {
            // ✅ USAR PREPARED STATEMENT
            String sql = "INSERT INTO tb_usuario (id_per, id_est, nombre_us, cedula_us, correo_us, clave_us) " +
                         "VALUES (3, 1, ?, ?, ?, ?)";
            
            pst = con.getConexion().prepareStatement(sql);
            pst.setString(1, this.getNombre());
            pst.setString(2, this.getCedula());
            pst.setString(3, this.getCorreo());
            pst.setString(4, this.getClave());
            
            int filas = pst.executeUpdate();
            
            if (filas > 0) {
                resultado = "OK";
            } else {
                resultado = "No se pudo registrar el cliente";
            }
            
        } catch (Exception e) {
            resultado = "Error al registrar cliente: " + e.getMessage();
            System.out.println("❌ Error al registrar cliente: " + e.getMessage());
        } finally {
            if (pst != null) {
                try { pst.close(); } catch (SQLException e) { }
            }
            con.cerrarConexion();
        }
        return resultado;
    }

    // ============================================================
    // 🔍 MÉTODOS NUEVOS AGREGADOS
    // ============================================================

    // 🔹 Verificar si el usuario es administrador
    public boolean esAdministrador() {
        return this.perfil != null && this.perfil == 1;
    }

    // 🔹 Verificar si el usuario es empleado
    public boolean esEmpleado() {
        return this.perfil != null && this.perfil == 2;
    }

    // 🔹 Verificar si el usuario es cliente
    public boolean esCliente() {
        return this.perfil != null && this.perfil == 3;
    }

    // 🔹 Obtener el tipo de usuario como texto (para compatibilidad)
    public String getTipoUsuario() {
        if (this.perfil == null) return "DESCONOCIDO";
        
        switch(this.perfil) {
            case 1: return "ADMIN";
            case 2: return "EMPLEADO";
            case 3: return "CLIENTE";
            default: return "DESCONOCIDO";
        }
    }

    // 🔹 Método para cambiar contraseña
    public String cambiarClave(String nuevaClave) {
        String resultado = "";
        Conexion con = new Conexion();
        java.sql.PreparedStatement pst = null;
        
        try {
            // Validar longitud de nueva contraseña
            if (nuevaClave.length() < 8) {
                return "La contraseña debe tener al menos 8 caracteres";
            }
            
            String sql = "UPDATE tb_usuario SET clave_us = ? WHERE id_us = ?";
            pst = con.getConexion().prepareStatement(sql);
            pst.setString(1, nuevaClave);
            pst.setInt(2, this.id);
            
            int filas = pst.executeUpdate();
            
            if (filas > 0) {
                resultado = "OK";
                this.clave = nuevaClave; // Actualizar en el objeto
            } else {
                resultado = "No se pudo cambiar la contraseña";
            }
            
        } catch (Exception e) {
            resultado = "Error al cambiar contraseña: " + e.getMessage();
        } finally {
            if (pst != null) {
                try { pst.close(); } catch (SQLException e) { }
            }
            con.cerrarConexion();
        }
        return resultado;
    }

    // 🔹 Método para obtener usuario por ID
    public static Usuario obtenerPorId(int idUsuario) {
        Usuario usuario = null;
        Conexion con = new Conexion();
        ResultSet rs = null;
        
        try {
            String sql = "SELECT u.id_us, u.id_per, u.nombre_us, u.cedula_us, u.correo_us, " +
                        "p.descripcion_per, u.id_est " +
                        "FROM tb_usuario u " +
                        "JOIN tb_perfil p ON u.id_per = p.id_per " +
                        "WHERE u.id_us = ?";
            
            java.sql.PreparedStatement pst = con.getConexion().prepareStatement(sql);
            pst.setInt(1, idUsuario);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId(rs.getInt("id_us"));
                usuario.setPerfil(rs.getInt("id_per"));
                usuario.setNombre(rs.getString("nombre_us"));
                usuario.setCedula(rs.getString("cedula_us"));
                usuario.setCorreo(rs.getString("correo_us"));
                usuario.setDescripcionPerfil(rs.getString("descripcion_per"));
                usuario.setEstado(rs.getInt("id_est"));
            }
            pst.close();
        } catch (SQLException ex) {
            System.out.println("❌ Error al obtener usuario por ID: " + ex.getMessage());
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (SQLException e) { }
            }
            con.cerrarConexion();
        }
        return usuario;
    }

    // 🔹 Método para verificar si el usuario está activo
    public boolean estaActivo() {
        return this.estado != null && this.estado == 1;
    }

    // 🔹 Método toString para debugging
    @Override
    public String toString() {
        return "Usuario{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", correo='" + correo + '\'' +
                ", perfil=" + perfil +
                ", descripcionPerfil='" + descripcionPerfil + '\'' +
                ", estado=" + estado +
                ", cedula='" + cedula + '\'' +
                '}';
    }
}