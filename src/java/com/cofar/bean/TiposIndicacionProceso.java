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
public class TiposIndicacionProceso extends AbstractBean
{
    private int codTipoIndicacionProceso=0;
    private String nombreTipoIndicacionProceso="";

    public TiposIndicacionProceso() {
    }

    public int getCodTipoIndicacionProceso() {
        return codTipoIndicacionProceso;
    }

    public void setCodTipoIndicacionProceso(int codTipoIndicacionProceso) {
        this.codTipoIndicacionProceso = codTipoIndicacionProceso;
    }

    public String getNombreTipoIndicacionProceso() {
        return nombreTipoIndicacionProceso;
    }

    public void setNombreTipoIndicacionProceso(String nombreTipoIndicacionProceso) {
        this.nombreTipoIndicacionProceso = nombreTipoIndicacionProceso;
    }

    
    
}
