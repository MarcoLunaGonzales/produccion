/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposEspecificacionesFisicas extends AbstractBean{
    private int codTipoEspecificacionFisica=0;
    private String nombreTipoEspecificacionFisica="";

    public TiposEspecificacionesFisicas() {
    }

    public int getCodTipoEspecificacionFisica() {
        return codTipoEspecificacionFisica;
    }

    public void setCodTipoEspecificacionFisica(int codTipoEspecificacionFisica) {
        this.codTipoEspecificacionFisica = codTipoEspecificacionFisica;
    }

    public String getNombreTipoEspecificacionFisica() {
        return nombreTipoEspecificacionFisica;
    }

    public void setNombreTipoEspecificacionFisica(String nombreTipoEspecificacionFisica) {
        this.nombreTipoEspecificacionFisica = nombreTipoEspecificacionFisica;
    }

    

}
