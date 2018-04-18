/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class EspecificacionesTecnicas extends AbstractBean{
    private int codEspecificacionTecnica=0;
    private String nombreEspecificacionTecnica="";
    private TiposEspecificacionesTecnicas tiposEspecificacionesTecnica=new TiposEspecificacionesTecnicas();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public EspecificacionesTecnicas() {
    }

    public int getCodEspecificacionTecnica() {
        return codEspecificacionTecnica;
    }

    public void setCodEspecificacionTecnica(int codEspecificacionTecnica) {
        this.codEspecificacionTecnica = codEspecificacionTecnica;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreEspecificacionTecnica() {
        return nombreEspecificacionTecnica;
    }

    public void setNombreEspecificacionTecnica(String nombreEspecificacionTecnica) {
        this.nombreEspecificacionTecnica = nombreEspecificacionTecnica;
    }

    public TiposEspecificacionesTecnicas getTiposEspecificacionesTecnica() {
        return tiposEspecificacionesTecnica;
    }

    public void setTiposEspecificacionesTecnica(TiposEspecificacionesTecnicas tiposEspecificacionesTecnica) {
        this.tiposEspecificacionesTecnica = tiposEspecificacionesTecnica;
    }
    

}
