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
public class ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion extends AbstractBean
{
    private int codProgramaProduccionPeriodoSolicitudCompraDetalleFraccion=0;
    private Double cantidadFraccion=0d;
    private TiposTransporte tiposTransporte=new TiposTransporte();
    private String observacion="";
    private OrdenesCompraDetalle ordenesCompraDetalle=new OrdenesCompraDetalle();

    public ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion() {
    }

    public int getCodProgramaProduccionPeriodoSolicitudCompraDetalleFraccion() {
        return codProgramaProduccionPeriodoSolicitudCompraDetalleFraccion;
    }

    public void setCodProgramaProduccionPeriodoSolicitudCompraDetalleFraccion(int codProgramaProduccionPeriodoSolicitudCompraDetalleFraccion) {
        this.codProgramaProduccionPeriodoSolicitudCompraDetalleFraccion = codProgramaProduccionPeriodoSolicitudCompraDetalleFraccion;
    }

    public Double getCantidadFraccion() {
        return cantidadFraccion;
    }

    public void setCantidadFraccion(Double cantidadFraccion) {
        this.cantidadFraccion = cantidadFraccion;
    }

    public TiposTransporte getTiposTransporte() {
        return tiposTransporte;
    }

    public void setTiposTransporte(TiposTransporte tiposTransporte) {
        this.tiposTransporte = tiposTransporte;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public OrdenesCompraDetalle getOrdenesCompraDetalle() {
        return ordenesCompraDetalle;
    }

    public void setOrdenesCompraDetalle(OrdenesCompraDetalle ordenesCompraDetalle) {
        this.ordenesCompraDetalle = ordenesCompraDetalle;
    }
    
    
    
    
}
