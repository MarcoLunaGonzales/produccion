/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class ConfiguracionSolicitudesMateriales extends AbstractBean {
    private AreasEmpresa areaEmpresaProducto= new AreasEmpresa();
    private AreasEmpresa areaEmpresaActividad=new AreasEmpresa();
    private ActividadesProduccion actividadProduccion=new ActividadesProduccion();


    public ConfiguracionSolicitudesMateriales() {
    }

    public ActividadesProduccion getActividadProduccion() {
        return actividadProduccion;
    }

    public void setActividadProduccion(ActividadesProduccion actividadProduccion) {
        this.actividadProduccion = actividadProduccion;
    }

    public AreasEmpresa getAreaEmpresaActividad() {
        return areaEmpresaActividad;
    }

    public void setAreaEmpresaActividad(AreasEmpresa areaEmpresaActividad) {
        this.areaEmpresaActividad = areaEmpresaActividad;
    }

    public AreasEmpresa getAreaEmpresaProducto() {
        return areaEmpresaProducto;
    }

    public void setAreaEmpresaProducto(AreasEmpresa areaEmpresaProducto) {
        this.areaEmpresaProducto = areaEmpresaProducto;
    }
    
}
