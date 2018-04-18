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
public class CartonesCorrugados {
    
    /** Creates a new instance of LineaMKT */
    
    private String codCaton="";
    private String nombreCarton="";
    private String dimAlto="";
    private String dimLargo="";
    private String dimAncho="";
    private String pesoGramos="";
    private String obsCarton="";
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial();

    public String getCodCaton() {
        return codCaton;
    }

    public void setCodCaton(String codCaton) {
        this.codCaton = codCaton;
    }

    public String getNombreCarton() {
        return nombreCarton;
    }

    public void setNombreCarton(String nombreCarton) {
        this.nombreCarton = nombreCarton;
    }

    public String getDimAlto() {
        return dimAlto;
    }

    public void setDimAlto(String dimAlto) {
        this.dimAlto = dimAlto;
    }

    public String getDimLargo() {
        return dimLargo;
    }

    public void setDimLargo(String dimLargo) {
        this.dimLargo = dimLargo;
    }

    public String getDimAncho() {
        return dimAncho;
    }

    public void setDimAncho(String dimAncho) {
        this.dimAncho = dimAncho;
    }

    public String getPesoGramos() {
        return pesoGramos;
    }

    public void setPesoGramos(String pesoGramos) {
        this.pesoGramos = pesoGramos;
    }

    public String getObsCarton() {
        return obsCarton;
    }

    public void setObsCarton(String obsCarton) {
        this.obsCarton = obsCarton;
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
