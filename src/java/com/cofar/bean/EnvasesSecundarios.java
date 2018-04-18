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
public class EnvasesSecundarios extends AbstractBean{
    
    /** Creates a new instance of TiposMercaderia */
    private String codEnvaseSec="";
    private String nombreEnvaseSec="";
    private String obsEnvaseSec="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    
    public EnvasesSecundarios() {        
    }
    public String getCodEnvaseSec() {
        return codEnvaseSec;
    }
    public void setCodEnvaseSec(String codEnvaseSec) {
        this.codEnvaseSec = codEnvaseSec;
    }
    public String getNombreEnvaseSec() {
        return nombreEnvaseSec;
    }
    public void setNombreEnvaseSec(String nombreEnvaseSec) {
        this.nombreEnvaseSec = nombreEnvaseSec;
    }
    public String getObsEnvaseSec() {
        return obsEnvaseSec;
    }
    public void setObsEnvaseSec(String obsEnvaseSec) {
        this.obsEnvaseSec = obsEnvaseSec;
    }
    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }
    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    } 
}
