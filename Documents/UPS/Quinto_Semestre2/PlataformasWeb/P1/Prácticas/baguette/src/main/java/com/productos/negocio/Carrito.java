package com.productos.negocio;

import java.util.ArrayList;

public class Carrito {

    private ArrayList<ItemCarrito> items = new ArrayList<>();

    public void agregarItem(ItemCarrito item) {
        for (ItemCarrito i : items) {
            if (i.getId() == item.getId()) {
                i.setCantidad(i.getCantidad() + item.getCantidad());
                return;
            }
        }
        items.add(item);
    }

    public ArrayList<ItemCarrito> getItems() {
        return items;
    }

    public double getTotal() {
        double t = 0;
        for (ItemCarrito i : items) {
            t += i.getSubtotal();
        }
        return t;
    }

    public void limpiar() {
        items.clear();
    }
}
