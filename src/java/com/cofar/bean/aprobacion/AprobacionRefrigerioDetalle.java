/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.aprobacion;

import com.cofar.bean.AbstractBean;

/**
 *
 * @author Ismael Juchazara
 */
public class AprobacionRefrigerioDetalle extends AbstractBean {

    public int codigoAprobacion;
    public int codigoPersonal;
    public String nombre;
    public String cargo;
    public int base;
    public int aprobado;

    public AprobacionRefrigerioDetalle(int codigoAprobacion, int codigoPersonal, String nombre, String cargo, int base, int aprobado) {
        this.codigoAprobacion = codigoAprobacion;
        this.codigoPersonal = codigoPersonal;
        this.nombre = nombre;
        this.cargo = cargo;
        this.base = base;
        this.aprobado = aprobado;
    }

    public int getAprobado() {
        return aprobado;
    }

    public void setAprobado(int aprobado) {
        this.aprobado = aprobado;
    }

    public int getBase() {
        return base;
    }

    public void setBase(int base) {
        this.base = base;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public int getCodigoAprobacion() {
        return codigoAprobacion;
    }

    public void setCodigoAprobacion(int codigoAprobacion) {
        this.codigoAprobacion = codigoAprobacion;
    }

    public int getCodigoPersonal() {
        return codigoPersonal;
    }

    public void setCodigoPersonal(int codigoPersonal) {
        this.codigoPersonal = codigoPersonal;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}
