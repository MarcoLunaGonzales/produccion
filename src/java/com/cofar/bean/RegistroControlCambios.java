/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author DASISAQ-
 */
public class RegistroControlCambios extends AbstractBean{
    private int codRegistroControlCambios=0;
    private ComponentesProdVersion componentesProd=new ComponentesProdVersion();
    private FormulaMaestraVersion formulaMaestraVersion=new FormulaMaestraVersion();
    private Personal personalRegistra=new Personal();
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private String cambioPropuesto="";
    private String coorelativo="";
    private String propositoCambio="";
    private String clasificacionCambio="";
    private boolean ameritaCambio=false;
    private boolean cambioDefinitivo=false;
    private Date fechaRegistro=new Date();
    //para varios registros de personal
    private List<RegistroControlCambiosProposito> registroControlCambiosPropositoList=null;
    public RegistroControlCambios() {
    }

    public boolean isAmeritaCambio() {
        return ameritaCambio;
    }

    public void setAmeritaCambio(boolean ameritaCambio) {
        this.ameritaCambio = ameritaCambio;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public String getCambioPropuesto() {
        return cambioPropuesto;
    }

    public void setCambioPropuesto(String cambioPropuesto) {
        this.cambioPropuesto = cambioPropuesto;
    }

    public boolean isCambioDefinitivo() {
        return cambioDefinitivo;
    }

    public void setCambioDefinitivo(boolean cambioDefinitivo) {
        this.cambioDefinitivo = cambioDefinitivo;
    }

    

    
    public int getCodRegistroControlCambios() {
        return codRegistroControlCambios;
    }

    public void setCodRegistroControlCambios(int codRegistroControlCambios) {
        this.codRegistroControlCambios = codRegistroControlCambios;
    }

    public ComponentesProdVersion getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProdVersion componentesProd) {
        this.componentesProd = componentesProd;
    }

   

    public String getCoorelativo() {
        return coorelativo;
    }

    public void setCoorelativo(String coorelativo) {
        this.coorelativo = coorelativo;
    }

    public FormulaMaestraVersion getFormulaMaestraVersion() {
        return formulaMaestraVersion;
    }

    public void setFormulaMaestraVersion(FormulaMaestraVersion formulaMaestraVersion) {
        this.formulaMaestraVersion = formulaMaestraVersion;
    }

    public Personal getPersonalRegistra() {
        return personalRegistra;
    }

    public void setPersonalRegistra(Personal personalRegistra) {
        this.personalRegistra = personalRegistra;
    }

    public String getPropositoCambio() {
        return propositoCambio;
    }

    public void setPropositoCambio(String propositoCambio) {
        this.propositoCambio = propositoCambio;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getClasificacionCambio() {
        return clasificacionCambio;
    }

    public void setClasificacionCambio(String clasificacionCambio) {
        this.clasificacionCambio = clasificacionCambio;
    }

    public List<RegistroControlCambiosProposito> getRegistroControlCambiosPropositoList() {
        return registroControlCambiosPropositoList;
    }

    public void setRegistroControlCambiosPropositoList(List<RegistroControlCambiosProposito> registroControlCambiosPropositoList) {
        this.registroControlCambiosPropositoList = registroControlCambiosPropositoList;
    }

    
    
}
