package com.productos.negocio;

import java.sql.*;
import com.productos.datos.Conexion;
import javax.servlet.http.HttpServletRequest;

public class Bitacora {
    private int idBitacora;
    private int idUsuario;
    private String accion;
    private String modulo;
    private String descripcion;
    private String fecha;
    private String ipAddress;
    private String userAgent;
    
    public Bitacora() {}
    
    // Método principal para registrar en bitácora
    public void registrarBitacora(int idUsuario, String accion, String modulo, String descripcion, HttpServletRequest request) {
        Connection con = null;
        PreparedStatement pst = null;
        
        try {
            Conexion conexion = new Conexion();
            con = conexion.crearConexion();
            
            // Obtener IP y User-Agent del request
            String ipAddress = obtenerDireccionIP(request);
            String userAgent = request.getHeader("User-Agent");
            
            String sql = "INSERT INTO tb_bitacora (id_usuario, accion, modulo, descripcion, ip_address, user_agent) VALUES (?, ?, ?, ?, ?, ?)";
            pst = con.prepareStatement(sql);
            pst.setInt(1, idUsuario);
            pst.setString(2, accion);
            pst.setString(3, modulo);
            pst.setString(4, descripcion);
            pst.setString(5, ipAddress);
            pst.setString(6, userAgent);
            
            pst.executeUpdate();
            
            System.out.println("✅ Bitácora registrada: " + accion + " - " + modulo);
            
        } catch (SQLException e) {
            System.out.println("❌ Error al registrar en bitácora: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Método para obtener la dirección IP real del cliente
    private String obtenerDireccionIP(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
    
    // Métodos específicos para diferentes acciones
    
    public void registrarLogin(int idUsuario, boolean exitoso, HttpServletRequest request) {
        String accion = exitoso ? "LOGIN_EXITOSO" : "LOGIN_FALLIDO";
        String descripcion = exitoso ? 
            "Inicio de sesión exitoso" : 
            "Intento fallido de inicio de sesión";
        registrarBitacora(idUsuario, accion, "SEGURIDAD", descripcion, request);
    }
    
    public void registrarLogout(int idUsuario, HttpServletRequest request) {
        registrarBitacora(idUsuario, "LOGOUT", "SEGURIDAD", "Cierre de sesión", request);
    }
    
    public void registrarRegistroUsuario(int idUsuario, String tipoUsuario, HttpServletRequest request) {
        registrarBitacora(idUsuario, "REGISTRO_USUARIO", "USUARIOS", 
            "Registro de nuevo usuario: " + tipoUsuario, request);
    }
    
    public void registrarActualizacionUsuario(int idUsuario, String accion, HttpServletRequest request) {
        registrarBitacora(idUsuario, "ACTUALIZACION_USUARIO", "USUARIOS", 
            "Usuario " + accion + " actualizado", request);
    }
    
    public void registrarEliminacionUsuario(int idUsuario, String usuarioEliminado, HttpServletRequest request) {
        registrarBitacora(idUsuario, "ELIMINACION_USUARIO", "USUARIOS", 
            "Usuario eliminado: " + usuarioEliminado, request);
    }
    
    public void registrarGestionProducto(int idUsuario, String accion, String producto, HttpServletRequest request) {
        registrarBitacora(idUsuario, accion, "PRODUCTOS", 
            "Producto " + accion.toLowerCase() + ": " + producto, request);
    }
    
    public void registrarGestionServicio(int idUsuario, String accion, String servicio, HttpServletRequest request) {
        registrarBitacora(idUsuario, accion, "SERVICIOS", 
            "Servicio " + accion.toLowerCase() + ": " + servicio, request);
    }
    
    public void registrarAccionCarrito(int idUsuario, String accion, String detalles, HttpServletRequest request) {
        registrarBitacora(idUsuario, accion, "CARRITO", detalles, request);
    }
    
    // Getters y Setters
    public int getIdBitacora() { return idBitacora; }
    public void setIdBitacora(int idBitacora) { this.idBitacora = idBitacora; }
    
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    
    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }
    
    public String getModulo() { return modulo; }
    public void setModulo(String modulo) { this.modulo = modulo; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }
    
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
}