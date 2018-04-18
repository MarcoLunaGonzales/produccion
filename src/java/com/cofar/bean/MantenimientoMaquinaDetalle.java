/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author sistemas1
 */
public class MantenimientoMaquinaDetalle {
    MantenimientoMaquina mantenimientoMaquina = new MantenimientoMaquina();
    int codMantenimientoMaquinaDetalle = 0;
    Date fechaMantenimiento = new Date();
    float horasFrecuencia = 0;
    String observaciones = "";

    public int getCodMantenimientoMaquinaDetalle() {
        return codMantenimientoMaquinaDetalle;
    }

    public void setCodMantenimientoMaquinaDetalle(int codMantenimientoMaquinaDetalle) {
        this.codMantenimientoMaquinaDetalle = codMantenimientoMaquinaDetalle;
    }

    public Date getFechaMantenimiento() {
        return fechaMantenimiento;
    }

    public void setFechaMantenimiento(Date fechaMantenimiento) {
        this.fechaMantenimiento = fechaMantenimiento;
    }

    public float getHorasFrecuencia() {
        return horasFrecuencia;
    }

    public void setHorasFrecuencia(float horasFrecuencia) {
        this.horasFrecuencia = horasFrecuencia;
    }

    public MantenimientoMaquina getMantenimientoMaquina() {
        return mantenimientoMaquina;
    }

    public void setMantenimientoMaquina(MantenimientoMaquina mantenimientoMaquina) {
        this.mantenimientoMaquina = mantenimientoMaquina;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
    
}
