/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class MantenimientoPlanificado extends AbstractBean
{
    private int codMantenimientoPlanificado=0;
    private ProtocoloMantenimientoVersion protocoloMantenimientoVersion=new ProtocoloMantenimientoVersion();
    private Date fechaMantenimiento=new Date();

    public MantenimientoPlanificado() {
    }

    public int getCodMantenimientoPlanificado() {
        return codMantenimientoPlanificado;
    }

    public void setCodMantenimientoPlanificado(int codMantenimientoPlanificado) {
        this.codMantenimientoPlanificado = codMantenimientoPlanificado;
    }

    public ProtocoloMantenimientoVersion getProtocoloMantenimientoVersion() {
        return protocoloMantenimientoVersion;
    }

    public void setProtocoloMantenimientoVersion(ProtocoloMantenimientoVersion protocoloMantenimientoVersion) {
        this.protocoloMantenimientoVersion = protocoloMantenimientoVersion;
    }

    public Date getFechaMantenimiento() {
        return fechaMantenimiento;
    }

    public void setFechaMantenimiento(Date fechaMantenimiento) {
        this.fechaMantenimiento = fechaMantenimiento;
    }
    
    
}
