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
public class TiposFrecuenciaMantenimiento extends AbstractBean
{
    private int codTipoFrecuenciaMantenimiento=0;
    private String nombreTipoFrecuenciaMantenimiento="";
    private boolean aplicaAsignarNroSemana=false;
    private String abreviatura="";
    public TiposFrecuenciaMantenimiento() {
    }

    public int getCodTipoFrecuenciaMantenimiento() {
        return codTipoFrecuenciaMantenimiento;
    }

    public void setCodTipoFrecuenciaMantenimiento(int codTipoFrecuenciaMantenimiento) {
        this.codTipoFrecuenciaMantenimiento = codTipoFrecuenciaMantenimiento;
    }

    public String getNombreTipoFrecuenciaMantenimiento() {
        return nombreTipoFrecuenciaMantenimiento;
    }

    public void setNombreTipoFrecuenciaMantenimiento(String nombreTipoFrecuenciaMantenimiento) {
        this.nombreTipoFrecuenciaMantenimiento = nombreTipoFrecuenciaMantenimiento;
    }

    public boolean isAplicaAsignarNroSemana() {
        return aplicaAsignarNroSemana;
    }

    public void setAplicaAsignarNroSemana(boolean aplicaAsignarNroSemana) {
        this.aplicaAsignarNroSemana = aplicaAsignarNroSemana;
    }

    public String getAbreviatura() {
        return abreviatura;
    }

    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }
    
    
    
}
