/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class DefectosEnvase  extends AbstractBean{
    private int codDefectoEnvase=0;
    private String nombreDefectoEnvase="";
    private EstadoReferencial estado=new EstadoReferencial();
    public DefectosEnvase() {
    }

    public int getCodDefectoEnvase() {
        return codDefectoEnvase;
    }

    public void setCodDefectoEnvase(int codDefectoEnvase) {
        this.codDefectoEnvase = codDefectoEnvase;
    }

    public String getNombreDefectoEnvase() {
        return nombreDefectoEnvase;
    }

    public void setNombreDefectoEnvase(String nombreDefectoEnvase) {
        this.nombreDefectoEnvase = nombreDefectoEnvase;
    }

    public EstadoReferencial getEstado() {
        return estado;
    }

    public void setEstado(EstadoReferencial estado) {
        this.estado = estado;
    }
    
    
}
