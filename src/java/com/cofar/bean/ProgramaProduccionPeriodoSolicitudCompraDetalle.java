/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.List;

/**
 *
 * @author DASISAQ
 */
public class ProgramaProduccionPeriodoSolicitudCompraDetalle extends AbstractBean
{
    private int codProgramaProduccionPeriodoSolicitudCompraDetalle=0;
    private EstadosProgramaProduccionPeriodoSolicitudCompraDetalle estadosProgramaProduccionPeriodoSolicitudCompraDetalle=new EstadosProgramaProduccionPeriodoSolicitudCompraDetalle();
    private Materiales materiales=new Materiales();
    private Double cantidadSolicitudProduccion=0d;
    private UnidadesMedida unidadMedidaProduccion=new UnidadesMedida();
    private Double cantidadSolicitudCompra=0d;
    private UnidadesMedida unidadMedidaCompra=new UnidadesMedida();
    private Double precioUnitario=0d;
    private OrdenesCompraDetalle ultimaOrdenCompra=new OrdenesCompraDetalle();
    private OrdenesCompraDetalle penultimaOrdenCompra=new OrdenesCompraDetalle();
    private List<ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion> programaProduccionPeriodoSolicitudCompraDetalleFraccionList;
    //variables para mostrar
    private Double cantidadExistenciaAlmacenTransitorio=0d;
    private Double cantidadTransito=0d;

    public ProgramaProduccionPeriodoSolicitudCompraDetalle() {
    }

    public int getCodProgramaProduccionPeriodoSolicitudCompraDetalle() {
        return codProgramaProduccionPeriodoSolicitudCompraDetalle;
    }

    public void setCodProgramaProduccionPeriodoSolicitudCompraDetalle(int codProgramaProduccionPeriodoSolicitudCompraDetalle) {
        this.codProgramaProduccionPeriodoSolicitudCompraDetalle = codProgramaProduccionPeriodoSolicitudCompraDetalle;
    }

    public EstadosProgramaProduccionPeriodoSolicitudCompraDetalle getEstadosProgramaProduccionPeriodoSolicitudCompraDetalle() {
        return estadosProgramaProduccionPeriodoSolicitudCompraDetalle;
    }

    public void setEstadosProgramaProduccionPeriodoSolicitudCompraDetalle(EstadosProgramaProduccionPeriodoSolicitudCompraDetalle estadosProgramaProduccionPeriodoSolicitudCompraDetalle) {
        this.estadosProgramaProduccionPeriodoSolicitudCompraDetalle = estadosProgramaProduccionPeriodoSolicitudCompraDetalle;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public Double getCantidadSolicitudProduccion() {
        return cantidadSolicitudProduccion;
    }

    public void setCantidadSolicitudProduccion(Double cantidadSolicitudProduccion) {
        this.cantidadSolicitudProduccion = cantidadSolicitudProduccion;
    }

    public UnidadesMedida getUnidadMedidaProduccion() {
        return unidadMedidaProduccion;
    }

    public void setUnidadMedidaProduccion(UnidadesMedida unidadMedidaProduccion) {
        this.unidadMedidaProduccion = unidadMedidaProduccion;
    }

    public Double getCantidadSolicitudCompra() {
        return cantidadSolicitudCompra;
    }

    public Double getCantidadExistenciaAlmacenTransitorio() {
        return cantidadExistenciaAlmacenTransitorio;
    }

    public void setCantidadExistenciaAlmacenTransitorio(Double cantidadExistenciaAlmacenTransitorio) {
        this.cantidadExistenciaAlmacenTransitorio = cantidadExistenciaAlmacenTransitorio;
    }

    
    public void setCantidadSolicitudCompra(Double cantidadSolicitudCompra) {
        this.cantidadSolicitudCompra = cantidadSolicitudCompra;
    }

    public UnidadesMedida getUnidadMedidaCompra() {
        return unidadMedidaCompra;
    }

    public void setUnidadMedidaCompra(UnidadesMedida unidadMedidaCompra) {
        this.unidadMedidaCompra = unidadMedidaCompra;
    }

    public Double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(Double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public OrdenesCompraDetalle getUltimaOrdenCompra() {
        return ultimaOrdenCompra;
    }

    public void setUltimaOrdenCompra(OrdenesCompraDetalle ultimaOrdenCompra) {
        this.ultimaOrdenCompra = ultimaOrdenCompra;
    }

    public OrdenesCompraDetalle getPenultimaOrdenCompra() {
        return penultimaOrdenCompra;
    }

    public void setPenultimaOrdenCompra(OrdenesCompraDetalle penultimaOrdenCompra) {
        this.penultimaOrdenCompra = penultimaOrdenCompra;
    }
    

    public List<ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion> getProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList() {
        return programaProduccionPeriodoSolicitudCompraDetalleFraccionList;
    }

    public Double getCantidadTransito() {
        return cantidadTransito;
    }

    public void setCantidadTransito(Double cantidadTransito) {
        this.cantidadTransito = cantidadTransito;
    }

    public void setProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList(List<ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion> programaProduccionPeriodoSolicitudCompraDetalleFraccionList) {
        this.programaProduccionPeriodoSolicitudCompraDetalleFraccionList = programaProduccionPeriodoSolicitudCompraDetalleFraccionList;
    }
    
    public int getProgramaProduccionPeriodoSolicitudCompraDetalleFraccionListSize()
    {
        return (this.programaProduccionPeriodoSolicitudCompraDetalleFraccionList!=null?programaProduccionPeriodoSolicitudCompraDetalleFraccionList.size():0);
    }
    
}
