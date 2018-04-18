/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class EstadosPersonalAreaProduccion extends AbstractBean{
    private int codEstadoPersonalAreaProduccion=0;
    private String nombreEstadoPersonalAreaProduccion="";

    public EstadosPersonalAreaProduccion() {
    }

    public int getCodEstadoPersonalAreaProduccion() {
        return codEstadoPersonalAreaProduccion;
    }

    public void setCodEstadoPersonalAreaProduccion(int codEstadoPersonalAreaProduccion) {
        this.codEstadoPersonalAreaProduccion = codEstadoPersonalAreaProduccion;
    }

    public String getNombreEstadoPersonalAreaProduccion() {
        return nombreEstadoPersonalAreaProduccion;
    }

    public void setNombreEstadoPersonalAreaProduccion(String nombreEstadoPersonalAreaProduccion) {
        this.nombreEstadoPersonalAreaProduccion = nombreEstadoPersonalAreaProduccion;
    }
    

}
