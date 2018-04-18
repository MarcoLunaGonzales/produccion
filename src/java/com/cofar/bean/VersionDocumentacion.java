/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author aquispe
 */
public class VersionDocumentacion extends AbstractBean{
    private int nroVersion=0;
    private Date fechaCargado=new Date();
    private Date fechaElaboracion=new Date();
    private Date fechaIngresoVigencia=new Date();
    private Date fechaProximaRevision=new Date();
    private Personal personalElabora=new Personal();
    private EstadosDocumento estadosDocumento=new EstadosDocumento();
    private String urlDocumento="";

    public VersionDocumentacion() {
    }

    public EstadosDocumento getEstadosDocumento() {
        return estadosDocumento;
    }

    public void setEstadosDocumento(EstadosDocumento estadosDocumento) {
        this.estadosDocumento = estadosDocumento;
    }

    public Date getFechaCargado() {
        return fechaCargado;
    }

    public void setFechaCargado(Date fechaCargado) {
        this.fechaCargado = fechaCargado;
    }

    public Date getFechaElaboracion() {
        return fechaElaboracion;
    }

    public void setFechaElaboracion(Date fechaElaboracion) {
        this.fechaElaboracion = fechaElaboracion;
    }

    public Date getFechaIngresoVigencia() {
        return fechaIngresoVigencia;
    }

    public void setFechaIngresoVigencia(Date fechaIngresoVigencia) {
        this.fechaIngresoVigencia = fechaIngresoVigencia;
    }

    public Date getFechaProximaRevision() {
        return fechaProximaRevision;
    }

    public void setFechaProximaRevision(Date fechaProximaRevision) {
        this.fechaProximaRevision = fechaProximaRevision;
    }

    public int getNroVersion() {
        return nroVersion;
    }

    public void setNroVersion(int nroVersion) {
        this.nroVersion = nroVersion;
    }

    public Personal getPersonalElabora() {
        return personalElabora;
    }

    public void setPersonalElabora(Personal personalElabora) {
        this.personalElabora = personalElabora;
    }

    public String getUrlDocumento() {
        return urlDocumento;
    }

    public void setUrlDocumento(String urlDocumento) {
        this.urlDocumento = urlDocumento;
    }

    


}
