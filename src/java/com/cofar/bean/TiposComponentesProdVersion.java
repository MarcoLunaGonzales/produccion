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
public class TiposComponentesProdVersion extends AbstractBean
{
    
    private int codTipoComponentesProdVersion=0;
    private String nombreTipoComponentesProdVersion="";

    public TiposComponentesProdVersion() {
    }

    public int getCodTipoComponentesProdVersion() {
        return codTipoComponentesProdVersion;
    }

    public void setCodTipoComponentesProdVersion(int codTipoComponentesProdVersion) {
        this.codTipoComponentesProdVersion = codTipoComponentesProdVersion;
    }

    public String getNombreTipoComponentesProdVersion() {
        return nombreTipoComponentesProdVersion;
    }

    public void setNombreTipoComponentesProdVersion(String nombreTipoComponentesProdVersion) {
        this.nombreTipoComponentesProdVersion = nombreTipoComponentesProdVersion;
    }
    
    
}
