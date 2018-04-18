/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class EspecificacionesMicrobiologiaCc extends AbstractBean{
    int codEspecificacion = 0;
    String nombreEspecificacion = "";
    TiposReferenciaCc tiposReferenciaCc = new TiposReferenciaCc();
    private TiposResultadosAnalisis tipoResultadoAnalisis= new TiposResultadosAnalisis();
    private String coeficiente="";
    private String unidad="";
    public int getCodEspecificacion() {
        return codEspecificacion;
    }

    public void setCodEspecificacion(int codEspecificacion) {
        this.codEspecificacion = codEspecificacion;
    }

    public TiposResultadosAnalisis getTipoResultadoAnalisis() {
        return tipoResultadoAnalisis;
    }

    public void setTipoResultadoAnalisis(TiposResultadosAnalisis tipoResultadoAnalisis) {
        this.tipoResultadoAnalisis = tipoResultadoAnalisis;
    }

    public String getNombreEspecificacion() {
        return nombreEspecificacion;
    }

    public void setNombreEspecificacion(String nombreEspecificacion) {
        this.nombreEspecificacion = nombreEspecificacion;
    }

    public TiposReferenciaCc getTiposReferenciaCc() {
        return tiposReferenciaCc;
    }

    public void setTiposReferenciaCc(TiposReferenciaCc tiposReferenciaCc) {
        this.tiposReferenciaCc = tiposReferenciaCc;
    }

    public String getCoeficiente() {
        return coeficiente;
    }

    public void setCoeficiente(String coeficiente) {
        this.coeficiente = coeficiente;
    }

    public String getUnidad() {
        return unidad;
    }

    public void setUnidad(String unidad) {
        this.unidad = unidad;
    }



}
