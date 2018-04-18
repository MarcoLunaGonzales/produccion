/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author hvaldivia
 */
public class DocumentacionRespuestas extends AbstractBean {
    Documentacion documentacion = null;
    DocumentacionPreguntas documentacionPreguntas = null;
    String descripcionRespuesta = "";
    EstadoReferencial estadoRegistro = new EstadoReferencial();
    private boolean respuesta=false;
    public String getDescripcionRespuesta() {
        return descripcionRespuesta;
    }

    public void setDescripcionRespuesta(String descripcionRespuesta) {
        this.descripcionRespuesta = descripcionRespuesta;
    }

    public Documentacion getDocumentacion() {
        return documentacion;
    }

    public void setDocumentacion(Documentacion documentacion) {
        this.documentacion = documentacion;
    }

    public DocumentacionPreguntas getDocumentacionPreguntas() {
        return documentacionPreguntas;
    }

    public void setDocumentacionPreguntas(DocumentacionPreguntas documentacionPreguntas) {
        this.documentacionPreguntas = documentacionPreguntas;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public boolean isRespuesta() {
        return respuesta;
    }

    public void setRespuesta(boolean respuesta) {
        this.respuesta = respuesta;
    }


    
}
