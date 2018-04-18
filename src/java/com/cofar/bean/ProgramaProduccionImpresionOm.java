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
public class ProgramaProduccionImpresionOm extends AbstractBean
{
    private int codProgramaProduccionImpresionOm=0;
    private Date fechaEmision=new Date();
    private Date fechaEntrega=new Date();
    private EstadosProgramaProduccionImpresionOm estadosProgramaProduccionImpresionOm=new EstadosProgramaProduccionImpresionOm();

    public ProgramaProduccionImpresionOm() 
    {
    }

    public int getCodProgramaProduccionImpresionOm() {
        return codProgramaProduccionImpresionOm;
    }

    public void setCodProgramaProduccionImpresionOm(int codProgramaProduccionImpresionOm) {
        this.codProgramaProduccionImpresionOm = codProgramaProduccionImpresionOm;
    }

    public Date getFechaEmision() {
        return fechaEmision;
    }

    public void setFechaEmision(Date fechaEmision) {
        this.fechaEmision = fechaEmision;
    }

    public EstadosProgramaProduccionImpresionOm getEstadosProgramaProduccionImpresionOm() {
        return estadosProgramaProduccionImpresionOm;
    }

    public void setEstadosProgramaProduccionImpresionOm(EstadosProgramaProduccionImpresionOm estadosProgramaProduccionImpresionOm) {
        this.estadosProgramaProduccionImpresionOm = estadosProgramaProduccionImpresionOm;
    }

    public Date getFechaEntrega() {
        return fechaEntrega;
    }

    public void setFechaEntrega(Date fechaEntrega) {
        this.fechaEntrega = fechaEntrega;
    }
    
    
}
