package com.productos.negocio;

public class Producto {
    private int id_pr;
    private int id_cat;
    private String nombre_pr;
    private int cantidad_pr;
    private double precio_pr;
    private String foto_pr;

    public Producto() {}

    public Producto(int id_pr, int id_cat, String nombre_pr, int cantidad_pr, double precio_pr, String foto_pr) {
        this.id_pr = id_pr;
        this.id_cat = id_cat;
        this.nombre_pr = nombre_pr;
        this.cantidad_pr = cantidad_pr;
        this.precio_pr = precio_pr;
        this.foto_pr = foto_pr;
    }

    // Getters y Setters
    public int getId_pr() { return id_pr; }
    public void setId_pr(int id_pr) { this.id_pr = id_pr; }
    public int getId_cat() { return id_cat; }
    public void setId_cat(int id_cat) { this.id_cat = id_cat; }
    public String getNombre_pr() { return nombre_pr; }
    public void setNombre_pr(String nombre_pr) { this.nombre_pr = nombre_pr; }
    public int getCantidad_pr() { return cantidad_pr; }
    public void setCantidad_pr(int cantidad_pr) { this.cantidad_pr = cantidad_pr; }
    public double getPrecio_pr() { return precio_pr; }
    public void setPrecio_pr(double precio_pr) { this.precio_pr = precio_pr; }
    public String getFoto_pr() { return foto_pr; }
    public void setFoto_pr(String foto_pr) { this.foto_pr = foto_pr; }
}
