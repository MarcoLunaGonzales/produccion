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
public class LineaMKT {
    
    /** Creates a new instance of LineaMKT */
    private String codLineaMKT="";
    private String nombreLineaMKT="";
    private String obsLineaMKT="";    
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    
    public LineaMKT() {
    }

    public String getCodLineaMKT() {
        return codLineaMKT;
    }

    public void setCodLineaMKT(String codLineaMKT) {
        this.codLineaMKT = codLineaMKT;
    }

    public String getNombreLineaMKT() {
        return nombreLineaMKT;
    }

    public void setNombreLineaMKT(String nombreLineaMKT) {
        this.nombreLineaMKT = nombreLineaMKT;
    }

    public String getObsLineaMKT() {
        return obsLineaMKT;
    }

    public void setObsLineaMKT(String obsLineaMKT) {
        this.obsLineaMKT = obsLineaMKT;
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
