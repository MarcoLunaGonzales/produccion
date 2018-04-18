/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class ProgramaProduccionIngresoAcond extends AbstractBean{
    private ProgramaProduccion programaProduccion ;
    private TiposEntregaAcond tiposEntregaAcond = new TiposEntregaAcond();

    public ProgramaProduccionIngresoAcond() {
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public TiposEntregaAcond getTiposEntregaAcond() {
        return tiposEntregaAcond;
    }

    public void setTiposEntregaAcond(TiposEntregaAcond tiposEntregaAcond) {
        this.tiposEntregaAcond = tiposEntregaAcond;
    }
    
    
}
