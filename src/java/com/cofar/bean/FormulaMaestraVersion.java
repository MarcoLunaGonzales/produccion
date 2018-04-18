/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;


/**
 *
 * @author sistemas1
 */
public class FormulaMaestraVersion extends FormulaMaestra{
    
    private int codVersion =  0;
    private int nroVersion = 0;
    private Date fechaModificacion=new Date();
    private Date fechaInicioVigencia=new Date();
    private EstadosVersionFormulaMaestra estadoVersionFormulaMaestra=new EstadosVersionFormulaMaestra();
    private Personal personalCreacion=new Personal();
    //private TiposModificacionFormula tiposModificacionFormula=new TiposModificacionFormula();
    private List<FormulaMaestraVersionModificacion> formulaMaestraVersionModificacionList=null;
    private boolean modificacionNF=false;
    private boolean modificacionMPEP=false;
    private boolean modificacionES=false;
    private boolean modificacionR=false;
    //no inicializar la varible ya que causaria recursividad de crecacion
    private FormulaMaestraEsVersion formulaMaestraEsVersion=null;
    public int getCodVersion() {
        return codVersion;
    }

    public void setCodVersion(int codVersion) {
        this.codVersion = codVersion;
    }

    public int getNroVersion() {
        return nroVersion;
    }

    public void setNroVersion(int nroVersion) {
        this.nroVersion = nroVersion;
    }

    public Date getFechaModificacion() {
        return fechaModificacion;
    }

    public void setFechaModificacion(Date fechaModificacion) {
        this.fechaModificacion = fechaModificacion;
    }

    public Date getFechaInicioVigencia() {
        return fechaInicioVigencia;
    }

    public void setFechaInicioVigencia(Date fechaInicioVigencia) {
        this.fechaInicioVigencia = fechaInicioVigencia;
    }

    public EstadosVersionFormulaMaestra getEstadoVersionFormulaMaestra() {
        return estadoVersionFormulaMaestra;
    }

    public void setEstadoVersionFormulaMaestra(EstadosVersionFormulaMaestra estadoVersionFormulaMaestra) {
        this.estadoVersionFormulaMaestra = estadoVersionFormulaMaestra;
    }

    public Personal getPersonalCreacion() {
        return personalCreacion;
    }

    public void setPersonalCreacion(Personal personalCreacion) {
        this.personalCreacion = personalCreacion;
    }

    
    public List<FormulaMaestraVersionModificacion> getFormulaMaestraVersionModificacionList() {
        return formulaMaestraVersionModificacionList;
    }

    public void setFormulaMaestraVersionModificacionList(List<FormulaMaestraVersionModificacion> formulaMaestraVersionModificacionList) {
        this.formulaMaestraVersionModificacionList = formulaMaestraVersionModificacionList;
    }

    public int getFormulaMaestraVersionModificacionLength()
    {
        return (this.formulaMaestraVersionModificacionList==null?1:this.formulaMaestraVersionModificacionList.size());
    }

    public boolean isModificacionES() {
        return modificacionES;
    }

    public void setModificacionES(boolean modificacionES) {
        this.modificacionES = modificacionES;
    }

    public boolean isModificacionMPEP() {
        return modificacionMPEP;
    }

    public void setModificacionMPEP(boolean modificacionMPEP) {
        this.modificacionMPEP = modificacionMPEP;
    }

    public boolean isModificacionNF() {
        return modificacionNF;
    }

    public void setModificacionNF(boolean modificacionNF) {
        this.modificacionNF = modificacionNF;
    }

    public boolean isModificacionR() {
        return modificacionR;
    }

    public void setModificacionR(boolean modificacionR) {
        this.modificacionR = modificacionR;
    }

    public FormulaMaestraEsVersion getFormulaMaestraEsVersion() {
        return formulaMaestraEsVersion;
    }

    public void setFormulaMaestraEsVersion(FormulaMaestraEsVersion formulaMaestraEsVersion) {
        this.formulaMaestraEsVersion = formulaMaestraEsVersion;
    }
    
    
    
}
