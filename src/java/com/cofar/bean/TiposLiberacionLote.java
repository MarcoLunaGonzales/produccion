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
public class TiposLiberacionLote extends AbstractBean {
    private int codTipoLiberacionLote=0;
    private String nombreTipoLiberacionLote="";

    public TiposLiberacionLote() {
    }

    public int getCodTipoLiberacionLote() {
        return codTipoLiberacionLote;
    }

    public void setCodTipoLiberacionLote(int codTipoLiberacionLote) {
        this.codTipoLiberacionLote = codTipoLiberacionLote;
    }

    public String getNombreTipoLiberacionLote() {
        return nombreTipoLiberacionLote;
    }

    public void setNombreTipoLiberacionLote(String nombreTipoLiberacionLote) {
        this.nombreTipoLiberacionLote = nombreTipoLiberacionLote;
    }
    
    
}
