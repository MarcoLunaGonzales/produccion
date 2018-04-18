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
    private int codTipoEspecificaciónProceso=0;
    private String nombreTipoEspecificacionProceso="";

    public TiposEspecificacionesProcesos() {
    }

    public int getCodTipoEspecificaciónProceso() {
        return codTipoEspecificaciónProceso;
    }

    public void setCodTipoEspecificaciónProceso(int codTipoEspecificaciónProceso) {
        this.codTipoEspecificaciónProceso = codTipoEspecificaciónProceso;
    }

    public String getNombreTipoEspecificacionProceso() {
        return nombreTipoEspecificacionProceso;
    }

    public void setNombreTipoEspecificacionProceso(String nombreTipoEspecificacionProceso) {
        this.nombreTipoEspecificacionProceso = nombreTipoEspecificacionProceso;
    }
    

}
