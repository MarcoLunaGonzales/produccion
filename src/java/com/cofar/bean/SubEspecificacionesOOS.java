/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class SubEspecificacionesOOS extends AbstractBean {
    private int codSubEspecificacionOOS=0;
    private String nombreSubEspecificacionesOOS="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private int nroOrden=0;
    private String descripcionEspecificaciones="";
    public SubEspecificacionesOOS() {
    }

    public int getCodSubEspecificacionOOS() {
        return codSubEspecificacionOOS;
    }

    public void setCodSubEspecificacionOOS(int codSubEspecificacionOOS) {
        this.codSubEspecificacionOOS = codSubEspecificacionOOS;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreSubEspecificacionesOOS() {
        return nombreSubEspecificacionesOOS;
    }

    public void setNombreSubEspecificacionesOOS(String nombreSubEspecificacionesOOS) {
        this.nombreSubEspecificacionesOOS = nombreSubEspecificacionesOOS;
    }

    public int getNroOrden() {
        return nroOrden;
    }

    public void setNroOrden(int nroOrden) {
        this.nroOrden = nroOrden;
    }

    public String getDescripcionEspecificaciones() {
        return descripcionEspecificaciones;
    }

    public void setDescripcionEspecificaciones(String descripcionEspecificaciones) {
        this.descripcionEspecificaciones = descripcionEspecificaciones;
    }

    

}
