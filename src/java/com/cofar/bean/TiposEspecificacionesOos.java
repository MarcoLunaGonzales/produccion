/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class TiposEspecificacionesOos extends AbstractBean{
    private int codTipoEspecificacionOos=0;
    private String nombreTipoEspecificacionOos="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposEspecificacionesOos() {
    }

    public int getCodTipoEspecificacionOos() {
        return codTipoEspecificacionOos;
    }

    public void setCodTipoEspecificacionOos(int codTipoEspecificacionOos) {
        this.codTipoEspecificacionOos = codTipoEspecificacionOos;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoEspecificacionOos() {
        return nombreTipoEspecificacionOos;
    }

    public void setNombreTipoEspecificacionOos(String nombreTipoEspecificacionOos) {
        this.nombreTipoEspecificacionOos = nombreTipoEspecificacionOos;
    }
    



}
