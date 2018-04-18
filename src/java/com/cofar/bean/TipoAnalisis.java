/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class TipoAnalisis extends AbstractBean{

    private String nombreTipoAnalisis="";
    private int codTipoAnalisis=0;
    public TipoAnalisis() {
    }

    public int getCodTipoAnalisis() {
        return codTipoAnalisis;
    }

    public void setCodTipoAnalisis(int codTipoAnalisis) {
        this.codTipoAnalisis = codTipoAnalisis;
    }

    public String getNombreTipoAnalisis() {
        return nombreTipoAnalisis;
    }

    public void setNombreTipoAnalisis(String nombreTipoAnalisis) {
        this.nombreTipoAnalisis = nombreTipoAnalisis;
    }



}
