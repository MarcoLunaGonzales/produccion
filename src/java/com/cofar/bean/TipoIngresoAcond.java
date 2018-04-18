/*
 * TipoIngresoAcond.java
 *
 * Created on 19 de marzo de 2008, 10:02 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 *  @author Rene Ergueta Illanes
 *  @company COFAR
 */
public class TipoIngresoAcond {
    
    /** Creates a new instance of TipoIngresoAcond */
    private String codTipoIngresoAcond="";
    private String nombreTipoIngresoAcond="";
    private String obsTipoIngresoAcond="";
    private String codEstadoRegistro="";
    private String nombreEstadoRegistro="";
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    
    public TipoIngresoAcond() {
    }

    public String getCodTipoIngresoAcond() {
        return codTipoIngresoAcond;
    }

    public void setCodTipoIngresoAcond(String codTipoIngresoAcond) {
        this.codTipoIngresoAcond = codTipoIngresoAcond;
    }

    public String getNombreTipoIngresoAcond() {
        return nombreTipoIngresoAcond;
    }

    public void setNombreTipoIngresoAcond(String nombreTipoIngresoAcond) {
        this.nombreTipoIngresoAcond = nombreTipoIngresoAcond;
    }

    public String getObsTipoIngresoAcond() {
        return obsTipoIngresoAcond;
    }

    public void setObsTipoIngresoAcond(String obsTipoIngresoAcond) {
        this.obsTipoIngresoAcond = obsTipoIngresoAcond;
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

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
    
}
