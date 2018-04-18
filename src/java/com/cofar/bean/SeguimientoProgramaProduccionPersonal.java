/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class SeguimientoProgramaProduccionPersonal extends AbstractBean{
    SeguimientoProgramaProduccion seguimientoProgramaProduccion = new SeguimientoProgramaProduccion();
    Personal personal = new Personal();
    double horasHombre = 0;
    int unidadesProducidas = 0;
    Date fechaRegistro = new Date();
    Date fechaInicio = new Date();
    Date fechaFinal = new Date();
    Date horaInicio = new Date();
    Date horaFinal = new Date();
    double horasExtra = 0;
    double unidadesProducidasExtra = 0;
    private List<DefectosEnvaseProgramaProduccion> defectosEnvaseProgramaProduccionList=new ArrayList<DefectosEnvaseProgramaProduccion>();

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public double getHorasHombre() {
        return horasHombre;
    }

    public void setHorasHombre(double horasHombre) {
        this.horasHombre = horasHombre;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public SeguimientoProgramaProduccion getSeguimientoProgramaProduccion() {
        return seguimientoProgramaProduccion;
    }

    public void setSeguimientoProgramaProduccion(SeguimientoProgramaProduccion seguimientoProgramaProduccion) {
        this.seguimientoProgramaProduccion = seguimientoProgramaProduccion;
    }

    public int getUnidadesProducidas() {
        return unidadesProducidas;
    }

    public void setUnidadesProducidas(int unidadesProducidas) {
        this.unidadesProducidas = unidadesProducidas;
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

    public double getHorasExtra() {
        return horasExtra;
    }

    public void setHorasExtra(double horasExtra) {
        this.horasExtra = horasExtra;
    }

    public double getUnidadesProducidasExtra() {
        return unidadesProducidasExtra;
    }

    public void setUnidadesProducidasExtra(double unidadesProducidasExtra) {
        this.unidadesProducidasExtra = unidadesProducidasExtra;
    }

    public List<DefectosEnvaseProgramaProduccion> getDefectosEnvaseProgramaProduccionList() {
        return defectosEnvaseProgramaProduccionList;
    }

    public void setDefectosEnvaseProgramaProduccionList(List<DefectosEnvaseProgramaProduccion> defectosEnvaseProgramaProduccionList) {
        this.defectosEnvaseProgramaProduccionList = defectosEnvaseProgramaProduccionList;
    }


}
