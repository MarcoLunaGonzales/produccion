/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author hvaldivia
 */
public class IngresosAlmacenDetalleEstado extends AbstractBean {

    Date fechaIngresoAlmacen = new Date();
    int nroIngresoAlmacen = 0;
    Date fechaVencimiento = new Date();
    String codIngresoAlmacen = "";
    Materiales materiales = new Materiales();    
    int etiqueta = 0;    
    float cantidadParcial = 0;
    float cantidadRestante = 0;
    String loteMaterialProveedor = "";
    String loteInterno = "";
    Date fechaManufactura = new Date();
    String observaciones = "";
    int obsControlCalidad = 0;
    Date fechaVencimiento1 = new Date();
    Date fechaReanalisis1 = new Date();
    Date fechaVencimiento2 = new Date();
    Date fechaReanalisis2 = new Date();
    Date fechaReanalisis = new Date();
    float tara = 0;
    boolean conFechaVencimiento = false;
    boolean conFechaReanalisis = false;
    int codEstadoMaterial = 0;
    String nombreEstadoMaterial = "";
    int codEmpaque = 0;
    String nombreEmpaque = "";
    String nombreProveedor = "";

    public float getCantidadParcial() {
        return cantidadParcial;
    }

    public void setCantidadParcial(float cantidadParcial) {
        this.cantidadParcial = cantidadParcial;
    }

    public float getCantidadRestante() {
        return cantidadRestante;
    }

    public void setCantidadRestante(float cantidadRestante) {
        this.cantidadRestante = cantidadRestante;
    }

    

    public int getEtiqueta() {
        return etiqueta;
    }

    public void setEtiqueta(int etiqueta) {
        this.etiqueta = etiqueta;
    }

    public Date getFechaManufactura() {
        return fechaManufactura;
    }

    public void setFechaManufactura(Date fechaManufactura) {
        this.fechaManufactura = fechaManufactura;
    }


    public Date getFechaReanalisis1() {
        return fechaReanalisis1;
    }

    public void setFechaReanalisis1(Date fechaReanalisis1) {
        this.fechaReanalisis1 = fechaReanalisis1;
    }

    public Date getFechaReanalisis2() {
        return fechaReanalisis2;
    }

    public void setFechaReanalisis2(Date fechaReanalisis2) {
        this.fechaReanalisis2 = fechaReanalisis2;
    }

    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    public Date getFechaVencimiento1() {
        return fechaVencimiento1;
    }

    public void setFechaVencimiento1(Date fechaVencimiento1) {
        this.fechaVencimiento1 = fechaVencimiento1;
    }

    public Date getFechaVencimiento2() {
        return fechaVencimiento2;
    }

    public void setFechaVencimiento2(Date fechaVencimiento2) {
        this.fechaVencimiento2 = fechaVencimiento2;
    }

    

    public String getLoteInterno() {
        return loteInterno;
    }

    public void setLoteInterno(String loteInterno) {
        this.loteInterno = loteInterno;
    }

    public String getLoteMaterialProveedor() {
        return loteMaterialProveedor;
    }

    public void setLoteMaterialProveedor(String loteMaterialProveedor) {
        this.loteMaterialProveedor = loteMaterialProveedor;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public int getObsControlCalidad() {
        return obsControlCalidad;
    }

    public void setObsControlCalidad(int obsControlCalidad) {
        this.obsControlCalidad = obsControlCalidad;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
    
    public Date getFechaReanalisis() {
        return fechaReanalisis;
    }

    public void setFechaReanalisis(Date fechaReanalisis) {
        this.fechaReanalisis = fechaReanalisis;
    }
    

    public float getTara() {
        return tara;
    }

    public void setTara(float tara) {
        this.tara = tara;
    }

    public boolean getConFechaReanalisis() {
        return conFechaReanalisis;
    }

    public void setConFechaReanalisis(boolean conFechaReanalisis) {
        this.conFechaReanalisis = conFechaReanalisis;
    }

    public boolean getConFechaVencimiento() {
        return conFechaVencimiento;
    }

    public void setConFechaVencimiento(boolean conFechaVencimiento) {
        this.conFechaVencimiento = conFechaVencimiento;
    }

    public int getCodEmpaque() {
        return codEmpaque;
    }

    public void setCodEmpaque(int codEmpaque) {
        this.codEmpaque = codEmpaque;
    }

    public int getCodEstadoMaterial() {
        return codEstadoMaterial;
    }

    public void setCodEstadoMaterial(int codEstadoMaterial) {
        this.codEstadoMaterial = codEstadoMaterial;
    }

    public String getCodIngresoAlmacen() {
        return codIngresoAlmacen;
    }

    public void setCodIngresoAlmacen(String codIngresoAlmacen) {
        this.codIngresoAlmacen = codIngresoAlmacen;
    }

    public Date getFechaIngresoAlmacen() {
        return fechaIngresoAlmacen;
    }

    public void setFechaIngresoAlmacen(Date fechaIngresoAlmacen) {
        this.fechaIngresoAlmacen = fechaIngresoAlmacen;
    }

    public String getNombreEmpaque() {
        return nombreEmpaque;
    }

    public void setNombreEmpaque(String nombreEmpaque) {
        this.nombreEmpaque = nombreEmpaque;
    }

    public String getNombreEstadoMaterial() {
        return nombreEstadoMaterial;
    }

    public void setNombreEstadoMaterial(String nombreEstadoMaterial) {
        this.nombreEstadoMaterial = nombreEstadoMaterial;
    }

    public String getNombreProveedor() {
        return nombreProveedor;
    }

    public void setNombreProveedor(String nombreProveedor) {
        this.nombreProveedor = nombreProveedor;
    }

    public int getNroIngresoAlmacen() {
        return nroIngresoAlmacen;
    }

    public void setNroIngresoAlmacen(int nroIngresoAlmacen) {
        this.nroIngresoAlmacen = nroIngresoAlmacen;
    }

    

    


    
}
