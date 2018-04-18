/*
 * PersonalMaternidad.java
 *
 * Created on 26 de noviembre de 2010, 04:53 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import java.util.Date;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalMaternidad {
    
    private int codigo;
    private String nombre;
    private String cargo;
    private String area;
    private Date inicio;
    private Date fin;
    
    /** Creates a new instance of PersonalMaternidad */
    public PersonalMaternidad() {
    }
    
    public PersonalMaternidad(int codigo, String nombre, String cargo, String area, Date inicio, Date fin){
        this.codigo = codigo;
        this.nombre = nombre;
        this.cargo = cargo;
        this.area = area;
        this.inicio = inicio;
        this.fin = fin;
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
    
    public Date getInicio() {
        return inicio;
    }
    
    public void setInicio(Date inicio) {
        this.inicio = inicio;
    }
    
    public Date getFin() {
        return fin;
    }
    
    public void setFin(Date fin) {
        this.fin = fin;
    }
    
}
