/*
 * DotacionAmortizacion.java
 *
 * Created on 20 de enero de 2011, 09:38 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.dotacion;

/**
 *
 * @author Ismael Juchazara
 */
public class DotacionAmortizacion {
    
    private int personal;
    private int codigoGestion;
    private int codigoMes;
    private int codigoPrestamo;
    
    private String gestion;
    private String mes;
    private double porcentaje;
    private double monto;
    private boolean pagado;
    
    /** Creates a new instance of DotacionAmortizacion */
    public DotacionAmortizacion(int personal, int codigoGestion, int codigoMes, int codigoPrestamo, String gestion, String mes, double porcentaje, double monto, boolean pagado) {
        //public DotacionAmortizacion(String gestion, String mes, double porcentaje, double monto, boolean pagado) {
        this.personal = personal;
        this.codigoGestion = codigoGestion;
        this.codigoMes = codigoMes;
        this.codigoPrestamo = codigoPrestamo;
        this.gestion = gestion;
        this.mes = mes;
        this.porcentaje = porcentaje;
        this.monto = monto;
        this.pagado = pagado;
    }
    
    public String getGestion() {
        return gestion;
    }
    
    public void setGestion(String gestion) {
        this.gestion = gestion;
    }
    
    public String getMes() {
        return mes;
    }
    
    public void setMes(String mes) {
        this.mes = mes;
    }
    
    public double getPorcentaje() {
        return porcentaje;
    }
    
    public void setPorcentaje(double porcentaje) {
        this.porcentaje = porcentaje;
    }
    
    public double getMonto() {
        return monto;
    }
    
    public void setMonto(double monto) {
        this.monto = monto;
    }
    
    public boolean isPagado() {
        return pagado;
    }
    
    public void setPagado(boolean pagado) {
        this.pagado = pagado;
    }
    
    
    
}
