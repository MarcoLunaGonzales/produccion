/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class EstadosMarcaProducto extends AbstractBean{
    private int codEstadoMarcaProducto=0;
    private String nombreEstadoMarcaProducto="";

    public EstadosMarcaProducto() {
    }

    public int getCodEstadoMarcaProducto() {
        return codEstadoMarcaProducto;
    }

    public void setCodEstadoMarcaProducto(int codEstadoMarcaProducto) {
        this.codEstadoMarcaProducto = codEstadoMarcaProducto;
    }

    public String getNombreEstadoMarcaProducto() {
        return nombreEstadoMarcaProducto;
    }

    public void setNombreEstadoMarcaProducto(String nombreEstadoMarcaProducto) {
        this.nombreEstadoMarcaProducto = nombreEstadoMarcaProducto;
    }
    

}
