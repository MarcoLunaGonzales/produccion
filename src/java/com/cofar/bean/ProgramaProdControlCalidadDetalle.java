/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author USER
 */
public class ProgramaProdControlCalidadDetalle extends AbstractBean {
    ProgramaProduccionControlCalidadDetalle programaProduccionControlCalidadDetalle = new ProgramaProduccionControlCalidadDetalle();
    Materiales materiales = new Materiales();
    double cantidad = 0.0;
    int codProgramaProdControlCalidadDetalle = 0;

    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public ProgramaProduccionControlCalidadDetalle getProgramaProduccionControlCalidadDetalle() {
        return programaProduccionControlCalidadDetalle;
    }

    public void setProgramaProduccionControlCalidadDetalle(ProgramaProduccionControlCalidadDetalle programaProduccionControlCalidadDetalle) {
        this.programaProduccionControlCalidadDetalle = programaProduccionControlCalidadDetalle;
    }

    public int getCodProgramaProdControlCalidadDetalle() {
        return codProgramaProdControlCalidadDetalle;
    }

    public void setCodProgramaProdControlCalidadDetalle(int codProgramaProdControlCalidadDetalle) {
        this.codProgramaProdControlCalidadDetalle = codProgramaProdControlCalidadDetalle;
    }

    

    
    

}
