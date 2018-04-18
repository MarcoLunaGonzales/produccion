/*
 * Zona.java
 *
 * Created on 14 de marzo de 2008, 07:35 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author rodrigo
 */
public class Zona {
    
    /** Creates a new instance of Zona */
    private String codZona="";
    private String codDistrito="";
    private String nombreZona="";
    private String nombreDistrito="";
    private String obsZona="";
    private String codEstadoRegistro="";
    private String nombreEstadoRegistro="";
    private Boolean checked=new Boolean(false);
    
    public Zona() {
    }

    public String getCodZona() {
        return codZona;
    }

    public void setCodZona(String codZona) {
        this.codZona = codZona;
    }

    public String getCodDistrito() {
        return codDistrito;
    }

    public void setCodDistrito(String codDistrito) {
        this.codDistrito = codDistrito;
    }

    public String getNombreZona() {
        return nombreZona;
    }

    public void setNombreZona(String nombreZona) {
        this.nombreZona = nombreZona;
    }

    public String getNombreDistrito() {
        return nombreDistrito;
    }

    public void setNombreDistrito(String nombreDistrito) {
        this.nombreDistrito = nombreDistrito;
    }

    public String getObsZona() {
        return obsZona;
    }

    public void setObsZona(String obsZona) {
        this.obsZona = obsZona;
    }

    public String getCodEstadoRegistro() {
        return codEstadoRegistro;
    }

    public void setCodEstadoRegistro(String codEstadoRegistro) {
        this.codEstadoRegistro = codEstadoRegistro;
    }

    public String getNombreEstadoRegistro() {
        return nombreEstadoRegistro;
    }

    public void setNombreEstadoRegistro(String nombreEstadoRegistro) {
        this.nombreEstadoRegistro = nombreEstadoRegistro;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }
    
}
