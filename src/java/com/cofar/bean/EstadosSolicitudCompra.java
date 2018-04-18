/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class EstadosSolicitudCompra {
    int codEstadoSolicitudCompra = 0;
    String nombreEstadoSolicitudCompra = "";
    String nombreEstadoSolicitudParaCompras = "";
    String obsEstadoSolicitudCompra = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodEstadoSolicitudCompra() {
        return codEstadoSolicitudCompra;
    }

    public void setCodEstadoSolicitudCompra(int codEstadoSolicitudCompra) {
        this.codEstadoSolicitudCompra = codEstadoSolicitudCompra;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreEstadoSolicitudCompra() {
        return nombreEstadoSolicitudCompra;
    }

    public void setNombreEstadoSolicitudCompra(String nombreEstadoSolicitudCompra) {
        this.nombreEstadoSolicitudCompra = nombreEstadoSolicitudCompra;
    }

    public String getNombreEstadoSolicitudParaCompras() {
        return nombreEstadoSolicitudParaCompras;
    }

    public void setNombreEstadoSolicitudParaCompras(String nombreEstadoSolicitudParaCompras) {
        this.nombreEstadoSolicitudParaCompras = nombreEstadoSolicitudParaCompras;
    }

    public String getObsEstadoSolicitudCompra() {
        return obsEstadoSolicitudCompra;
    }

    public void setObsEstadoSolicitudCompra(String obsEstadoSolicitudCompra) {
        this.obsEstadoSolicitudCompra = obsEstadoSolicitudCompra;
    }

    

}
