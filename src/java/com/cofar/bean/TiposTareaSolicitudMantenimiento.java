/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class TiposTareaSolicitudMantenimiento {
    int codTareaSolicitudMantenimiento = 0;
    String nombreTareaSolicitudMantenimiento = "";
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    public int getCodTareaSolicitudMantenimiento() {
        return codTareaSolicitudMantenimiento;
    }

    public void setCodTareaSolicitudMantenimiento(int codTareaSolicitudMantenimiento) {
        this.codTareaSolicitudMantenimiento = codTareaSolicitudMantenimiento;
    }

    public String getNombreTareaSolicitudMantenimiento() {
        return nombreTareaSolicitudMantenimiento;
    }

    public void setNombreTareaSolicitudMantenimiento(String nombreTareaSolicitudMantenimiento) {
        this.nombreTareaSolicitudMantenimiento = nombreTareaSolicitudMantenimiento;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

}
