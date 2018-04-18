/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposDocumentoBpmIso extends AbstractBean{
    private int codTipoDocumentoBpmIso=0;
    private String nombreTipoDocumentoBpmIso="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposDocumentoBpmIso() {
    }

    public int getCodTipoDocumentoBpmIso() {
        return codTipoDocumentoBpmIso;
    }

    public void setCodTipoDocumentoBpmIso(int codTipoDocumentoBpmIso) {
        this.codTipoDocumentoBpmIso = codTipoDocumentoBpmIso;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoDocumentoBpmIso() {
        return nombreTipoDocumentoBpmIso;
    }

    public void setNombreTipoDocumentoBpmIso(String nombreTipoDocumentoBpmIso) {
        this.nombreTipoDocumentoBpmIso = nombreTipoDocumentoBpmIso;
    }
    

}
