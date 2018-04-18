/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class tiposSolicitudCompra {
    int codTipoSolicitudCompra = 0;
    String nombreTipoSolicitudCompra = "";
    String obsTipoSolicitudCompra = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodTipoSolicitudCompra() {
        return codTipoSolicitudCompra;
    }

    public void setCodTipoSolicitudCompra(int codTipoSolicitudCompra) {
        this.codTipoSolicitudCompra = codTipoSolicitudCompra;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreTipoSolicitudCompra() {
        return nombreTipoSolicitudCompra;
    }

    public void setNombreTipoSolicitudCompra(String nombreTipoSolicitudCompra) {
        this.nombreTipoSolicitudCompra = nombreTipoSolicitudCompra;
    }

    public String getObsTipoSolicitudCompra() {
        return obsTipoSolicitudCompra;
    }

    public void setObsTipoSolicitudCompra(String obsTipoSolicitudCompra) {
        this.obsTipoSolicitudCompra = obsTipoSolicitudCompra;
    }
    

}
