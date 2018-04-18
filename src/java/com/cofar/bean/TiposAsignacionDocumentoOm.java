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
public class TiposAsignacionDocumentoOm extends AbstractBean
{
    private int codTipoAsignacionDocumentacionOm=0;
    private String nombreTipoAsignacionDocumentacionOm="";

    public TiposAsignacionDocumentoOm() {
    }

    public int getCodTipoAsignacionDocumentacionOm() {
        return codTipoAsignacionDocumentacionOm;
    }

    public void setCodTipoAsignacionDocumentacionOm(int codTipoAsignacionDocumentacionOm) {
        this.codTipoAsignacionDocumentacionOm = codTipoAsignacionDocumentacionOm;
    }

    public String getNombreTipoAsignacionDocumentacionOm() {
        return nombreTipoAsignacionDocumentacionOm;
    }

    public void setNombreTipoAsignacionDocumentacionOm(String nombreTipoAsignacionDocumentacionOm) {
        this.nombreTipoAsignacionDocumentacionOm = nombreTipoAsignacionDocumentacionOm;
    }
    
    
}
