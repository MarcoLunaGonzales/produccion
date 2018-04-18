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
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class EstadoCompProd  extends AbstractBean{
    
    /** Creates a new instance of EstadoProducto */
    private int codEstadoCompProd=0;
    private String nombreEstadoCompProd="";
    private String obsEstadoCompProd="";
    private Boolean checked =new Boolean(false);  
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    public EstadoCompProd() {
    }

    public int getCodEstadoCompProd() {
        return codEstadoCompProd;
    }

    public void setCodEstadoCompProd(int codEstadoCompProd) {
        this.codEstadoCompProd = codEstadoCompProd;
    }

    public String getNombreEstadoCompProd() {
        return nombreEstadoCompProd;
    }

    public void setNombreEstadoCompProd(String nombreEstadoCompProd) {
        this.nombreEstadoCompProd = nombreEstadoCompProd;
    }

    public String getObsEstadoCompProd() {
        return obsEstadoCompProd;
    }

    public void setObsEstadoCompProd(String obsEstadoCompProd) {
        this.obsEstadoCompProd = obsEstadoCompProd;
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
