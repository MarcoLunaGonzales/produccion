/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class TiposDocumentacionPreguntas extends AbstractBean{
    private int codTipoDocumentacionPregunta=0;
    private String nombreTipoDocumentacionPregunta="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposDocumentacionPreguntas() {
    }

    public int getCodTipoDocumentacionPregunta() {
        return codTipoDocumentacionPregunta;
    }

    public void setCodTipoDocumentacionPregunta(int codTipoDocumentacionPregunta) {
        this.codTipoDocumentacionPregunta = codTipoDocumentacionPregunta;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreTipoDocumentacionPregunta() {
        return nombreTipoDocumentacionPregunta;
    }

    public void setNombreTipoDocumentacionPregunta(String nombreTipoDocumentacionPregunta) {
        this.nombreTipoDocumentacionPregunta = nombreTipoDocumentacionPregunta;
    }
    

}
