/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author sistemas1
 */
public class FrecuenciasMantenimientoMaquina extends AbstractBean {
    int codFrecuencia = 0;
    Maquinaria maquinaria = new Maquinaria();
    TiposMantenimientoFrecuencia tiposMantenimientoFrecuencia = new TiposMantenimientoFrecuencia();
    float horasFrecuencia = 0f;
    float horasDuracionMantenimiento = 0;

    public int getCodFrecuencia() {
        return codFrecuencia;
    }

    public void setCodFrecuencia(int codFrecuencia) {
        this.codFrecuencia = codFrecuencia;
    }

    public float getHorasFrecuencia() {
        return horasFrecuencia;
    }

    public void setHorasFrecuencia(float horasFrecuencia) {
        this.horasFrecuencia = horasFrecuencia;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public TiposMantenimientoFrecuencia getTiposMantenimientoFrecuencia() {
        return tiposMantenimientoFrecuencia;
    }

    public void setTiposMantenimientoFrecuencia(TiposMantenimientoFrecuencia tiposMantenimientoFrecuencia) {
        this.tiposMantenimientoFrecuencia = tiposMantenimientoFrecuencia;
    }

    public float getHorasDuracionMantenimiento() {
        return horasDuracionMantenimiento;
    }

    public void setHorasDuracionMantenimiento(float horasDuracionMantenimiento) {
        this.horasDuracionMantenimiento = horasDuracionMantenimiento;
    }
    
}
