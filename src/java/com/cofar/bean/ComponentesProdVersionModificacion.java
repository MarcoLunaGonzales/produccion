/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ-
 */
public class ComponentesProdVersionModificacion extends AbstractBean{
    private ComponentesProdVersion componentesProdVersion = new ComponentesProdVersion();
    private Personal personal=new Personal();
    private EstadosVersionComponentesProd estadosVersionComponentesProd=new EstadosVersionComponentesProd();
    private Date fechaInclusionVersion=null;
    private Date fechaEnvioAprobacion=null;
    private Date fechaDevolucionVersion=null;
    private String observacionPersonalVersion="";
    private Date fechaAsignacion = null; 
    private TiposPermisosEspecialesAtlas tiposPermisosEspecialesAtlas = new TiposPermisosEspecialesAtlas();
    public EstadosVersionComponentesProd getEstadosVersionComponentesProd() {
        return estadosVersionComponentesProd;
    }

    public void setEstadosVersionComponentesProd(EstadosVersionComponentesProd estadosVersionComponentesProd) {
        this.estadosVersionComponentesProd = estadosVersionComponentesProd;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public ComponentesProdVersionModificacion() {
    }

    public Date getFechaDevolucionVersion() {
        return fechaDevolucionVersion;
    }

    public void setFechaDevolucionVersion(Date fechaDevolucionVersion) {
        this.fechaDevolucionVersion = fechaDevolucionVersion;
    }

    public Date getFechaEnvioAprobacion() {
        return fechaEnvioAprobacion;
    }

    public void setFechaEnvioAprobacion(Date fechaEnvioAprobacion) {
        this.fechaEnvioAprobacion = fechaEnvioAprobacion;
    }

    public Date getFechaInclusionVersion() {
        return fechaInclusionVersion;
    }

    public void setFechaInclusionVersion(Date fechaInclusionVersion) {
        this.fechaInclusionVersion = fechaInclusionVersion;
    }

    public String getObservacionPersonalVersion() {
        return observacionPersonalVersion;
    }

    public void setObservacionPersonalVersion(String observacionPersonalVersion) {
        this.observacionPersonalVersion = observacionPersonalVersion;
    }

    public Date getFechaAsignacion() {
        return fechaAsignacion;
    }

    public void setFechaAsignacion(Date fechaAsignacion) {
        this.fechaAsignacion = fechaAsignacion;
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }

    public TiposPermisosEspecialesAtlas getTiposPermisosEspecialesAtlas() {
        return tiposPermisosEspecialesAtlas;
    }

    public void setTiposPermisosEspecialesAtlas(TiposPermisosEspecialesAtlas tiposPermisosEspecialesAtlas) {
        this.tiposPermisosEspecialesAtlas = tiposPermisosEspecialesAtlas;
    }
    
    
    
}
