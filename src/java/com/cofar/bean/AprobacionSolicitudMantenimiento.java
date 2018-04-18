/*
 * EnvasesSecundarios.java
 *
 * Created on 18 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class AprobacionSolicitudMantenimiento extends AbstractBean{
    
    /** Creates a new instance of TiposMercaderia */
    
    private EstadoSolicitudMantenimiento estadoSolicitudMantenimiento=new EstadoSolicitudMantenimiento();
    private SolicitudMantenimiento solicitudMantenimiento=new SolicitudMantenimiento();
    private Personal personal_ejecutante=new Personal();
    private String fechaCambioEstado="";
    private String obsAprobSolicitudMantenimiento="";
    private int swSi=0;
    private int swNo=0;
    
    public EstadoSolicitudMantenimiento getEstadoSolicitudMantenimiento() {
        return estadoSolicitudMantenimiento;
    }
    
    public void setEstadoSolicitudMantenimiento(EstadoSolicitudMantenimiento estadoSolicitudMantenimiento) {
        this.estadoSolicitudMantenimiento = estadoSolicitudMantenimiento;
    }
    
    public SolicitudMantenimiento getSolicitudMantenimiento() {
        return solicitudMantenimiento;
    }
    
    public void setSolicitudMantenimiento(SolicitudMantenimiento solicitudMantenimiento) {
        this.solicitudMantenimiento = solicitudMantenimiento;
    }
    
    public Personal getPersonal_ejecutante() {
        return personal_ejecutante;
    }
    
    public void setPersonal_ejecutante(Personal personal_ejecutante) {
        this.personal_ejecutante = personal_ejecutante;
    }
    
    public String getFechaCambioEstado() {
        return fechaCambioEstado;
    }
    
    public void setFechaCambioEstado(String fechaCambioEstado) {
        this.fechaCambioEstado = fechaCambioEstado;
    }
    
    public String getObsAprobSolicitudMantenimiento() {
        return obsAprobSolicitudMantenimiento;
    }
    
    public void setObsAprobSolicitudMantenimiento(String obsAprobSolicitudMantenimiento) {
        this.obsAprobSolicitudMantenimiento = obsAprobSolicitudMantenimiento;
    }

    public int getSwSi() {
        return swSi;
    }

    public void setSwSi(int swSi) {
        this.swSi = swSi;
    }

    public int getSwNo() {
        return swNo;
    }

    public void setSwNo(int swNo) {
        this.swNo = swNo;
    }


    
    
}
