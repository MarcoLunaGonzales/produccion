/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;

/**
 *
 *  @author Rene Ergueta Illanes
 *  @company COFAR
 */
public class Territorio {
    
    /** Creates a new instance of Territorio */
    private String codTerritorio="";
    private String nombreTerritorio="";
    private String obsTerritorio="";
    private String codEstadoRegistro="";
    private String nombreEstadoRegistro="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial();
    
    private Boolean checked=new Boolean(false);
    public Territorio() {
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
    
    public String getObsTerritorio() {
        return obsTerritorio;
    }
    
    public void setObsTerritorio(String obsTerritorio) {
        this.obsTerritorio = obsTerritorio;
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
    
    public String getNombreEstadoRegistro() {
        return nombreEstadoRegistro;
    }
    
    public void setNombreEstadoRegistro(String nombreEstadoRegistro) {
        this.nombreEstadoRegistro = nombreEstadoRegistro;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
    
}
