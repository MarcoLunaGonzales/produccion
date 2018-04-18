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
public class AlmacenAcond {
    
    /** Creates a new instance of AlmacenAcond */
    private int codAlmacenAcond = 0;
    private String nombreAlmacenAcond="";
    private String obsAlmacenAcond="";
    private String codEstadoRegistro="";
    private String nombreEstadoRegistro="";
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    
    public AlmacenAcond() {
    }    

    

    public String getNombreAlmacenAcond() {
        return nombreAlmacenAcond;
    }

    public int getCodAlmacenAcond() {
        return codAlmacenAcond;
    }

    public void setCodAlmacenAcond(int codAlmacenAcond) {
        this.codAlmacenAcond = codAlmacenAcond;
    }

    public void setNombreAlmacenAcond(String nombreAlmacenAcond) {
        this.nombreAlmacenAcond = nombreAlmacenAcond;
    }

    public String getObsAlmacenAcond() {
        return obsAlmacenAcond;
    }

    public void setObsAlmacenAcond(String obsAlmacenAcond) {
        this.obsAlmacenAcond = obsAlmacenAcond;
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
