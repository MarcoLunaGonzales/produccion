/*
 * DotacionDetalle.java
 *
 * Created on 10 de enero de 2011, 09:20 AM
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
public class DotacionDetalle {
    
    private int codigo;
    private String nombre;
    private String gestion;
    private List<PersonalDotacion> empleados;
    
    /** Creates a new instance of DotacionDetalle */
    public DotacionDetalle(int codigo, String nombre) {
        this.codigo = codigo;
        this.nombre = nombre;
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
    
    public String getGestion() {
        return gestion;
    }
    
    public void setGestion(String gestion) {
        this.gestion = gestion;
    }
    
    public double getTotalRestante(){
        double restante = 0;
        for(PersonalDotacion personal: this.empleados){
            restante += personal.getRestante();
        }
        return restante;
    }
    
    public double getTotalPagado(){
        double pagado = 0;
        for(PersonalDotacion personal: this.empleados){
            pagado += personal.getPagado();
        }
        return pagado;
    }
    
    public double getTotalPrestamo(){
        double totalPrestamo = 0;
        for(PersonalDotacion personal: this.empleados){
            totalPrestamo += personal.getPrestamo();
        }
        return totalPrestamo;
    }

    public List<PersonalDotacion> getEmpleados() {
        return empleados;
    }

    public void setEmpleados(List<PersonalDotacion> empleados) {
        this.empleados = empleados;
    }
}
