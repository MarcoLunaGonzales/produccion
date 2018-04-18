/*
 * EstadoProducto.java
 *
 * Created on 18 de marzo de 2008, 05:31 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Rene Ergueta Illanes
 * @company COFAR
 */
public class EstadoProducto {
    
    /** Creates a new instance of EstadoProducto */
    private String codEstadoProducto="";
    private String nombreEstadoProducto="";
    private String obsEstadoProducto="";
    private String codEstadoRegistro="";
    private String nombreEstadoRegistro="";
    private Boolean checked =new Boolean(false);  
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    public EstadoProducto() {
    }

    public String getCodEstadoProducto() {
        return codEstadoProducto;
    }

    public void setCodEstadoProducto(String codEstadoProducto) {
        this.codEstadoProducto = codEstadoProducto;
    }

    public String getNombreEstadoProducto() {
        return nombreEstadoProducto;
    }

    public void setNombreEstadoProducto(String nombreEstadoProducto) {
        this.nombreEstadoProducto = nombreEstadoProducto;
    }

    public String getObsEstadoProducto() {
        return obsEstadoProducto;
    }

    public void setObsEstadoProducto(String obsEstadoProducto) {
        this.obsEstadoProducto = obsEstadoProducto;
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
