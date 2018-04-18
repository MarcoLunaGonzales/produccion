/*
 * Justificacion.java
 *
 * Created on 25 de noviembre de 2010, 09:16 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import com.cofar.util.StyleFunction;

/**
 *
 * @author Ismael Juchazara
 */
public class Justificacion {
    
    private String nombre;
    private String motivo;
    private int tipo;
    private int minutos;
    
    /** Creates a new instance of Justificacion */
    public Justificacion() {
    }
    
    public Justificacion(String nombre, String motivo, int tipo, int minutos){
        this.nombre = nombre;
        this.motivo = motivo;
        this.tipo = tipo;
        this.minutos = minutos;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public int getMinutos() {
        return minutos;
    }
    
    public void setMinutos(int minutos) {
        this.minutos = minutos;
    }
    
    public int getTipo() {
        return tipo;
    }
    
    public void setTipo(int tipo) {
        this.tipo = tipo;
    }
    
    public String getMotivo() {
        return motivo;
    }
    
    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }
    
    public String getNombreTipo(){
        return (StyleFunction.estiloJustificacion(this.tipo));
    }
    
}
