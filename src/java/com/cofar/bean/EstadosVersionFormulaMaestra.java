/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class EstadosVersionFormulaMaestra extends AbstractBean{
    private int codEstadoVersionFormulaMaestra=0;
    private String nombreEstadoVersionFormulaMaestra="";

    public EstadosVersionFormulaMaestra() {
    }

    public int getCodEstadoVersionFormulaMaestra() {
        return codEstadoVersionFormulaMaestra;
    }

    public void setCodEstadoVersionFormulaMaestra(int codEstadoVersionFormulaMaestra) {
        this.codEstadoVersionFormulaMaestra = codEstadoVersionFormulaMaestra;
    }

    public String getNombreEstadoVersionFormulaMaestra() {
        return nombreEstadoVersionFormulaMaestra;
    }

    public void setNombreEstadoVersionFormulaMaestra(String nombreEstadoVersionFormulaMaestra) {
        this.nombreEstadoVersionFormulaMaestra = nombreEstadoVersionFormulaMaestra;
    }
    

}
