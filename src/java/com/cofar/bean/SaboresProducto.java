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
public class SaboresProducto {
    
    /** Creates a new instance of LineaMKT */
    
    private String codSabor="";
    private String nombreSabor="";
    private String obsSabor="";
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial();

    public String getCodSabor() {
        return codSabor;
    }

    public void setCodSabor(String codSabor) {
        this.codSabor = codSabor;
    }

    public String getNombreSabor() {
        return nombreSabor;
    }

    public void setNombreSabor(String nombreSabor) {
        this.nombreSabor = nombreSabor;
    }

    public String getObsSabor() {
        return obsSabor;
    }

    public void setObsSabor(String obsSabor) {
        this.obsSabor = obsSabor;
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
