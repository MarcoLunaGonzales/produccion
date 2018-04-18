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
public class PersonalAreaProduccion  extends AbstractBean
{
    
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private Date fechaInicio=new Date();
    private Personal personal=new Personal();
    private boolean operarioGenerico=false;
    private EstadosPersonalAreaProduccion estadosPersonalAreaProduccion=new EstadosPersonalAreaProduccion();
    public PersonalAreaProduccion() {
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public boolean isOperarioGenerico() {
        return operarioGenerico;
    }

    public void setOperarioGenerico(boolean operarioGenerico) {
        this.operarioGenerico = operarioGenerico;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public EstadosPersonalAreaProduccion getEstadosPersonalAreaProduccion() {
        return estadosPersonalAreaProduccion;
    }

    public void setEstadosPersonalAreaProduccion(EstadosPersonalAreaProduccion estadosPersonalAreaProduccion) {
        this.estadosPersonalAreaProduccion = estadosPersonalAreaProduccion;
    }

    
    
            
}
