/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class TiposSalidasAlmacen {
    int codTipoSalidaAlmacen = 0;
    String nombreTipoSalidaAlmacen = "";
    String obsTipoSalidaAlmacen = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodTipoSalidaAlmacen() {
        return codTipoSalidaAlmacen;
    }

    public void setCodTipoSalidaAlmacen(int codTipoSalidaAlmacen) {
        this.codTipoSalidaAlmacen = codTipoSalidaAlmacen;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreTipoSalidaAlmacen() {
        return nombreTipoSalidaAlmacen;
    }

    public void setNombreTipoSalidaAlmacen(String nombreTipoSalidaAlmacen) {
        this.nombreTipoSalidaAlmacen = nombreTipoSalidaAlmacen;
    }

    public String getObsTipoSalidaAlmacen() {
        return obsTipoSalidaAlmacen;
    }

    public void setObsTipoSalidaAlmacen(String obsTipoSalidaAlmacen) {
        this.obsTipoSalidaAlmacen = obsTipoSalidaAlmacen;
    }



}
