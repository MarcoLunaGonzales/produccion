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
public class MarcasProducto extends AbstractBean{
    private int codMarcaProducto=0;
    private String nombreMarcaProducto="";
    private String resolucionRenovacion="";
    private Date fechaRegistroMarca=null;
    private String urlRenovacionResolucion="";
    private boolean productoRenovacion=true;
    private String observacion="";
    private Date fechaExpiracionMarca=null;
    private EstadosMarcaProducto estadosMarcaProducto=new EstadosMarcaProducto();
    public MarcasProducto() {
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

    public int getCodMarcaProducto() {
        return codMarcaProducto;
    }

    public void setCodMarcaProducto(int codMarcaProducto) {
        this.codMarcaProducto = codMarcaProducto;
    }

    public String getNombreMarcaProducto() {
        return nombreMarcaProducto;
    }

    public void setNombreMarcaProducto(String nombreMarcaProducto) {
        this.nombreMarcaProducto = nombreMarcaProducto;
    }

    public EstadosMarcaProducto getEstadosMarcaProducto() {
        return estadosMarcaProducto;
    }

    public void setEstadosMarcaProducto(EstadosMarcaProducto estadosMarcaProducto) {
        this.estadosMarcaProducto = estadosMarcaProducto;
    }

    public boolean isProductoRenovacion() {
        return productoRenovacion;
    }

    public void setProductoRenovacion(boolean productoRenovacion) {
        this.productoRenovacion = productoRenovacion;
    }
    
    

}
