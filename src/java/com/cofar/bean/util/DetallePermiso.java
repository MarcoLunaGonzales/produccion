/*
 * DetallePermiso.java
 *
 * Created on 28 de enero de 2011, 11:13 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

/**
 *
 * @author Ismael Juchazara
 */
public class DetallePermiso {
    
    private double reemplazable;
    private double descuento;
    private double suspension;
    private double comision;
    
    /** Creates a new instance of DetallePermiso */
    public DetallePermiso(double reemplazable, double descuento, double suspension, double comision) {
        this.reemplazable = reemplazable;
        this.descuento = descuento;
        this.comision = comision;
        this.suspension=suspension;
    }
    
    public double getReemplazable() {
        return reemplazable;
    }
    
    public void setReemplazable(double reemplazable) {
        this.reemplazable = reemplazable;
    }
    
    public double getDescuento() {
        return descuento;
    }
    
    public void setDescuento(double descuento) {
        this.descuento = descuento;
    }
    
    public double getComision() {
        return comision;
    }
    
    public void setComision(double comision) {
        this.comision = comision;
    }

    /**
     * @return the suspension
     */
    public double getSuspension() {
        return suspension;
    }

    /**
     * @param suspension the suspension to set
     */
    public void setSuspension(double suspension) {
        this.suspension = suspension;
    }
    
}
