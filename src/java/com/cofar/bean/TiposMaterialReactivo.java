/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class TiposMaterialReactivo {
    int codTipoMaterialReactivo = 0;
    String nombreTipoMaterialReactivo = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodTipoMaterialReactivo() {
        return codTipoMaterialReactivo;
    }

    public void setCodTipoMaterialReactivo(int codTipoMaterialReactivo) {
        this.codTipoMaterialReactivo = codTipoMaterialReactivo;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreTipoMaterialReactivo() {
        return nombreTipoMaterialReactivo;
    }

    public void setNombreTipoMaterialReactivo(String nombreTipoMaterialReactivo) {
        this.nombreTipoMaterialReactivo = nombreTipoMaterialReactivo;
    }

}
