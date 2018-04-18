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
 * @author Wilson Choquehuanca
 */
public class ParosInesperadosProd {
    
    /** Creates a new instance of LineaMKT */
    
    private String codParo="";
    private String nombreParo="";
    private String obsParo="";
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial();

    public String getCodParo() {
        return codParo;
    }

    public void setCodParo(String codParo) {
        this.codParo = codParo;
    }

    public String getNombreParo() {
        return nombreParo;
    }

    public void setNombreParo(String nombreParo) {
        this.nombreParo = nombreParo;
    }

    public String getObsParo() {
        return obsParo;
    }

    public void setObsParo(String obsParo) {
        this.obsParo = obsParo;
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
