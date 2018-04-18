/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposEstudioEstabilidad extends AbstractBean{
    private int codTipoEstudioEstabilidad=0;
    private String nombreTipoEstudioEstabilidad="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposEstudioEstabilidad() {
    }



    public int getCodTipoEstudioEstabilidad() {
        return codTipoEstudioEstabilidad;
    }

    public void setCodTipoEstudioEstabilidad(int codTipoEstudioEstabilidad) {
        this.codTipoEstudioEstabilidad = codTipoEstudioEstabilidad;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoEstudioEstabilidad() {
        return nombreTipoEstudioEstabilidad;
    }

    public void setNombreTipoEstudioEstabilidad(String nombreTipoEstudioEstabilidad) {
        this.nombreTipoEstudioEstabilidad = nombreTipoEstudioEstabilidad;
    }

}
