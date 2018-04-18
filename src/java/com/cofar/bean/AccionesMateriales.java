/*
 * AccionesMateriales.java
 *
 * Created on 7 de septiembre de 2010, 09:02 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Guery Garcia Jaldin
 */
public class AccionesMateriales {
    private String codSolicitudCompra="";
    private String material= "";
    private String cantidadSolicitada="";
    private String fechaPedidoSolicitud="";
    private String Estado= "";    
    private EstadoReferencialMateriales estadoReferencialMateriales = new EstadoReferencialMateriales();
    private Materiales materialesBean=new Materiales();
    private double diferencia=0;
    private double cantidadStock=0;
    private int nroOrden=0;
    
    
    
    /** Creates a new instance of AccionesMateriales */
    public AccionesMateriales() {
    }

    public String getCodSolicitudCompra() {
        return codSolicitudCompra;
    }

    public void setCodSolicitudCompra(String codSolicitudCompra) {
        this.codSolicitudCompra = codSolicitudCompra;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getCantidadSolicitada() {
        return cantidadSolicitada;
    }

    public void setCantidadSolicitada(String cantidadSolicitada) {
        this.cantidadSolicitada = cantidadSolicitada;
    }

    public String getFechaPedidoSolicitud() {
        return fechaPedidoSolicitud;
    }

    public void setFechaPedidoSolicitud(String fechaPedidoSolicitud) {
        this.fechaPedidoSolicitud = fechaPedidoSolicitud;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public EstadoReferencialMateriales getEstadoReferencialMateriales() {
        return estadoReferencialMateriales;
    }

    public void setEstadoReferencialMateriales(EstadoReferencialMateriales estadoReferencialMateriales) {
        this.estadoReferencialMateriales = estadoReferencialMateriales;
    }

    public Materiales getMaterialesBean() {
        return materialesBean;
    }

    public void setMaterialesBean(Materiales materialesBean) {
        this.materialesBean = materialesBean;
    }

    public double getDiferencia() {
        return diferencia;
    }

    public void setDiferencia(double diferencia) {
        this.diferencia = diferencia;
    }

    public int getNroOrden() {
        return nroOrden;
    }

    public void setNroOrden(int nroOrden) {
        this.nroOrden = nroOrden;
    }

    public double getCantidadStock() {
        return cantidadStock;
    }

    public void setCantidadStock(double cantidadStock) {
        this.cantidadStock = cantidadStock;
    }
}
