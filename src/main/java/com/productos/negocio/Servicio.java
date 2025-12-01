package com.productos.negocio;

import com.productos.datos.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Servicio {

    private int id_ser;
    private int id_cat;
    private String nombre_ser;
    private double precio_base;
    private String unidad_medida;
    private String foto_ser;

    // ===========================================================
    // Constructores
    // ===========================================================
    public Servicio() {
    }

    public Servicio(int id_ser, int id_cat, String nombre_ser, double precio_base,
                    String unidad_medida, String foto_ser) {
        this.id_ser = id_ser;
        this.id_cat = id_cat;
        this.nombre_ser = nombre_ser;
        this.precio_base = precio_base;
        this.unidad_medida = unidad_medida;
        this.foto_ser = foto_ser;
    }

    // ===========================================================
    // Getters y Setters
    // ===========================================================
    public int getId_ser() {
        return id_ser;
    }

    public void setId_ser(int id_ser) {
        this.id_ser = id_ser;
    }

    public int getId_cat() {
        return id_cat;
    }

    public void setId_cat(int id_cat) {
        this.id_cat = id_cat;
    }

    public String getNombre_ser() {
        return nombre_ser;
    }

    public void setNombre_ser(String nombre_ser) {
        this.nombre_ser = nombre_ser;
    }

    public double getPrecio_base() {
        return precio_base;
    }

    public void setPrecio_base(double precio_base) {
        this.precio_base = precio_base;
    }

    public String getUnidad_medida() {
        return unidad_medida;
    }

    public void setUnidad_medida(String unidad_medida) {
        this.unidad_medida = unidad_medida;
    }

    public String getFoto_ser() {
        return foto_ser;
    }

    public void setFoto_ser(String foto_ser) {
        this.foto_ser = foto_ser;
    }

    // ===========================================================
    // LISTAR TODOS LOS SERVICIOS
    // ===========================================================
    public static List<Servicio> obtenerServicios() {
        List<Servicio> lista = new ArrayList<>();
        Conexion con = new Conexion();
        Connection cn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            cn = con.crearConexion();
            st = cn.createStatement();
            String sql = "SELECT * FROM tb_servicio ORDER BY id_ser;";
            rs = st.executeQuery(sql);

            while (rs.next()) {
                Servicio s = new Servicio(
                    rs.getInt("id_ser"),
                    rs.getInt("id_cat"),
                    rs.getString("nombre_ser"),
                    rs.getDouble("precio_base"),
                    rs.getString("unidad_medida"),
                    rs.getString("foto_ser")
                );
                lista.add(s);
            }

        } catch (Exception ex) {
            System.out.println("❌ Error al obtener servicios: " + ex.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {}
        }

        return lista;
    }

    // ===========================================================
    // OBTENER UN SERVICIO POR ID
    // ===========================================================
    public static Servicio obtenerServicioPorId(int id) {
        Conexion con = new Conexion();
        Connection cn = null;
        Statement st = null;
        ResultSet rs = null;
        Servicio s = null;

        try {
            cn = con.crearConexion();
            st = cn.createStatement();
            String sql = "SELECT * FROM tb_servicio WHERE id_ser = " + id;
            rs = st.executeQuery(sql);

            if (rs.next()) {
                s = new Servicio(
                    rs.getInt("id_ser"),
                    rs.getInt("id_cat"),
                    rs.getString("nombre_ser"),
                    rs.getDouble("precio_base"),
                    rs.getString("unidad_medida"),
                    rs.getString("foto_ser")
                );
            }

        } catch (Exception ex) {
            System.out.println("❌ Error al obtener servicio: " + ex.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (st != null) st.close(); } catch (SQLException e) {}
            try { if (cn != null) cn.close(); } catch (SQLException e) {}
        }

        return s;
    }

    // ===========================================================
    // INSERTAR NUEVO SERVICIO
    // ===========================================================
    public String insertarServicio() {
        Conexion con = new Conexion();

        String sql = "INSERT INTO tb_servicio (id_cat, nombre_ser, precio_base, unidad_medida, foto_ser) " +
                     "VALUES (" + id_cat + ", '" + nombre_ser + "', " + precio_base + ", '" +
                     unidad_medida + "', '" + foto_ser + "')";

        return con.Ejecutar(sql);
    }

    // ===========================================================
    // ACTUALIZAR SERVICIO
    // ===========================================================
    public String actualizarServicio() {
        Conexion con = new Conexion();

        String sql = "UPDATE tb_servicio SET "
                + "id_cat = " + id_cat + ", "
                + "nombre_ser = '" + nombre_ser + "', "
                + "precio_base = " + precio_base + ", "
                + "unidad_medida = '" + unidad_medida + "', "
                + "foto_ser = '" + foto_ser + "' "
                + "WHERE id_ser = " + id_ser;

        return con.Ejecutar(sql);
    }

    // ===========================================================
    // ELIMINAR SERVICIO
    // ===========================================================
    public static String eliminarServicio(int id) {
        Conexion con = new Conexion();
        String sql = "DELETE FROM tb_servicio WHERE id_ser = " + id;
        return con.Ejecutar(sql);
    }
}
