/*
 * TiposEnvase.java
 *
 * Created on 19 de septiembre de 2008, 10:14
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Rene
 */
public class TiposEnvase {
    
    /** Creates a new instance of TiposEnvase */
    private String codTipoEnvase="";
    private String nombreTipoEnvase="";
    private String obsTipoEnvase="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial();
    public TiposEnvase() {
    }

    public String getCodTipoEnvase() {
        return codTipoEnvase;
    }

    public void setCodTipoEnvase(String codTipoEnvase) {
        this.codTipoEnvase = codTipoEnvase;
    }

    public String getNombreTipoEnvase() {
        return nombreTipoEnvase;
    }

    public void setNombreTipoEnvase(String nombreTipoEnvase) {
        this.nombreTipoEnvase = nombreTipoEnvase;
    }

    public String getObsTipoEnvase() {
        return obsTipoEnvase;
    }

    public void setObsTipoEnvase(String obsTipoEnvase) {
        this.obsTipoEnvase = obsTipoEnvase;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
    
}
