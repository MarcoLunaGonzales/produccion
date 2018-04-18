/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class RendimientoEstandarComponentesProd extends AbstractBean
{
    private ComponentesProd componentesProd=new ComponentesProd();
    private Date fechaInicio=new Date();
    private Date fechaFinal=new Date();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private Double porcientoRendimientoMinimo=0d;
    private Double porcientoRendimientoMaximo=0d;

    public RendimientoEstandarComponentesProd() {
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public Double getPorcientoRendimientoMinimo() {
        return porcientoRendimientoMinimo;
    }

    public void setPorcientoRendimientoMinimo(Double porcientoRendimientoMinimo) {
        this.porcientoRendimientoMinimo = porcientoRendimientoMinimo;
    }

    public Double getPorcientoRendimientoMaximo() {
        return porcientoRendimientoMaximo;
    }

    public void setPorcientoRendimientoMaximo(Double porcientoRendimientoMaximo) {
        this.porcientoRendimientoMaximo = porcientoRendimientoMaximo;
    }

    
    
    
}
