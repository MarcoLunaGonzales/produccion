/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposNivelSolicitudMantenimiento extends AbstractBean
{
    private int codTipoNivelSolicitudMantenimiento=0;
    private String nombreNivelSolicitudMantenimiento = "";

    public int getCodTipoNivelSolicitudMantenimiento() {
        return codTipoNivelSolicitudMantenimiento;
    }

    public void setCodTipoNivelSolicitudMantenimiento(int codTipoNivelSolicitudMantenimiento) {
        this.codTipoNivelSolicitudMantenimiento = codTipoNivelSolicitudMantenimiento;
    }

    public String getNombreNivelSolicitudMantenimiento() {
        return nombreNivelSolicitudMantenimiento;
    }

    public void setNombreNivelSolicitudMantenimiento(String nombreNivelSolicitudMantenimiento) {
        this.nombreNivelSolicitudMantenimiento = nombreNivelSolicitudMantenimiento;
    }

    
    
}
