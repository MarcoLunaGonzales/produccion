/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposDocumentoBiblioteca extends AbstractBean{
    private int codTipoDocumentobiblioteca=0;
    private String nombreTipoDocumentoBiblioteca="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposDocumentoBiblioteca() {
    }

    public int getCodTipoDocumentobiblioteca() {
        return codTipoDocumentobiblioteca;
    }

    public void setCodTipoDocumentobiblioteca(int codTipoDocumentobiblioteca) {
        this.codTipoDocumentobiblioteca = codTipoDocumentobiblioteca;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoDocumentoBiblioteca() {
        return nombreTipoDocumentoBiblioteca;
    }

    public void setNombreTipoDocumentoBiblioteca(String nombreTipoDocumentoBiblioteca) {
        this.nombreTipoDocumentoBiblioteca = nombreTipoDocumentoBiblioteca;
    }



}
