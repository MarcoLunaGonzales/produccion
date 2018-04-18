/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author aquispe
 */
public class SeguimientoPersonalMantenimiento extends AbstractBean {
    private Personal personal=new Personal();
    private List<SolicitudMantenimientoDetalleTareas> solicitudMantenimientoDetalleTareasList=null;
    private float horasHombre=0f;
    private Date fechaInicio=new Date();
    public SeguimientoPersonalMantenimiento() {
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public List<SolicitudMantenimientoDetalleTareas> getSolicitudMantenimientoDetalleTareasList() {
        return solicitudMantenimientoDetalleTareasList;
    }

    public void setSolicitudMantenimientoDetalleTareasList(List<SolicitudMantenimientoDetalleTareas> solicitudMantenimientoDetalleTareasList) {
        this.solicitudMantenimientoDetalleTareasList = solicitudMantenimientoDetalleTareasList;
    }
    public int getCantidadOrdenesTrabajo()
    {
        return solicitudMantenimientoDetalleTareasList.size();
    }

    public float getHorasHombre() {
        return horasHombre;
    }

    public void setHorasHombre(float horasHombre) {
        this.horasHombre = horasHombre;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    
    
}
