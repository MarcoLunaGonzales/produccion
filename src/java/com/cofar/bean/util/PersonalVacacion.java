/*
 * PersonaVacacion.java
 *
 * Created on 19 de octubre de 2010, 02:53 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import java.util.Date;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalVacacion {
    
    private int codigo;
    private String nombreCompleto;
    private String cargo;
    private String areaEmpresa;
    private Date fechaInicio;
    private Date fechaFin;
    private double duracion;
    private int tipoInicio;
    private int tipoFinal;
    
    public PersonalVacacion(int codigo, String nombreCompleto, String cargo, String areaEmpresa, Date fechaInicio, Date fechaFin, double duracion, int tipoInicio, int tipoFinal){
        this.codigo = codigo;
        this.nombreCompleto = nombreCompleto;
        this.cargo = cargo;
        this.areaEmpresa = areaEmpresa;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.duracion = duracion;
        this.tipoInicio = tipoInicio;
        this.tipoFinal = tipoFinal;
    }
    
    /** Creates a new instance of PersonaVacacion */
    public PersonalVacacion() {
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public String getNombreCompleto() {
        return nombreCompleto;
    }
    
    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }
    
    public String getCargo() {
        return cargo;
    }
    
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }
    
    public Date getFechaInicio() {
        return fechaInicio;
    }
    
    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }
    
    public Date getFechaFin() {
        return fechaFin;
    }
    
    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }
    
    public double getDuracion() {
        return duracion;
    }
    
    public void setDuracion(double duracion) {
        this.duracion = duracion;
    }
    
    public int getTipoInicio() {
        return tipoInicio;
    }
    
    public void setTipoInicio(int tipoInicio) {
        this.tipoInicio = tipoInicio;
    }
    
    public int getTipoFinal() {
        return tipoFinal;
    }
    
    public void setTipoFinal(int tipoFinal) {
        this.tipoFinal = tipoFinal;
    }

    public String getAreaEmpresa() {
        return areaEmpresa;
    }

    public void setAreaEmpresa(String areaEmpresa) {
        this.areaEmpresa = areaEmpresa;
    }
    
}
