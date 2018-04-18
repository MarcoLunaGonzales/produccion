/*
 * ProgramaProduccionPeriodo.java
 *
 * Created on 18 de noviembre de 2009, 03:28 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author mluna
 */
public class ProgramaProduccionPeriodo extends AbstractBean{

    private String codProgramaProduccion="";
    private String nombreProgramaProduccion="";
    private String obsProgramaProduccion="";    
    private Boolean checked=new Boolean(false);    
    private EstadoProgramaProduccion estadoProgramaProduccion = new EstadoProgramaProduccion();
    private Date fechaInicio = new Date();
    private Date fechaFinal = new Date();
    private int cantProgramaProduccionPeriodoSolicitudCompra=0;

    /** Creates a new instance of ProgramaProduccionPeriodo */
    public ProgramaProduccionPeriodo() {
    }

    public String getCodProgramaProduccion() {
        return codProgramaProduccion;
    }

    public void setCodProgramaProduccion(String codProgramaProduccion) {
        this.codProgramaProduccion = codProgramaProduccion;
    }

    public EstadoProgramaProduccion getEstadoProgramaProduccion() {
        return estadoProgramaProduccion;
    }

    public void setEstadoProgramaProduccion(EstadoProgramaProduccion estadoProgramaProduccion) {
        this.estadoProgramaProduccion = estadoProgramaProduccion;
    }

    public String getNombreProgramaProduccion() {
        return nombreProgramaProduccion;
    }

    public void setNombreProgramaProduccion(String nombreProgramaProduccion) {
        this.nombreProgramaProduccion = nombreProgramaProduccion;
    }

    public String getObsProgramaProduccion() {
        return obsProgramaProduccion;
    }

    public void setObsProgramaProduccion(String obsProgramaProduccion) {
        this.obsProgramaProduccion = obsProgramaProduccion;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public int getCantProgramaProduccionPeriodoSolicitudCompra() {
        return cantProgramaProduccionPeriodoSolicitudCompra;
    }

    public void setCantProgramaProduccionPeriodoSolicitudCompra(int cantProgramaProduccionPeriodoSolicitudCompra) {
        this.cantProgramaProduccionPeriodoSolicitudCompra = cantProgramaProduccionPeriodoSolicitudCompra;
    }
    
}
