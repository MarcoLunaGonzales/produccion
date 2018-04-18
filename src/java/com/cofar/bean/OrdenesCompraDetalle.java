/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class OrdenesCompraDetalle extends AbstractBean
{
    private OrdenesCompra ordenesCompra=new OrdenesCompra();
    private Double cantidadNeta=0d;
    private Double precioUnitario=0d;

    public OrdenesCompraDetalle() {
    }

    public OrdenesCompra getOrdenesCompra() {
        return ordenesCompra;
    }

    public void setOrdenesCompra(OrdenesCompra ordenesCompra) {
        this.ordenesCompra = ordenesCompra;
    }

    public Double getCantidadNeta() {
        return cantidadNeta;
    }

    public void setCantidadNeta(Double cantidadNeta) {
        this.cantidadNeta = cantidadNeta;
    }

    public Double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(Double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }
    
    
}
