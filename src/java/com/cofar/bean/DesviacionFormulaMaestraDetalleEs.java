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
public class DesviacionFormulaMaestraDetalleEs extends AbstractBean
{
    private Double cantidad=0d;
    private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private Materiales materiales=new Materiales();

    public DesviacionFormulaMaestraDetalleEs() {
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }
    
    
}
