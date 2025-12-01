package com.productos.negocio;

public class ItemCarrito {
    private int id;
    private String nombre;
    private double precio;
    private int cantidad;
    private String imagen;

    public ItemCarrito(int id, String nombre, double precio, int cantidad, String imagen) {
        this.id = id;
        this.nombre = nombre;
        this.precio = precio;
        this.cantidad = cantidad;
        this.imagen = imagen;
    }

    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public double getPrecio() { return precio; }
    public int getCantidad() { return cantidad; }
    public String getImagen() { return imagen; }

    public double getSubtotal() {
        return precio * cantidad;
    }

    public void setCantidad(int c) {
        this.cantidad = c;
    }
}
