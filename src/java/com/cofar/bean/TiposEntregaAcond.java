/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class TiposEntregaAcond extends AbstractBean{
    private int codTipoEntregaAcond = 0;
    private String nombreTipoEntregaAcond = "";

    public TiposEntregaAcond() {
    }

    public int getCodTipoEntregaAcond() {
        return codTipoEntregaAcond;
    }

    public void setCodTipoEntregaAcond(int codTipoEntregaAcond) {
        this.codTipoEntregaAcond = codTipoEntregaAcond;
    }

    public String getNombreTipoEntregaAcond() {
        return nombreTipoEntregaAcond;
    }

    public void setNombreTipoEntregaAcond(String nombreTipoEntregaAcond) {
        this.nombreTipoEntregaAcond = nombreTipoEntregaAcond;
    }
    
    
}
