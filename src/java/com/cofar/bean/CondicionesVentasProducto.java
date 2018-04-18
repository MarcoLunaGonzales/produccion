/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class CondicionesVentasProducto extends AbstractBean{
    private int codCondicionVentaProducto=0;
    private String nombreCondicionVentaProducto="";

    public int getCodCondicionVentaProducto() {
        return codCondicionVentaProducto;
    }

    public void setCodCondicionVentaProducto(int codCondicionVentaProducto) {
        this.codCondicionVentaProducto = codCondicionVentaProducto;
    }

    public String getNombreCondicionVentaProducto() {
        return nombreCondicionVentaProducto;
    }

    public void setNombreCondicionVentaProducto(String nombreCondicionVentaProducto) {
        this.nombreCondicionVentaProducto = nombreCondicionVentaProducto;
    }
    

}
