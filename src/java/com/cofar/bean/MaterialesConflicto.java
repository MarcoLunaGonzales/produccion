/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class MaterialesConflicto {
    Materiales materiales = new Materiales();
    Double cantidad = 0.0;
    List productosList = new ArrayList();
    Double cantidadRestanteAux = 0.0; //auxiliar para actualizacion de la cantidad disponible del material si se aprueban los productos
    public int getCantidadLista(){
        return productosList.size();
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public List getProductosList() {
        return productosList;
    }

    public void setProductosList(List productosList) {
        this.productosList = productosList;
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public Double getCantidadRestanteAux() {
        return cantidadRestanteAux;
    }

    public void setCantidadRestanteAux(Double cantidadRestanteAux) {
        this.cantidadRestanteAux = cantidadRestanteAux;
    }

    
    




    
    

}
