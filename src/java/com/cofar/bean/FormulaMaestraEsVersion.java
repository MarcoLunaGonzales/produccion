/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import com.cofar.web.ManagedBean;
import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class FormulaMaestraEsVersion extends ManagedBean implements Cloneable
{
    private ComponentesProdVersion componentesProdVersion=new ComponentesProdVersion();
    private int codFormulaMaestraEsVersion=0;
    private int nroVersion=0;
    private Personal personal=new Personal();
    private Date fechaCreacion=new Date();
    private Date fechaAprobacion=new Date();
    private Date fechaEnvioAprobacion=new Date();
    private String observacion="";
    private EstadosVersionComponentesProd estadosVersionComponentesProd=new EstadosVersionComponentesProd();

    public FormulaMaestraEsVersion() {
    }

    public int getCodFormulaMaestraEsVersion() {
        return codFormulaMaestraEsVersion;
    }

    public void setCodFormulaMaestraEsVersion(int codFormulaMaestraEsVersion) {
        this.codFormulaMaestraEsVersion = codFormulaMaestraEsVersion;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public Date getFechaAprobacion() {
        return fechaAprobacion;
    }

    public void setFechaAprobacion(Date fechaAprobacion) {
        this.fechaAprobacion = fechaAprobacion;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }

    public Date getFechaEnvioAprobacion() {
        return fechaEnvioAprobacion;
    }

    public void setFechaEnvioAprobacion(Date fechaEnvioAprobacion) {
        this.fechaEnvioAprobacion = fechaEnvioAprobacion;
    }

    public EstadosVersionComponentesProd getEstadosVersionComponentesProd() {
        return estadosVersionComponentesProd;
    }

    public void setEstadosVersionComponentesProd(EstadosVersionComponentesProd estadosVersionComponentesProd) {
        this.estadosVersionComponentesProd = estadosVersionComponentesProd;
    }

    public int getNroVersion() {
        return nroVersion;
    }

    public void setNroVersion(int nroVersion) {
        this.nroVersion = nroVersion;
    }
    
    public Object clone()
    {
        Object obj=null;
        try
        {
            obj=super.clone();
        }
        catch(CloneNotSupportedException ex)
        {
            ex.printStackTrace();
            System.out.println("no se puede clonar");
        }
        
        return obj;
    }
    
}
