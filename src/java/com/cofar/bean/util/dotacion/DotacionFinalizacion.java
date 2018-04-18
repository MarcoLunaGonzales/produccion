/*
 * DotacionFinalizacion.java
 *
 * Created on 31 de enero de 2011, 07:37 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.dotacion;

import com.cofar.util.TimeFunction;
import java.util.Date;

/**
 *
 * @author Ismael Juchazara
 */
public class DotacionFinalizacion {
    
    private double monto;
    private double porcentaje;
    private Date fecha;
    private String descripcion;
    
    /** Creates a new instance of DotacionFinalizacion */
    public DotacionFinalizacion(double monto, double porcentaje, Date fecha, String descripcion) {
        this.monto = monto;
        this.porcentaje = TimeFunction.redondear(porcentaje, 2);
        this.fecha = fecha;
        this.descripcion = descripcion;
    }
    
    public double getMonto() {
        return monto;
    }
    
    public void setMonto(double monto) {
        this.monto = monto;
    }
    
    public double getPorcentaje() {
        return porcentaje;
    }
    
    public void setPorcentaje(double porcentaje) {
        this.porcentaje = porcentaje;
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
}
