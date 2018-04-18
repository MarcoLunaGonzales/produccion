/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposProduccion extends AbstractBean{
    private int codTipoProduccion=0;
    private String nombreTipoProduccion="";
    public TiposProduccion() {
    }

    public int getCodTipoProduccion() {
        return codTipoProduccion;
    }

    public void setCodTipoProduccion(int codTipoProduccion) {
        this.codTipoProduccion = codTipoProduccion;
    }

    public String getNombreTipoProduccion() {
        return nombreTipoProduccion;
    }

    public void setNombreTipoProduccion(String nombreTipoProduccion) {
        this.nombreTipoProduccion = nombreTipoProduccion;
    }
    



}
