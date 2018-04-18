/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class EstadosResultadoAnalisis extends AbstractBean{
    private int codEstadoResultadoAnalisis=0;
    private String nombreEstadoResultadoAnalisis="";

    public EstadosResultadoAnalisis() {
    }

    public int getCodEstadoResultadoAnalisis() {
        return codEstadoResultadoAnalisis;
    }

    public void setCodEstadoResultadoAnalisis(int codEstadoResultadoAnalisis) {
        this.codEstadoResultadoAnalisis = codEstadoResultadoAnalisis;
    }

    public String getNombreEstadoResultadoAnalisis() {
        return nombreEstadoResultadoAnalisis;
    }

    public void setNombreEstadoResultadoAnalisis(String nombreEstadoResultadoAnalisis) {
        this.nombreEstadoResultadoAnalisis = nombreEstadoResultadoAnalisis;
    }


}
