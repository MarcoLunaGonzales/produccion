/*
 * AccionesMateriales.java
 *
 * Created on 7 de septiembre de 2010, 09:02 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Guery Garcia Jaldin
 */
public class ComponentesProdVersionDocumentacionAplicada extends AbstractBean
{
    private int codComponentesProdVersionDocumentacionAplicada=0;
    private Documentacion documentacion=new Documentacion();
    private TiposAsignacionDocumentoOm tiposAsignacionDocumentoOm=new TiposAsignacionDocumentoOm();

    public Documentacion getDocumentacion() {
        return documentacion;
    }

    public void setDocumentacion(Documentacion documentacion) {
        this.documentacion = documentacion;
    }

    public TiposAsignacionDocumentoOm getTiposAsignacionDocumentoOm() {
        return tiposAsignacionDocumentoOm;
    }

    public void setTiposAsignacionDocumentoOm(TiposAsignacionDocumentoOm tiposAsignacionDocumentoOm) {
        this.tiposAsignacionDocumentoOm = tiposAsignacionDocumentoOm;
    }

    public ComponentesProdVersionDocumentacionAplicada() {
    }

    public int getCodComponentesProdVersionDocumentacionAplicada() {
        return codComponentesProdVersionDocumentacionAplicada;
    }

    public void setCodComponentesProdVersionDocumentacionAplicada(int codComponentesProdVersionDocumentacionAplicada) {
        this.codComponentesProdVersionDocumentacionAplicada = codComponentesProdVersionDocumentacionAplicada;
    }
    
    
}
