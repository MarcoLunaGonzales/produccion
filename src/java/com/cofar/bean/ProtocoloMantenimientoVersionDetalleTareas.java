/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class ProtocoloMantenimientoVersionDetalleTareas extends AbstractBean
{
    private int codProtocoloMantenimientoVersionDetalleTareas=0;
    private TiposTarea tiposTarea=new TiposTarea();
    private String descripcionTarea="";
    private Double horasStandar=0d;
    private int nroTarea=0;

    public ProtocoloMantenimientoVersionDetalleTareas() {
    }
    

    public int getCodProtocoloMantenimientoVersionDetalleTareas() {
        return codProtocoloMantenimientoVersionDetalleTareas;
    }

    public void setCodProtocoloMantenimientoVersionDetalleTareas(int codProtocoloMantenimientoVersionDetalleTareas) {
        this.codProtocoloMantenimientoVersionDetalleTareas = codProtocoloMantenimientoVersionDetalleTareas;
    }

    public TiposTarea getTiposTarea() {
        return tiposTarea;
    }

    public void setTiposTarea(TiposTarea tiposTarea) {
        this.tiposTarea = tiposTarea;
    }

    public String getDescripcionTarea() {
        return descripcionTarea;
    }

    public void setDescripcionTarea(String descripcionTarea) {
        this.descripcionTarea = descripcionTarea;
    }

    public Double getHorasStandar() {
        return horasStandar;
    }

    public void setHorasStandar(Double horasStandar) {
        this.horasStandar = horasStandar;
    }

    

    public int getNroTarea() {
        return nroTarea;
    }

    public void setNroTarea(int nroTarea) {
        this.nroTarea = nroTarea;
    }
    
    
}
