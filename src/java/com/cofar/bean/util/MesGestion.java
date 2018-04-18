/*
 * MesGestion.java
 *
 * Created on 26 de enero de 2011, 06:22 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

/**
 *
 * @author Ismael Juchazara
 */
public class MesGestion {
    
    private int mes;
    private int gestion;
    private String nombre_mes;
    
    /** Creates a new instance of MesGestion */
    public MesGestion(int mes, int gestion, String nombre_mes) {
        this.mes = mes;
        this.gestion = gestion;
        this.nombre_mes = nombre_mes;
    }
    
    public int getMes() {
        return mes;
    }
    
    public void setMes(int mes) {
        this.mes = mes;
    }
    
    public int getGestion() {
        return gestion;
    }
    
    public void setGestion(int gestion) {
        this.gestion = gestion;
    }
    
    public String getNombre_mes() {
        return nombre_mes;
    }
    
    public void setNombre_mes(String nombre_mes) {
        this.nombre_mes = nombre_mes;
    }
    
}
