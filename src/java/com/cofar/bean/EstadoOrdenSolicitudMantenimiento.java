/*
 * EstadoOrdenSolicitudMantenimiento.java
 *
 * Created on 3 de septiembre de 2010, 02:51 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Guery Garcia Jaldin
 */
public class EstadoOrdenSolicitudMantenimiento {
    private String codSolicitudMantenimiento="";
    private String nombreMateriales="";
    /** Creates a new instance of EstadoOrdenSolicitudMantenimiento */
 private String codSolicitudCompra="";
 
    public EstadoOrdenSolicitudMantenimiento() {
    }

    public String getCodSolicitudMantenimiento() {
        return codSolicitudMantenimiento;
    }

    public void setCodSolicitudMantenimiento(String codSolicitudMantenimiento) {
        this.codSolicitudMantenimiento = codSolicitudMantenimiento;
    }

    public String getNombreMateriales() {
        return nombreMateriales;
    }

    public void setNombreMateriales(String nombreMateriales) {
        this.nombreMateriales = nombreMateriales;
    }

    public String getCodSolicitudCompra() {
        return codSolicitudCompra;
    }

    public void setCodSolicitudCompra(String codSolicitudCompra) {
        this.codSolicitudCompra = codSolicitudCompra;
    }
    
}
