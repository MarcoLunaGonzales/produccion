/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class SolicitudesSalidaDetalle {
    SolicitudesSalida solicitudesSalida = new SolicitudesSalida();
    Materiales materiales = new Materiales();
    UnidadesMedida unidadesMedida = new UnidadesMedida();
    double cantidad = 0;
    double cantidadEntregada = 0;
    double disponible = 0;

    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    public double getCantidadEntregada() {
        return cantidadEntregada;
    }

    public void setCantidadEntregada(double cantidadEntregada) {
        this.cantidadEntregada = cantidadEntregada;
    }

    public SolicitudesSalida getSolicitudesSalida() {
        return solicitudesSalida;
    }

    public void setSolicitudesSalida(SolicitudesSalida solicitudesSalida) {
        this.solicitudesSalida = solicitudesSalida;
    }



    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public double getDisponible() {
        return disponible;
    }

    public void setDisponible(double disponible) {
        this.disponible = disponible;
    }

   

}
