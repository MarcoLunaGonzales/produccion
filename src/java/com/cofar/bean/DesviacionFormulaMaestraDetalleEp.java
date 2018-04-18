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
public class DesviacionFormulaMaestraDetalleEp extends AbstractBean
{
    private PresentacionesPrimarias presentacionesPrimaria=new PresentacionesPrimarias();
    private Materiales materiales=new Materiales();
    private Double cantidad=0d;
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private Double cantidadUnitaria=0d;
    private boolean cantidadUnitariaPorUnidadProducto=false;

    public DesviacionFormulaMaestraDetalleEp() {
    }

    public PresentacionesPrimarias getPresentacionesPrimaria() {
        return presentacionesPrimaria;
    }

    public void setPresentacionesPrimaria(PresentacionesPrimarias presentacionesPrimaria) {
        this.presentacionesPrimaria = presentacionesPrimaria;
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

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public Double getCantidadUnitaria() {
        return cantidadUnitaria;
    }

    public void setCantidadUnitaria(Double cantidadUnitaria) {
        this.cantidadUnitaria = cantidadUnitaria;
    }

    public boolean isCantidadUnitariaPorUnidadProducto() {
        return cantidadUnitariaPorUnidadProducto;
    }

    public void setCantidadUnitariaPorUnidadProducto(boolean cantidadUnitariaPorUnidadProducto) {
        this.cantidadUnitariaPorUnidadProducto = cantidadUnitariaPorUnidadProducto;
    }
    
    
    
}
