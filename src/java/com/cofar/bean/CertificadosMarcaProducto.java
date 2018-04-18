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
public class CertificadosMarcaProducto extends AbstractBean{
    private Producto producto=new Producto();
    private String resolucionRenovacion="";
    private Date fechaRegistroMarca=null;
    private String urlRenovacionResolucion="";
    private boolean productoNoRenovacion=false;
    private String observacion="";
    private Date fechaExpiracionMarca=null;
    public CertificadosMarcaProducto() {
    }

    

    public Date getFechaRegistroMarca() {
        return fechaRegistroMarca;
    }

    public void setFechaRegistroMarca(Date fechaRegistroMarca) {
        this.fechaRegistroMarca = fechaRegistroMarca;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public boolean isProductoNoRenovacion() {
        return productoNoRenovacion;
    }

    public void setProductoNoRenovacion(boolean productoNoRenovacion) {
        this.productoNoRenovacion = productoNoRenovacion;
    }

 

    public String getResolucionRenovacion() {
        return resolucionRenovacion;
    }

    public void setResolucionRenovacion(String resolucionRenovacion) {
        this.resolucionRenovacion = resolucionRenovacion;
    }

    public String getUrlRenovacionResolucion() {
        return urlRenovacionResolucion;
    }

    public void setUrlRenovacionResolucion(String urlRenovacionResolucion) {
        this.urlRenovacionResolucion = urlRenovacionResolucion;
    }

    public Date getFechaExpiracionMarca() {
        return fechaExpiracionMarca;
    }

    public void setFechaExpiracionMarca(Date fechaExpiracionMarca) {
        this.fechaExpiracionMarca = fechaExpiracionMarca;
    }
    
    

}
