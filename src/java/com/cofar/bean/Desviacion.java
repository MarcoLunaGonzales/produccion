/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ-
 */
public class Desviacion extends AbstractBean{
    private int codDesviacion=0;
    private Date fechaDesviacion=new Date();
    private String descripcionDesviacion="";
    //para desviaciones de programa produccion
    private ProgramaProduccion programaProduccion;

    public int getCodDesviacion() {
        return codDesviacion;
    }

    public void setCodDesviacion(int codDesviacion) {
        this.codDesviacion = codDesviacion;
    }

    public Date getFechaDesviacion() {
        return fechaDesviacion;
    }

    public void setFechaDesviacion(Date fechaDesviacion) {
        this.fechaDesviacion = fechaDesviacion;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public String getDescripcionDesviacion() {
        return descripcionDesviacion;
    }

    public void setDescripcionDesviacion(String descripcionDesviacion) {
        this.descripcionDesviacion = descripcionDesviacion;
    }
    
    
}
