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
public class AccionesTerapeuticas {
    
    /** Creates a new instance of LineaMKT */
    private String codAccionTerapeutica="";
    private String nombreAccionTerapeutica="";
    private String obsAccionTerapeutica="";    
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    
    public AccionesTerapeuticas() {
    }

    public String getCodAccionTerapeutica() {
        return codAccionTerapeutica;
    }

    public void setCodAccionTerapeutica(String codAccionTerapeutica) {
        this.codAccionTerapeutica = codAccionTerapeutica;
    }

    public String getNombreAccionTerapeutica() {
        return nombreAccionTerapeutica;
    }

    public void setNombreAccionTerapeutica(String nombreAccionTerapeutica) {
        this.nombreAccionTerapeutica = nombreAccionTerapeutica;
    }

    public String getObsAccionTerapeutica() {
        return obsAccionTerapeutica;
    }

    public void setObsAccionTerapeutica(String obsAccionTerapeutica) {
        this.obsAccionTerapeutica = obsAccionTerapeutica;
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
