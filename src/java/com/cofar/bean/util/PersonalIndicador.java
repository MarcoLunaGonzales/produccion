/*
 * PersonalIndicador.java
 *
 * Created on 9 de diciembre de 2010, 06:51 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalIndicador {
    
    private int codigo;
    private String nombreCompleto;
    private String cargo;
    private String nombreArea;
    private double diasVacacion;
    private double diasFalta;
    private double diasPermiso;
    private double diasFeriado;
    private double diasTrabajado;
    private String inicioContrato;
    private String conclusionContrato;
    
    /** Creates a new instance of PersonalIndicador */
    public PersonalIndicador(int codigo, String nombre, String cargo, String area, double dias, double vacacion, double falta, double permiso, double feriado, String obs1, String obs2) {
        this.codigo = codigo;
        this.nombreCompleto = nombre;
        this.cargo = cargo;
        this.diasTrabajado = dias;
        this.diasVacacion = vacacion;
        this.diasFeriado = feriado;
        this.diasFalta = falta;
        this.nombreArea = area;
        this.diasPermiso = permiso;
        this.inicioContrato = obs1;
        this.conclusionContrato = obs2;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public String getNombreCompleto() {
        return nombreCompleto;
    }
    
    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }
    
    public String getCargo() {
        return cargo;
    }
    
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }
    
    public String getNombreArea() {
        return nombreArea;
    }
    
    public void setNombreArea(String nombreArea) {
        this.nombreArea = nombreArea;
    }
    
    public double getDiasVacacion() {
        return diasVacacion;
    }
    
    public void setDiasVacacion(double diasVacacion) {
        this.diasVacacion = diasVacacion;
    }
    
    public double getDiasFalta() {
        return diasFalta;
    }
    
    public void setDiasFalta(double diasFalta) {
        this.diasFalta = diasFalta;
    }
    
    public double getDiasPermiso() {
        return diasPermiso;
    }
    
    public void setDiasPermiso(double diasPermiso) {
        this.diasPermiso = diasPermiso;
    }
    
    public double getDiasFeriado() {
        return diasFeriado;
    }
    
    public void setDiasFeriado(double diasFeriado) {
        this.diasFeriado = diasFeriado;
    }
    
    public String getInicioContrato() {
        return inicioContrato;
    }
    
    public void setInicioContrato(String inicioContrato) {
        this.inicioContrato = inicioContrato;
    }
    
    public String getConclusionContrato() {
        return conclusionContrato;
    }
    
    public void setConclusionContrato(String conclusionContrato) {
        this.conclusionContrato = conclusionContrato;
    }
    
    public double getDiasTrabajado() {
        return diasTrabajado;
    }
    
    public void setDiasTrabajado(double diasTrabajado) {
        this.diasTrabajado = diasTrabajado;
    }
    
    
    
}
