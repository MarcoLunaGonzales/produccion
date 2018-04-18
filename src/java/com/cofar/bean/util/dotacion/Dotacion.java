/*
 * Dotacion.java
 *
 * Created on 7 de enero de 2011, 07:12 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.dotacion;

/**
 *
 * @author Ismael Juchazara
 */
public class Dotacion {
    
    private boolean seleccion;
    private int codigo;
    private String nombre;
    private int gestion;
    private String nombreGestion;
    
    /** Creates a new instance of Dotacion */
    public Dotacion(int codigo, String nombre) {
        this.setSeleccion(false);
        this.codigo = codigo;
        this.nombre = nombre;
    }
    
    public Dotacion(int codigo, String nombre, int gestion, String nombreGestion) {
        this.setSeleccion(false);
        this.codigo = codigo;
        this.nombre = nombre;
        this.gestion = gestion;
        this.nombreGestion = nombreGestion;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public boolean isSeleccion() {
        return seleccion;
    }
    
    public void setSeleccion(boolean seleccion) {
        this.seleccion = seleccion;
    }
    
    public int getGestion() {
        return gestion;
    }
    
    public void setGestion(int gestion) {
        this.gestion = gestion;
    }

    public String getNombreGestion() {
        return nombreGestion;
    }

    public void setNombreGestion(String nombreGestion) {
        this.nombreGestion = nombreGestion;
    }
}
