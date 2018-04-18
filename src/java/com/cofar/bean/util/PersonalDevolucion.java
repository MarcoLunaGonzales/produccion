/*
 * PersonalDevolucion.java
 *
 * Created on 3 de diciembre de 2010, 04:25 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalDevolucion {
    
    private int codigo;
    private int dias;
    private int continuos;
    private double discontinuos;
    private double montoContinuo;
    private double montoDiscontinuo;
    
    /** Creates a new instance of PersonalDevolucion */
    public PersonalDevolucion(int codigo, int dias, int continuos, double discontinuos, double cantidad_continuo, double cantidad_discontinuo) {
        this.codigo = codigo;
        this.dias = dias;
        this.continuos = continuos;
        this.discontinuos = discontinuos;
        this.montoContinuo = cantidad_continuo;
        this.montoDiscontinuo = cantidad_discontinuo;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public int getDias() {
        return dias;
    }
    
    public void setDias(int dias) {
        this.dias = dias;
    }
    
    public int getContinuos() {
        return continuos;
    }
    
    public void setContinuos(int continuos) {
        this.continuos = continuos;
    }
    
    public double getDiscontinuos() {
        return discontinuos;
    }
    
    public void setDiscontinuos(double discontinuos) {
        this.discontinuos = discontinuos;
    }
    
    public double getMontoContinuo() {
        return montoContinuo;
    }
    
    public void setMontoContinuo(double montoContinuo) {
        this.montoContinuo = montoContinuo;
    }
    
    public double getMontoDiscontinuo() {
        return montoDiscontinuo;
    }
    
    public void setMontoDiscontinuo(double montoDiscontinuo) {
        this.montoDiscontinuo = montoDiscontinuo;
    }
    
}
