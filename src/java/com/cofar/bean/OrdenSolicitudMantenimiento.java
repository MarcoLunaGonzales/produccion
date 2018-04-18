/*
 * OrdenSolicitudMantenimiento.java
 *
 * Created on 2 de septiembre de 2010, 04:39 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */


/*
 * OrdenSolicitudMantenimiento.java
 *
 * Created on 2 de septiembre de 2010, 02:27 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.bean;
/**
 * 
 * @author Guery Garcia Jaldin 
 */
public class OrdenSolicitudMantenimiento extends AbstractBean{
     private String ordencodSolicitudCompra;
     private String ordenSolMaterial;
     private String ordenSolSolicitadaCantidad;
     private String ordenSolSolicitadaFecha;
     private String ordenFecha;
     private String ordenEstado;
     private String ordenMateriales;
     private int ordenSolicitada;
     private int ordentStock;
     private int ordenDiferencia; 
     private int ordenNro;
     private String ordenCodMaterial;
     private AccionesMateriales AccionesMaterialesBean=new AccionesMateriales();             

     
    /** Creates a new instance of OrdenSolicitudMantenimiento */
    public OrdenSolicitudMantenimiento() {
    }

    public String getOrdenSolMaterial() {
        return ordenSolMaterial;
    }

    public void setOrdenSolMaterial(String ordenSolMaterial) {
        this.ordenSolMaterial = ordenSolMaterial;
    }

    public String getOrdenSolSolicitadaCantidad() {
        return ordenSolSolicitadaCantidad;
    }

    public void setOrdenSolSolicitadaCantidad(String ordenSolSolicitadaCantidad) {
        this.ordenSolSolicitadaCantidad = ordenSolSolicitadaCantidad;
    }

    public String getOrdenSolSolicitadaFecha() {
        return ordenSolSolicitadaFecha;
    }

    public void setOrdenSolSolicitadaFecha(String ordenSolSolicitadaFecha) {
        this.ordenSolSolicitadaFecha = ordenSolSolicitadaFecha;
    }

    public String getOrdenFecha() {
        return ordenFecha;
    }

    public void setOrdenFecha(String ordenFecha) {
        this.ordenFecha = ordenFecha;
    }

    public String getOrdenEstado() {
        return ordenEstado;
    }

    public void setOrdenEstado(String ordenEstado) {
        this.ordenEstado = ordenEstado;
    }

    public String getOrdenMateriales() {
        return ordenMateriales;
    }

    public void setOrdenMateriales(String ordenMateriales) {
        this.ordenMateriales = ordenMateriales;
    }

    public int getOrdenSolicitada() {
        return ordenSolicitada;
    }

    public void setOrdenSolicitada(int ordenSolicitada) {
        this.ordenSolicitada = ordenSolicitada;
    }

    public int getOrdentStock() {
        return ordentStock;
    }

    public void setOrdentStock(int ordentStock) {
        this.ordentStock = ordentStock;
    }

    public int getOrdenDiferencia() {
        return ordenDiferencia;
    }

    public void setOrdenDiferencia(int ordenDiferencia) {
        this.ordenDiferencia = ordenDiferencia;
    }

    public int getOrdenNro() {
        return ordenNro;
    }

    public void setOrdenNro(int ordenNro) {
        this.ordenNro = ordenNro;
    }

    public String getOrdencodSolicitudCompra() {
        return ordencodSolicitudCompra;
    }

    public void setOrdencodSolicitudCompra(String ordencodSolicitudCompra) {
        this.ordencodSolicitudCompra = ordencodSolicitudCompra;
    }

    public AccionesMateriales getAccionesMaterialesBean() {
        return AccionesMaterialesBean;
    }

    public void setAccionesMaterialesBean(AccionesMateriales AccionesMaterialesBean) {
        this.AccionesMaterialesBean = AccionesMaterialesBean;
    }

    public String getOrdenCodMaterial() {
        return ordenCodMaterial;
    }

    public void setOrdenCodMaterial(String ordenCodMaterial) {
        this.ordenCodMaterial = ordenCodMaterial;
    }
  
}

