/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class EstadosSolicitudSalidasAlmacen {
    int codEstadoSolicitudSalidaAlmacen = 0;
    String nombreEstadoSolicitudSalidaAlmacen = "";
    String obsEstadoSolicitudSalidaAlmacen = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodEstadoSolicitudSalidaAlmacen() {
        return codEstadoSolicitudSalidaAlmacen;
    }

    public void setCodEstadoSolicitudSalidaAlmacen(int codEstadoSolicitudSalidaAlmacen) {
        this.codEstadoSolicitudSalidaAlmacen = codEstadoSolicitudSalidaAlmacen;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreEstadoSolicitudSalidaAlmacen() {
        return nombreEstadoSolicitudSalidaAlmacen;
    }

    public void setNombreEstadoSolicitudSalidaAlmacen(String nombreEstadoSolicitudSalidaAlmacen) {
        this.nombreEstadoSolicitudSalidaAlmacen = nombreEstadoSolicitudSalidaAlmacen;
    }

    public String getObsEstadoSolicitudSalidaAlmacen() {
        return obsEstadoSolicitudSalidaAlmacen;
    }

    public void setObsEstadoSolicitudSalidaAlmacen(String obsEstadoSolicitudSalidaAlmacen) {
        this.obsEstadoSolicitudSalidaAlmacen = obsEstadoSolicitudSalidaAlmacen;
    }
    


}
