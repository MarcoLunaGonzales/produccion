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
public class PersonalAreaProduccionDetalle {
    private Personal personal= new Personal();
    private AreasEmpresa areasEmpresa= new AreasEmpresa();
    private Date fechaInicio= new Date();
    private Date fechaFinal= new Date();
    private String comentario="";
    public PersonalAreaProduccionDetalle()
    {
    }

    

    /**
     * @return the fechaInicio
     */
    public Date getFechaInicio() {
        return fechaInicio;
    }

    /**
     * @param fechaInicio the fechaInicio to set
     */
    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    /**
     * @return the fechaFinal
     */
    public Date getFechaFinal() {
        return fechaFinal;
    }

    /**
     * @param fechaFinal the fechaFinal to set
     */
    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    /**
     * @return the comentario
     */
    public String getComentario() {
        return comentario;
    }

    /**
     * @param comentario the comentario to set
     */
    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    /**
     * @return the personal
     */
    public Personal getPersonal() {
        return personal;
    }

    /**
     * @param personal the personal to set
     */
    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    /**
     * @return the areasEmpresa
     */
    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    /**
     * @param areasEmpresa the areasEmpresa to set
     */
    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    


}
