/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposResultadosAnalisis extends AbstractBean{
    private String codTipoResultadoAnalisis="";
    private String nombreTipoResultadoAnalisis="";
    private String simbolo="";
    public TiposResultadosAnalisis() {
    }

    public String getCodTipoResultadoAnalisis() {
        return codTipoResultadoAnalisis;
    }

    public void setCodTipoResultadoAnalisis(String codTipoResultadoAnalisis) {
        this.codTipoResultadoAnalisis = codTipoResultadoAnalisis;
    }

    public String getNombreTipoResultadoAnalisis() {
        return nombreTipoResultadoAnalisis;
    }

    public void setNombreTipoResultadoAnalisis(String nombreTipoResultadoAnalisis) {
        this.nombreTipoResultadoAnalisis = nombreTipoResultadoAnalisis;
    }

    public String getSimbolo() {
        return simbolo;
    }

    public void setSimbolo(String simbolo) {
        this.simbolo = simbolo;
    }


}
