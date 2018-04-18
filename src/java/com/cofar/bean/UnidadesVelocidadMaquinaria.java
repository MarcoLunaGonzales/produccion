/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class UnidadesVelocidadMaquinaria {
    int codUnidadVelocidad = 0;
    String nombreUnidadVelocidad = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodUnidadVelocidad() {
        return codUnidadVelocidad;
    }

    public void setCodUnidadVelocidad(int codUnidadVelocidad) {
        this.codUnidadVelocidad = codUnidadVelocidad;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public String getNombreUnidadVelocidad() {
        return nombreUnidadVelocidad;
    }

    public void setNombreUnidadVelocidad(String nombreUnidadVelocidad) {
        this.nombreUnidadVelocidad = nombreUnidadVelocidad;
    }

}
