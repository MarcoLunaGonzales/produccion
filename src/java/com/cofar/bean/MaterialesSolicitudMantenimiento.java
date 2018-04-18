/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author sistemas1
 */
public class MaterialesSolicitudMantenimiento {

    private String codSolicitudMantenimiento = "";
    private String descripcion = "";
    private String codMaterial = "";
    private String nombreMaterial = "";
    private String codUnidadMedida="";
    private String nombreUnidadMedida="";
    private String cantidad = "";
    private String disponible="";
    private String cantidadSugerida="";

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getCodMaterial() {
        return codMaterial;
    }

    public void setCodMaterial(String codMaterial) {
        this.codMaterial = codMaterial;
    }

    public String getCodSolicitudMantenimiento() {
        return codSolicitudMantenimiento;
    }

    public void setCodSolicitudMantenimiento(String codSolicitudMantenimiento) {
        this.codSolicitudMantenimiento = codSolicitudMantenimiento;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getNombreMaterial() {
        return nombreMaterial;
    }

    public void setNombreMaterial(String nombreMaterial) {
        this.nombreMaterial = nombreMaterial;
    }

    public String getCodUnidadMedida() {
        return codUnidadMedida;
    }

    public void setCodUnidadMedida(String codUnidadMedida) {
        this.codUnidadMedida = codUnidadMedida;
    }

    public String getNombreUnidadMedida() {
        return nombreUnidadMedida;
    }

    public void setNombreUnidadMedida(String nombreUnidadMedida) {
        this.nombreUnidadMedida = nombreUnidadMedida;
    }

    public String getDisponible() {
        return disponible;
    }

    public void setDisponible(String disponible) {
        this.disponible = disponible;
    }

    public String getCantidadSugerida() {
        return cantidadSugerida;
    }

    public void setCantidadSugerida(String cantidadSugerida) {
        this.cantidadSugerida = cantidadSugerida;
    }

    

    
}
