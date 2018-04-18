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
public class FormasFarmaceuticasDocumentacionAplicada extends AbstractBean
{
    private TiposAsignacionDocumentoOm tiposAsignacionDocumentoOm=new TiposAsignacionDocumentoOm();
    private Documentacion documentacion=new Documentacion();
    private FormasFarmaceuticas formasFarmaceuticas=new FormasFarmaceuticas();

    public FormasFarmaceuticasDocumentacionAplicada() {
    }

    public TiposAsignacionDocumentoOm getTiposAsignacionDocumentoOm() {
        return tiposAsignacionDocumentoOm;
    }

    public void setTiposAsignacionDocumentoOm(TiposAsignacionDocumentoOm tiposAsignacionDocumentoOm) {
        this.tiposAsignacionDocumentoOm = tiposAsignacionDocumentoOm;
    }

    public Documentacion getDocumentacion() {
        return documentacion;
    }

    public void setDocumentacion(Documentacion documentacion) {
        this.documentacion = documentacion;
    }

    public FormasFarmaceuticas getFormasFarmaceuticas() {
        return formasFarmaceuticas;
    }

    public void setFormasFarmaceuticas(FormasFarmaceuticas formasFarmaceuticas) {
        this.formasFarmaceuticas = formasFarmaceuticas;
    }
    
    
}
