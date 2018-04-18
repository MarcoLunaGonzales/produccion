/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class TiposResultadosEspecificacionProceso extends AbstractBean
{
    private int codTipoResultadoEspecificacionProceso=0;
    private String nombreTipoResultadoEspecificacionProceso="";
    private String simbolo="";

    public TiposResultadosEspecificacionProceso() {
    }

    public int getCodTipoResultadoEspecificacionProceso() {
        return codTipoResultadoEspecificacionProceso;
    }

    public void setCodTipoResultadoEspecificacionProceso(int codTipoResultadoEspecificacionProceso) {
        this.codTipoResultadoEspecificacionProceso = codTipoResultadoEspecificacionProceso;
    }

    public String getNombreTipoResultadoEspecificacionProceso() {
        return nombreTipoResultadoEspecificacionProceso;
    }

    public void setNombreTipoResultadoEspecificacionProceso(String nombreTipoResultadoEspecificacionProceso) {
        this.nombreTipoResultadoEspecificacionProceso = nombreTipoResultadoEspecificacionProceso;
    }

    public String getSimbolo() {
        return simbolo;
    }

    public void setSimbolo(String simbolo) {
        this.simbolo = simbolo;
    }
    
    
}
