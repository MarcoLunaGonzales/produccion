/*
 * EnvasesSecundarios.java
 *
 * Created on 18 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Osmar Hinojosa Miranda
 * @company COFAR
 */
public class EnvasesTerciarios extends AbstractBean{
    
    /** Creates a new instance of TiposMercaderia */
    private String codEnvaseTerciario="";
    private String nombreEnvaseTerciario="";
    private String obsEnvaseTerciario="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    
    public EnvasesTerciarios() {        
    }

    public String getCodEnvaseTerciario() {
        return codEnvaseTerciario;
    }

    public void setCodEnvaseTerciario(String codEnvaseTerciario) {
        this.codEnvaseTerciario = codEnvaseTerciario;
    }

    public String getNombreEnvaseTerciario() {
        return nombreEnvaseTerciario;
    }

    public void setNombreEnvaseTerciario(String nombreEnvaseTerciario) {
        this.nombreEnvaseTerciario = nombreEnvaseTerciario;
    }

    public String getObsEnvaseTerciario() {
        return obsEnvaseTerciario;
    }

    public void setObsEnvaseTerciario(String obsEnvaseTerciario) {
        this.obsEnvaseTerciario = obsEnvaseTerciario;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
   
}
