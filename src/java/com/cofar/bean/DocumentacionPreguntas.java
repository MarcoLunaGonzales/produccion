/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class DocumentacionPreguntas extends AbstractBean {
    Documentacion documentacion = new Documentacion();
    int codPregunta = 0;
    int nroPregunta = 0;
    String descripcionPregunta = "";
    Date fechaCreacion = new Date();
    EstadoReferencial estadoReferencial = new EstadoReferencial();
    private TiposDocumentacionPreguntas tiposDocumentacionPreguntas=new TiposDocumentacionPreguntas();
    private boolean preguntaCerrada=false;
    private List<DocumentacionRespuestas> documentacionRespuestasList=null;
    public int getCodPregunta() {
        return codPregunta;
    }
    public int getCantidadRespuestas()
    {
        return this.documentacionRespuestasList.size();
    }

    public void setCodPregunta(int codPregunta) {
        this.codPregunta = codPregunta;
    }

    public String getDescripcionPregunta() {
        return descripcionPregunta;
    }

    public void setDescripcionPregunta(String descripcionPregunta) {
        this.descripcionPregunta = descripcionPregunta;
    }

    public Documentacion getDocumentacion() {
        return documentacion;
    }

    public void setDocumentacion(Documentacion documentacion) {
        this.documentacion = documentacion;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public int getNroPregunta() {
        return nroPregunta;
    }

    public void setNroPregunta(int nroPregunta) {
        this.nroPregunta = nroPregunta;
    }

    public TiposDocumentacionPreguntas getTiposDocumentacionPreguntas() {
        return tiposDocumentacionPreguntas;
    }

    public void setTiposDocumentacionPreguntas(TiposDocumentacionPreguntas tiposDocumentacionPreguntas) {
        this.tiposDocumentacionPreguntas = tiposDocumentacionPreguntas;
    }

    public boolean isPreguntaCerrada() {
        return preguntaCerrada;
    }

    public void setPreguntaCerrada(boolean preguntaCerrada) {
        this.preguntaCerrada = preguntaCerrada;
    }

    public List<DocumentacionRespuestas> getDocumentacionRespuestasList() {
        return documentacionRespuestasList;
    }

    public void setDocumentacionRespuestasList(List<DocumentacionRespuestas> documentacionRespuestasList) {
        this.documentacionRespuestasList = documentacionRespuestasList;
    }
    
    

}
