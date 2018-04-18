/*
 * Distrito.java
 *
 * Created on 28 de febrero de 2008, 10:56 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Rene Ergueta Illanes
 * @company COFAR
 */
public class Distrito {
    
    /** Creates a new instance of Distrito */
    private String codDistrito="";
    private String codTerritorio="";
    private String nombreDistrito="";
    private String obsDistrito="";
    private String codEstadoRegistro="";
    private String nombreTerritorio="";
    private String nombreEstadoRegistro="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private Territorio territorio=new Territorio();
    private Boolean checked=new Boolean(false);    
    private List zonaList=new ArrayList();
    private Zona zona=new Zona();
    public Distrito() {
    }
    
    public String getCodDistrito() {
        return codDistrito;
    }
    
    public void setCodDistrito(String codDistrito) {
        this.codDistrito = codDistrito;
    }
    
    public String getNombreDistrito() {
        return nombreDistrito;
    }
    
    public void setNombreDistrito(String nombreDistrito) {
        this.nombreDistrito = nombreDistrito;
    }
    
    public String getObsDistrito() {
        return obsDistrito;
    }
    
    public void setObsDistrito(String obsDistrito) {
        this.obsDistrito = obsDistrito;
    }
    
    public String getCodEstadoRegistro() {
        return codEstadoRegistro;
    }
    
    public void setCodEstadoRegistro(String codEstadoRegistro) {
        this.codEstadoRegistro = codEstadoRegistro;
    }
    
    public Boolean getChecked() {
        return checked;
    }
    
    public void setChecked(Boolean checked) {
        this.checked = checked;
    }
    
    public String getCodTerritorio() {
        return codTerritorio;
    }
    
    public void setCodTerritorio(String codTerritorio) {
        this.codTerritorio = codTerritorio;
    }
    
    public String getNombreTerritorio() {
        return nombreTerritorio;
    }
    
    public void setNombreTerritorio(String nombreTerritorio) {
        this.nombreTerritorio = nombreTerritorio;
    }
    
    public String getNombreEstadoRegistro() {
        return nombreEstadoRegistro;
    }
    
    public void setNombreEstadoRegistro(String nombreEstadoRegistro) {
        this.nombreEstadoRegistro = nombreEstadoRegistro;
    }
    
    public Territorio getTerritorio() {
        return territorio;
    }
    
    public void setTerritorio(Territorio territorio) {
        this.territorio = territorio;
    }
    
    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public List getZonaList() {
        return zonaList;
    }

    public void setZonaList(List zonaList) {
        this.zonaList = zonaList;
    }

    public Zona getZona() {
        return zona;
    }

    public void setZona(Zona zona) {
        this.zona = zona;
    }
    
}
