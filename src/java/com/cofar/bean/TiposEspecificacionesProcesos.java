/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposEspecificacionesProcesos extends AbstractBean {
    private int codTipoEspecificaci�nProceso=0;
    private String nombreTipoEspecificacionProceso="";

    public TiposEspecificacionesProcesos() {
    }

    public int getCodTipoEspecificaci�nProceso() {
        return codTipoEspecificaci�nProceso;
    }

    public void setCodTipoEspecificaci�nProceso(int codTipoEspecificaci�nProceso) {
        this.codTipoEspecificaci�nProceso = codTipoEspecificaci�nProceso;
    }

    public String getNombreTipoEspecificacionProceso() {
        return nombreTipoEspecificacionProceso;
    }

    public void setNombreTipoEspecificacionProceso(String nombreTipoEspecificacionProceso) {
        this.nombreTipoEspecificacionProceso = nombreTipoEspecificacionProceso;
    }
    

}
