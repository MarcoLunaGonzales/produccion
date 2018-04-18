/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author rodrigo
 */
public class ColoresPresentacion {
    
    /** Creates a new instance of LineaMKT */
    
    private String codColor="";
    private String nombreColor="";
    private String obsColor="";
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial();

    public String getCodColor() {
        return codColor;
    }

    public void setCodColor(String codColor) {
        this.codColor = codColor;
    }

    public String getNombreColor() {
        return nombreColor;
    }

    public void setNombreColor(String nombreColor) {
        this.nombreColor = nombreColor;
    }

    public String getObsColor() {
        return obsColor;
    }

    public void setObsColor(String obsColor) {
        this.obsColor = obsColor;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

 
}
