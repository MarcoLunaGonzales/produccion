/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author wchoquehuanca
 */
public class SeguimientoProgramaProduccionIndirectoPersonal extends AbstractBean{
    private AreasEmpresa areasEmpresa= new AreasEmpresa();
    private ProgramaProduccionPeriodo programaProduccionPeriodo= new ProgramaProduccionPeriodo();
    private ActividadesProduccion actividadesProduccion= new ActividadesProduccion();
    private Personal personal= new Personal();
    private Date fechaInicio= new Date();
    private Date fechaFinal= new Date();
    private Date horaInicio= new Date();
    private Date horaFinal=new Date();
    private float horarHombre=0;

    public SeguimientoProgramaProduccionIndirectoPersonal() {
    }

    public ActividadesProduccion getActividadesProduccion() {
        return actividadesProduccion;
    }

    public void setActividadesProduccion(ActividadesProduccion actividadesProduccion) {
        this.actividadesProduccion = actividadesProduccion;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
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

    public float getHorarHombre() {
        return horarHombre;
    }

    public void setHorarHombre(float horarHombre) {
        this.horarHombre = horarHombre;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }

    public Date getHoraFinal() {
        return horaFinal;
    }

    public void setHoraFinal(Date horaFinal) {
        this.horaFinal = horaFinal;
    }

    public Date getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(Date horaInicio) {
        this.horaInicio = horaInicio;
    }



}
