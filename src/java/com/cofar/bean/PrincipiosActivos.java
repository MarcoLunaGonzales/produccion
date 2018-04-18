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
public class PrincipiosActivos {
    
    /** Creates a new instance of LineaMKT */
    private String codPrincipioActivo="";
    private String nombrePrincipioActivo="";
    private String obsPrincipioActivo="";    
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    
    public PrincipiosActivos () {
    }

    public String getCodPrincipioActivo() {
        return codPrincipioActivo;
    }

    public void setCodPrincipioActivo(String codPrincipioActivo) {
        this.codPrincipioActivo = codPrincipioActivo;
    }

    public String getNombrePrincipioActivo() {
        return nombrePrincipioActivo;
    }

    public void setNombrePrincipioActivo(String nombrePrincipioActivo) {
        this.nombrePrincipioActivo = nombrePrincipioActivo;
    }

    public String getObsPrincipioActivo() {
        return obsPrincipioActivo;
    }

    public void setObsPrincipioActivo(String obsPrincipioActivo) {
        this.obsPrincipioActivo = obsPrincipioActivo;
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
