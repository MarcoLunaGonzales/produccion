/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author aquispe
 */
public class SeguimientoPreparadoLote extends AbstractBean{

    private ProgramaProduccion programaProduccion=new ProgramaProduccion();
    private Personal personalResponsable=new Personal();
    private Date fechaRegistro=new Date();

    public SeguimientoPreparadoLote() {
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Personal getPersonalResponsable() {
        return personalResponsable;
    }

    public void setPersonalResponsable(Personal personalResponsable) {
        this.personalResponsable = personalResponsable;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }
    


}
