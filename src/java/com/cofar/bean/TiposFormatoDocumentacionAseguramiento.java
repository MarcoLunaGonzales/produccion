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
public class TiposFormatoDocumentacionAseguramiento extends AbstractBean
{
    private int codTipoFormatoDocumentacionAseguramiento=0;
    private String nombreTipoFormatoDocumentacionAseguramiento="";

    public TiposFormatoDocumentacionAseguramiento() {
    }

    public int getCodTipoFormatoDocumentacionAseguramiento() {
        return codTipoFormatoDocumentacionAseguramiento;
    }

    public void setCodTipoFormatoDocumentacionAseguramiento(int codTipoFormatoDocumentacionAseguramiento) {
        this.codTipoFormatoDocumentacionAseguramiento = codTipoFormatoDocumentacionAseguramiento;
    }

    public String getNombreTipoFormatoDocumentacionAseguramiento() {
        return nombreTipoFormatoDocumentacionAseguramiento;
    }

    public void setNombreTipoFormatoDocumentacionAseguramiento(String nombreTipoFormatoDocumentacionAseguramiento) {
        this.nombreTipoFormatoDocumentacionAseguramiento = nombreTipoFormatoDocumentacionAseguramiento;
    }
    
    
}
