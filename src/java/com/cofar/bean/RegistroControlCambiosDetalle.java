/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;



/**
 *
 * @author DASISAQ-
 */
public class RegistroControlCambiosDetalle extends AbstractBean{
    private EspecificacionesControlCambios especificacionesControlCambios=new EspecificacionesControlCambios();
    private boolean aplica=false;
    private String actividad="";
    private Personal personalResponsable=new Personal();
    private Date fechaLimite=null;

    public RegistroControlCambiosDetalle() {
    }

    public String getActividad() {
        return actividad;
    }

    public void setActividad(String actividad) {
        this.actividad = actividad;
    }

    public boolean isAplica() {
        return aplica;
    }

    public void setAplica(boolean aplica) {
        this.aplica = aplica;
    }

    public EspecificacionesControlCambios getEspecificacionesControlCambios() {
        return especificacionesControlCambios;
    }

    public void setEspecificacionesControlCambios(EspecificacionesControlCambios especificacionesControlCambios) {
        this.especificacionesControlCambios = especificacionesControlCambios;
    }

    public Date getFechaLimite() {
        return fechaLimite;
    }

    public void setFechaLimite(Date fechaLimite) {
        this.fechaLimite = fechaLimite;
    }

    public Personal getPersonalResponsable() {
        return personalResponsable;
    }

    public void setPersonalResponsable(Personal personalResponsable) {
        this.personalResponsable = personalResponsable;
    }
    

}
