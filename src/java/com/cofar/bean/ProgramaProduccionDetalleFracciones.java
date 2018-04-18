/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class ProgramaProduccionDetalleFracciones {
    int codFormulaMaestraFracciones = 0;
    ProgramaProduccionDetalle programaProduccionDetalle = new ProgramaProduccionDetalle();
    Double cantidad = 0.0;
    int conCodFraccion = 0;

    public int getCodFormulaMaestraFracciones() {
        return codFormulaMaestraFracciones;
    }

    public void setCodFormulaMaestraFracciones(int codFormulaMaestraFracciones) {
        this.codFormulaMaestraFracciones = codFormulaMaestraFracciones;
    }

    
    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public ProgramaProduccionDetalle getProgramaProduccionDetalle() {
        return programaProduccionDetalle;
    }

    public void setProgramaProduccionDetalle(ProgramaProduccionDetalle programaProduccionDetalle) {
        this.programaProduccionDetalle = programaProduccionDetalle;
    }

    public int getConCodFraccion() {
        return conCodFraccion;
    }

    public void setConCodFraccion(int conCodFraccion) {
        this.conCodFraccion = conCodFraccion;
    }


    


    
    

}
