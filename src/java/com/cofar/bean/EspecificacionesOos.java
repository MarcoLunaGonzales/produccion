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
 * @author DASISAQ
 */
public class EspecificacionesOos extends AbstractBean{
    private int codEspecificacionOos=0;
    private String nombreEspecificacionOos="";
    private TiposEspecificacionesOos tiposEspecificacionesOos=new TiposEspecificacionesOos();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private List<SubEspecificacionesOOS> subEspecificacionesOOSList=null;
    private String descripcionEspecificacion="";
    private int nroOrden=0;
    private boolean fechaCumplimiento=false;
    private Date fechaCumplimientoOos=null;
    public EspecificacionesOos() {
    }

    public int getCodEspecificacionOos() {
        return codEspecificacionOos;
    }

    public void setCodEspecificacionOos(int codEspecificacionOos) {
        this.codEspecificacionOos = codEspecificacionOos;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreEspecificacionOos() {
        return nombreEspecificacionOos;
    }

    public void setNombreEspecificacionOos(String nombreEspecificacionOos) {
        this.nombreEspecificacionOos = nombreEspecificacionOos;
    }

    public TiposEspecificacionesOos getTiposEspecificacionesOos() {
        return tiposEspecificacionesOos;
    }

    public void setTiposEspecificacionesOos(TiposEspecificacionesOos tiposEspecificacionesOos) {
        this.tiposEspecificacionesOos = tiposEspecificacionesOos;
    }

    public List<SubEspecificacionesOOS> getSubEspecificacionesOOSList() {
        return subEspecificacionesOOSList;
    }

    public void setSubEspecificacionesOOSList(List<SubEspecificacionesOOS> subEspecificacionesOOSList) {
        this.subEspecificacionesOOSList = subEspecificacionesOOSList;
    }

    public int getSubEspecificacionesListSize()
    {
        return (this.subEspecificacionesOOSList!=null?this.subEspecificacionesOOSList.size():1);
    }

    public String getDescripcionEspecificacion() {
        return descripcionEspecificacion;
    }

    public void setDescripcionEspecificacion(String descripcionEspecificacion) {
        this.descripcionEspecificacion = descripcionEspecificacion;
    }

    public int getNroOrden() {
        return nroOrden;
    }

    public void setNroOrden(int nroOrden) {
        this.nroOrden = nroOrden;
    }

    public boolean isFechaCumplimiento() {
        return fechaCumplimiento;
    }

    public void setFechaCumplimiento(boolean fechaCumplimiento) {
        this.fechaCumplimiento = fechaCumplimiento;
    }

    public Date getFechaCumplimientoOos() {
        return fechaCumplimientoOos;
    }

    public void setFechaCumplimientoOos(Date fechaCumplimientoOos) {
        this.fechaCumplimientoOos = fechaCumplimientoOos;
    }

    
}
