/*
 * Personal.java
 *
 * Created on 6 de marzo de 2008, 11:15
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Gabriela Quelali Siñani
 * @company COFAR
 */
public class EnvasesPrimarios extends AbstractBean{
    /** Creates a new instance of EnvasesPrimarios */
    private String codEnvasePrim="";
    private String nombreEnvasePrim="";
    private String obsEnvasePrim="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    

    public EnvasesPrimarios() {
        
    }

    public String getCodEnvasePrim() {
        return codEnvasePrim;
    }

    public void setCodEnvasePrim(String codEnvasePrim) {
        this.codEnvasePrim = codEnvasePrim;
    }

    public String getNombreEnvasePrim() {
        return nombreEnvasePrim;
    }

    public void setNombreEnvasePrim(String nombreEnvasePrim) {
        this.nombreEnvasePrim = nombreEnvasePrim;
    }

    public String getObsEnvasePrim() {
        return obsEnvasePrim;
    }

    public void setObsEnvasePrim(String obsEnvasePrim) {
        this.obsEnvasePrim = obsEnvasePrim;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
   
    
}
