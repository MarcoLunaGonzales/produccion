/*
 * DotacionGrupo.java
 *
 * Created on 10 de enero de 2011, 02:47 PM
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
public class DotacionGrupo {
    
    private int codigo;
    private double prestamo;
    private int meses;
    private String inicio;
    private String gestion;
    private List<PersonalDotacion> empleados;
    
    private double totalPagado;
    private double totalRestante;
    private double totalPrestamo;
    
    /** Creates a new instance of DotacionGrupo */
    public DotacionGrupo(int codigo, double prestamo, int meses, String inicio, String gestion) {
        this.codigo = codigo;
        this.prestamo = prestamo;
        this.meses = meses;
        this.inicio = inicio;
        this.gestion = gestion;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public double getPrestamo() {
        return prestamo;
    }
    
    public void setPrestamo(double prestamo) {
        this.prestamo = prestamo;
    }
    
    public int getMeses() {
        return meses;
    }
    
    public void setMeses(int meses) {
        this.meses = meses;
    }
    
    public String getInicio() {
        return inicio;
    }
    
    public void setInicio(String inicio) {
        this.inicio = inicio;
    }
    
    public String getGestion() {
        return gestion;
    }
    
    public void setGestion(String gestion) {
        this.gestion = gestion;
    }
    
    public List<PersonalDotacion> getEmpleados() {
        return empleados;
    }
    
    public void setEmpleados(List<PersonalDotacion> empleados) {
        this.empleados = empleados;
    }
    
    public double getTotalPagado() {
        return totalPagado;
    }
    
    public void setTotalPagado(double totalPagado) {
        this.totalPagado = totalPagado;
    }
    
    public double getTotalRestante() {
        return totalRestante;
    }
    
    public void setTotalRestante(double totalRestante) {
        this.totalRestante = totalRestante;
    }
    
    public double getTotalPrestamo() {
        return totalPrestamo;
    }
    
    public void setTotalPrestamo(double totalPrestamo) {
        this.totalPrestamo = totalPrestamo;
    }
}
