/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class CampaniaProgramaProduccionDetalle extends AbstractBean{
    private CampaniaProgramaProduccion campanaProgramaProduccion=new CampaniaProgramaProduccion();
    private ProgramaProduccion programaProduccion=new ProgramaProduccion();

    public CampaniaProgramaProduccionDetalle() {
    }

    public CampaniaProgramaProduccion getCampanaProgramaProduccion() {
        return campanaProgramaProduccion;
    }

    public void setCampanaProgramaProduccion(CampaniaProgramaProduccion campanaProgramaProduccion) {
        this.campanaProgramaProduccion = campanaProgramaProduccion;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    

}
