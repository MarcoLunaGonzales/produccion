/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class DesviacionFormulaMaestraDetalleMpFracciones extends AbstractBean
{
    private Materiales materiales;
    private Double cantidad=0d;
    private TiposMaterialProduccion tiposMaterialProduccion=new TiposMaterialProduccion();
    private Double porcientoFraccion=0d;
    public DesviacionFormulaMaestraDetalleMpFracciones() {
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public TiposMaterialProduccion getTiposMaterialProduccion() {
        return tiposMaterialProduccion;
    }

    public void setTiposMaterialProduccion(TiposMaterialProduccion tiposMaterialProduccion) {
        this.tiposMaterialProduccion = tiposMaterialProduccion;
    }

    public Double getPorcientoFraccion() {
        return porcientoFraccion;
    }

    public void setPorcientoFraccion(Double porcientoFraccion) {
        this.porcientoFraccion = porcientoFraccion;
    }
    
    
    
    
}
