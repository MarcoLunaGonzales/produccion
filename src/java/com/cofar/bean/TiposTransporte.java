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
public class TiposTransporte extends AbstractBean 
{
    private int codTipoTransporte=0;
    private String nombreTipoTransporte="";

    public TiposTransporte() {
    }

    public int getCodTipoTransporte() {
        return codTipoTransporte;
    }

    public void setCodTipoTransporte(int codTipoTransporte) {
        this.codTipoTransporte = codTipoTransporte;
    }

    public String getNombreTipoTransporte() {
        return nombreTipoTransporte;
    }

    public void setNombreTipoTransporte(String nombreTipoTransporte) {
        this.nombreTipoTransporte = nombreTipoTransporte;
    }
    
    
}
