/*
 * PersonalAsignacion.java
 *
 * Created on 14 de enero de 2011, 04:47 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.dotacion;

import java.util.List;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalAsignacion {
    
    private int codigo;
    private String nombre;
    private String cargo;
    private String area;
    private List<DotacionAsignada> dotaciones;
    
    /** Creates a new instance of PersonalAsignacion */
    public PersonalAsignacion(){
    }
    
    public PersonalAsignacion(int codigo, String nombre, String cargo, String area, List<DotacionAsignada> dotaciones){
        this.codigo = codigo;
        this.nombre = nombre;
        this.cargo = cargo;
        this.area = area;
        this.dotaciones = dotaciones;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getCargo() {
        return cargo;
    }
    
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }
    
    public String getArea() {
        return area;
    }
    
    public void setArea(String area) {
        this.area = area;
    }
    
    public List<DotacionAsignada> getDotaciones() {
        return dotaciones;
    }
    
    public void setDotaciones(List<DotacionAsignada> dotaciones) {
        this.dotaciones = dotaciones;
    }
    
}
