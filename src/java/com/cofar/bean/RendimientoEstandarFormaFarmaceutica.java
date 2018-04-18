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
public class RendimientoEstandarFormaFarmaceutica extends AbstractBean 
{
    private FormasFarmaceuticas formasFarmaceuticas=new FormasFarmaceuticas();
    private Date fechaInicio=new Date();
    private Date fechaFinal=new Date();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private double porcientoRendimientoMinimo=0d;
    private double porcientoRendimientoMaximo=0d;

    public RendimientoEstandarFormaFarmaceutica() {
    }

    public FormasFarmaceuticas getFormasFarmaceuticas() {
        return formasFarmaceuticas;
    }

    public void setFormasFarmaceuticas(FormasFarmaceuticas formasFarmaceuticas) {
        this.formasFarmaceuticas = formasFarmaceuticas;
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

    public double getPorcientoRendimientoMinimo() {
        return porcientoRendimientoMinimo;
    }

    public void setPorcientoRendimientoMinimo(double porcientoRendimientoMinimo) {
        this.porcientoRendimientoMinimo = porcientoRendimientoMinimo;
    }

    public double getPorcientoRendimientoMaximo() {
        return porcientoRendimientoMaximo;
    }

    public void setPorcientoRendimientoMaximo(double porcientoRendimientoMaximo) {
        this.porcientoRendimientoMaximo = porcientoRendimientoMaximo;
    }

    
    
    
}
