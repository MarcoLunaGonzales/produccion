/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class SolicitudesCompraDetalle {
    SolicitudesCompra solicitudesCompra = new SolicitudesCompra();
    Materiales materiales = new Materiales();
    double cantSolicitada = 0;
    UnidadesMedida unidadesMedida = new UnidadesMedida();
    String obsMaterialSolicitud = "";
    private Double precioUnitario=0d;

    public double getCantSolicitada() {
        return cantSolicitada;
    }

    public void setCantSolicitada(double cantSolicitada) {
        this.cantSolicitada = cantSolicitada;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public String getObsMaterialSolicitud() {
        return obsMaterialSolicitud;
    }

    public void setObsMaterialSolicitud(String obsMaterialSolicitud) {
        this.obsMaterialSolicitud = obsMaterialSolicitud;
    }

    public SolicitudesCompra getSolicitudesCompra() {
        return solicitudesCompra;
    }

    public void setSolicitudesCompra(SolicitudesCompra solicitudesCompra) {
        this.solicitudesCompra = solicitudesCompra;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public Double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(Double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    
    

}
