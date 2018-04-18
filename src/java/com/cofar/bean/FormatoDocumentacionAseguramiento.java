/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class FormatoDocumentacionAseguramiento extends AbstractBean
{
    private int codFormatoDocumentacionAseguramiento=0;
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private TiposFormatoDocumentacionAseguramiento tiposFormatoDocumentacionAseguramiento=new TiposFormatoDocumentacionAseguramiento();
    private EstadosFormatoDocumentacionAseguramiento estadosFormatoDocumentacionAseguramiento=new EstadosFormatoDocumentacionAseguramiento();
    private String tituloDocumento="";
    private int nroRevision=0;
    private Date fechaInicioVigencia=new Date();

    public FormatoDocumentacionAseguramiento() {
    }

    public int getCodFormatoDocumentacionAseguramiento() {
        return codFormatoDocumentacionAseguramiento;
    }

    public void setCodFormatoDocumentacionAseguramiento(int codFormatoDocumentacionAseguramiento) {
        this.codFormatoDocumentacionAseguramiento = codFormatoDocumentacionAseguramiento;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public TiposFormatoDocumentacionAseguramiento getTiposFormatoDocumentacionAseguramiento() {
        return tiposFormatoDocumentacionAseguramiento;
    }

    public void setTiposFormatoDocumentacionAseguramiento(TiposFormatoDocumentacionAseguramiento tiposFormatoDocumentacionAseguramiento) {
        this.tiposFormatoDocumentacionAseguramiento = tiposFormatoDocumentacionAseguramiento;
    }

    public EstadosFormatoDocumentacionAseguramiento getEstadosFormatoDocumentacionAseguramiento() {
        return estadosFormatoDocumentacionAseguramiento;
    }

    public void setEstadosFormatoDocumentacionAseguramiento(EstadosFormatoDocumentacionAseguramiento estadosFormatoDocumentacionAseguramiento) {
        this.estadosFormatoDocumentacionAseguramiento = estadosFormatoDocumentacionAseguramiento;
    }

    public String getTituloDocumento() {
        return tituloDocumento;
    }

    public void setTituloDocumento(String tituloDocumento) {
        this.tituloDocumento = tituloDocumento;
    }

    public int getNroRevision() {
        return nroRevision;
    }

    public void setNroRevision(int nroRevision) {
        this.nroRevision = nroRevision;
    }

    public Date getFechaInicioVigencia() {
        return fechaInicioVigencia;
    }

    public void setFechaInicioVigencia(Date fechaInicioVigencia) {
        this.fechaInicioVigencia = fechaInicioVigencia;
    }
    
    
}
