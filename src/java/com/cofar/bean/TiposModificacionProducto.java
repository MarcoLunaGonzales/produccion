/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class TiposModificacionProducto {
    int codTipoModificacionProducto = 0;
    String nombreTipoModificacionProducto = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodTipoModificacionProducto() {
        return codTipoModificacionProducto;
    }

    public void setCodTipoModificacionProducto(int codTipoModificacionProducto) {
        this.codTipoModificacionProducto = codTipoModificacionProducto;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreTipoModificacionProducto() {
        return nombreTipoModificacionProducto;
    }

    public void setNombreTipoModificacionProducto(String nombreTipoModificacionProducto) {
        this.nombreTipoModificacionProducto = nombreTipoModificacionProducto;
    }

    

}
