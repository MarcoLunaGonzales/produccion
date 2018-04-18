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
public class MantenimientoMaquina extends AbstractBean{
    int codMantenimientoMaquina = 0;
    ProgramaProduccionPeriodo programaProduccionPeriodo= new ProgramaProduccionPeriodo();
    TiposMantenimiento tiposMantenimiento = new TiposMantenimiento();
    Maquinaria maquinaria = new Maquinaria();
    Date fechaRegistro= new Date();
    FrecuenciasMantenimientoMaquina frecuenciasMantenimientoMaquina = new FrecuenciasMantenimientoMaquina();

    public int getCodMantenimientoMaquina() {
        return codMantenimientoMaquina;
    }

    public void setCodMantenimientoMaquina(int codMantenimientoMaquina) {
        this.codMantenimientoMaquina = codMantenimientoMaquina;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public FrecuenciasMantenimientoMaquina getFrecuenciasMantenimientoMaquina() {
        return frecuenciasMantenimientoMaquina;
    }

    public void setFrecuenciasMantenimientoMaquina(FrecuenciasMantenimientoMaquina frecuenciasMantenimientoMaquina) {
        this.frecuenciasMantenimientoMaquina = frecuenciasMantenimientoMaquina;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }

    public TiposMantenimiento getTiposMantenimiento() {
        return tiposMantenimiento;
    }

    public void setTiposMantenimiento(TiposMantenimiento tiposMantenimiento) {
        this.tiposMantenimiento = tiposMantenimiento;
    }

    
}
