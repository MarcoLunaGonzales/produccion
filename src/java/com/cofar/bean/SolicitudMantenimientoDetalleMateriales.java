/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class SolicitudMantenimientoDetalleMateriales extends AbstractBean{
    private SolicitudMantenimiento solicitudMantenimiento = new SolicitudMantenimiento();
    private Materiales materiales = new Materiales();
    private String descripcion = "";
    private double Cantidad = 0;
    private double cantidadDisponibleAlmacen = 0;
    private double cantidadDisponibleAlmacenMantenimiento2=0;
    private Double cantidadDisponibleAlmacenCentral=0d;
    //variable auxiliar para mostrar existencias por almacen concatenados
    private String cantidadDisponibleOtrosAlmacenes="";
    private UnidadesMedida unidadesMedida = new UnidadesMedida();

    public double getCantidad() {
        return Cantidad;
    }

    public void setCantidad(double Cantidad) {
        this.Cantidad = Cantidad;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public SolicitudMantenimiento getSolicitudMantenimiento() {
        return solicitudMantenimiento;
    }

    public void setSolicitudMantenimiento(SolicitudMantenimiento solicitudMantenimiento) {
        this.solicitudMantenimiento = solicitudMantenimiento;
    }

    public double getCantidadDisponibleAlmacen() {
        return cantidadDisponibleAlmacen;
    }

    public void setCantidadDisponibleAlmacen(double cantidadDisponibleAlmacen) {
        this.cantidadDisponibleAlmacen = cantidadDisponibleAlmacen;
    }

    

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public double getCantidadDisponibleAlmacenMantenimiento2() {
        return cantidadDisponibleAlmacenMantenimiento2;
    }

    public void setCantidadDisponibleAlmacenMantenimiento2(double cantidadDisponibleAlmacenMantenimiento2) {
        this.cantidadDisponibleAlmacenMantenimiento2 = cantidadDisponibleAlmacenMantenimiento2;
    }

    public Double getCantidadDisponibleAlmacenCentral() {
        return cantidadDisponibleAlmacenCentral;
    }

    public void setCantidadDisponibleAlmacenCentral(Double cantidadDisponibleAlmacenCentral) {
        this.cantidadDisponibleAlmacenCentral = cantidadDisponibleAlmacenCentral;
    }

    public String getCantidadDisponibleOtrosAlmacenes() {
        return cantidadDisponibleOtrosAlmacenes;
    }

    public void setCantidadDisponibleOtrosAlmacenes(String cantidadDisponibleOtrosAlmacenes) {
        this.cantidadDisponibleOtrosAlmacenes = cantidadDisponibleOtrosAlmacenes;
    }

    
    
    
    
}
