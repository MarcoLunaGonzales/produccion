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
public class EstadosProtocoloMantenimientoVersion extends AbstractBean
{
    private int codEstadoProtocoloMantenimientoVersion =0;
    private String nombreEstadoProtocoloMantenimientoVersion="";

    public EstadosProtocoloMantenimientoVersion() {
    }

    public int getCodEstadoProtocoloMantenimientoVersion() {
        return codEstadoProtocoloMantenimientoVersion;
    }

    public void setCodEstadoProtocoloMantenimientoVersion(int codEstadoProtocoloMantenimientoVersion) {
        this.codEstadoProtocoloMantenimientoVersion = codEstadoProtocoloMantenimientoVersion;
    }

    public String getNombreEstadoProtocoloMantenimientoVersion() {
        return nombreEstadoProtocoloMantenimientoVersion;
    }

    public void setNombreEstadoProtocoloMantenimientoVersion(String nombreEstadoProtocoloMantenimientoVersion) {
        this.nombreEstadoProtocoloMantenimientoVersion = nombreEstadoProtocoloMantenimientoVersion;
    }
    
    
}
