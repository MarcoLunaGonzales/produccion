/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author DASISAQ
 */
public class SolicitudMantenimientoSolicitudSalidaAlmacen extends AbstractBean
{
    private SolicitudesSalida solicitudesSalida=new SolicitudesSalida();
    private int codSolicitudMantenimientoSolicitudSalidaAlmacen=0;
    private String descripcion="";
    private Date fechaRegistro=new Date();
    private List<SolicitudMantenimientoDetalleMateriales> solicitudMantenimientoDetalleMaterialesList;

    public SolicitudMantenimientoSolicitudSalidaAlmacen() {
    }

    public SolicitudesSalida getSolicitudesSalida() {
        return solicitudesSalida;
    }

    public void setSolicitudesSalida(SolicitudesSalida solicitudesSalida) {
        this.solicitudesSalida = solicitudesSalida;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public int getCodSolicitudMantenimientoSolicitudSalidaAlmacen() {
        return codSolicitudMantenimientoSolicitudSalidaAlmacen;
    }

    public void setCodSolicitudMantenimientoSolicitudSalidaAlmacen(int codSolicitudMantenimientoSolicitudSalidaAlmacen) {
        this.codSolicitudMantenimientoSolicitudSalidaAlmacen = codSolicitudMantenimientoSolicitudSalidaAlmacen;
    }

    public List<SolicitudMantenimientoDetalleMateriales> getSolicitudMantenimientoDetalleMaterialesList() {
        return solicitudMantenimientoDetalleMaterialesList;
    }

    public void setSolicitudMantenimientoDetalleMaterialesList(List<SolicitudMantenimientoDetalleMateriales> solicitudMantenimientoDetalleMaterialesList) {
        this.solicitudMantenimientoDetalleMaterialesList = solicitudMantenimientoDetalleMaterialesList;
    }

    public int getSolicitudMantenimientoDetalleMaterialesListSize()
    {
        return (this.solicitudMantenimientoDetalleMaterialesList!=null?solicitudMantenimientoDetalleMaterialesList.size():0);
    }
    
    
    
}
