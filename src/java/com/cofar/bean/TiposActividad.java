/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class TiposActividad extends AbstractBean{

    private String nombreTipoActividad="";
    private int codTipoActividad=0;
    public TiposActividad() {
        super();
    }

    public int getCodTipoActividad() {
        return codTipoActividad;
    }

    public void setCodTipoActividad(int codTipoActividad) {
        this.codTipoActividad = codTipoActividad;
    }

    

    public String getNombreTipoActividad() {
        return nombreTipoActividad;
    }

    public void setNombreTipoActividad(String nombreTipoActividad) {
        this.nombreTipoActividad = nombreTipoActividad;
    }




}
