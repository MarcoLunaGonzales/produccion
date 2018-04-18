/*
 * PersonalDotacion.java
 *
 * Created on 10 de enero de 2011, 09:39 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.dotacion;

import com.cofar.util.StyleFunction;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalDotacion {
    
    private int codigo;
    private String nombre;
    private String cargo;
    private String area;
    private double prestamo;
    private double pagado;
    private double restante;
    private double porcentajePagado;
    private int cuotas;
    private String color;
    private boolean retirado;
    
    private String gestion;
    private String inicio;
    private int meses;
    
    /** Creates a new instance of PersonalDotacion */
    public PersonalDotacion(String gestion, String inicio, int meses, int codigo, String nombre, String cargo, String area, double pagado, double prestamo, int cuotas, boolean retirado) {
        this.gestion = gestion;
        this.inicio = inicio;
        this.meses = meses;
        this.prestamo = prestamo;
        this.codigo = codigo;
        this.nombre = nombre;
        this.cargo = cargo;
        this.area = area;
        this.pagado = pagado;
        this.restante = prestamo - pagado;
        this.porcentajePagado = (pagado*100)/prestamo;
        this.color = StyleFunction.estiloRestante(this.restante>0);
        this.cuotas = cuotas;
        this.retirado = retirado;
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
    
    public double getPagado() {
        return pagado;
    }
    
    public void setPagado(double pagado) {
        this.pagado = pagado;
    }
    
    public double getPorcentajePagado() {
        return porcentajePagado;
    }
    
    public void setPorcentajePagado(double porcentajePagado) {
        this.porcentajePagado = porcentajePagado;
    }
    
    public double getRestante() {
        return restante;
    }
    
    public void setRestante(double restante) {
        this.restante = restante;
    }
    
    public String getColor(){
        return StyleFunction.estiloRestante(this.restante>0);
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public int getCuotas() {
        return cuotas;
    }
    
    public void setCuotas(int cuotas) {
        this.cuotas = cuotas;
    }
    
    public String getArea() {
        return area;
    }
    
    public void setArea(String area) {
        this.area = area;
    }
    
    public boolean isRetirado() {
        return retirado;
    }
    
    public void setRetirado(boolean retirado) {
        this.retirado = retirado;
    }
    
    public String getGestion() {
        return gestion;
    }
    
    public void setGestion(String gestion) {
        this.gestion = gestion;
    }
    
    public String getInicio() {
        return inicio;
    }
    
    public void setInicio(String inicio) {
        this.inicio = inicio;
    }
    
    public int getMeses() {
        return meses;
    }
    
    public void setMeses(int meses) {
        this.meses = meses;
    }
    
    public double getPrestamo() {
        return prestamo;
    }
    
    public void setPrestamo(double prestamo) {
        this.prestamo = prestamo;
    }
}
