/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */public class AreasFabricacion {
     
     /** Creates a new instance of TipoCliente */
     private AreasEmpresa areasEmpresa= new AreasEmpresa();
     private Boolean checked=new Boolean(false);
     private EstadoReferencial estadoReferencial=new EstadoReferencial();
     private boolean swSi;
     private boolean swNo;

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
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

    public boolean isSwSi() {
        return swSi;
    }

    public void setSwSi(boolean swSi) {
        this.swSi = swSi;
    }

    public boolean isSwNo() {
        return swNo;
    }

    public void setSwNo(boolean swNo) {
        this.swNo = swNo;
    }
  
     
 }
