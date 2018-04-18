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
public class DesviacionProduccion extends AbstractBean
{
    private int codDesviacionProduccion=0;
    private FormatoDocumentacionAseguramiento formatoDocumentacionAseguramiento=new FormatoDocumentacionAseguramiento();
    private ProgramaProduccion programaProduccion=new ProgramaProduccion();
    private TiposDesviacionProduccion tiposDesviacionProduccion=new TiposDesviacionProduccion();
    private FuentesDesviacionProduccion fuentesDesviacionProduccion=new FuentesDesviacionProduccion();
    private Personal personal=new Personal();
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private Date fechaDeteccion=new Date();
    private Date fechaInforme=new Date();
    private String nroCorrelativo="";
    public DesviacionProduccion() {
        fechaDeteccion=new Date();
        fechaInforme=new Date();
    }

    public int getCodDesviacionProduccion() 
    {
        return codDesviacionProduccion;
    }

    public void setCodDesviacionProduccion(int codDesviacionProduccion) {
        this.codDesviacionProduccion = codDesviacionProduccion;
    }

    public FormatoDocumentacionAseguramiento getFormatoDocumentacionAseguramiento() {
        return formatoDocumentacionAseguramiento;
    }

    public void setFormatoDocumentacionAseguramiento(FormatoDocumentacionAseguramiento formatoDocumentacionAseguramiento) {
        this.formatoDocumentacionAseguramiento = formatoDocumentacionAseguramiento;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public TiposDesviacionProduccion getTiposDesviacionProduccion() {
        return tiposDesviacionProduccion;
    }

    public void setTiposDesviacionProduccion(TiposDesviacionProduccion tiposDesviacionProduccion) {
        this.tiposDesviacionProduccion = tiposDesviacionProduccion;
    }

    public FuentesDesviacionProduccion getFuentesDesviacionProduccion() {
        return fuentesDesviacionProduccion;
    }

    public void setFuentesDesviacionProduccion(FuentesDesviacionProduccion fuentesDesviacionProduccion) {
        this.fuentesDesviacionProduccion = fuentesDesviacionProduccion;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public Date getFechaDeteccion() {
        return fechaDeteccion;
    }

    public void setFechaDeteccion(Date fechaDeteccion) {
        this.fechaDeteccion = fechaDeteccion;
    }

    public Date getFechaInforme() {
        return fechaInforme;
    }

    public void setFechaInforme(Date fechaInforme) {
        this.fechaInforme = fechaInforme;
    }

    public String getNroCorrelativo() {
        return nroCorrelativo;
    }

    public void setNroCorrelativo(String nroCorrelativo) {
        this.nroCorrelativo = nroCorrelativo;
    }
    
    
    
    
}
