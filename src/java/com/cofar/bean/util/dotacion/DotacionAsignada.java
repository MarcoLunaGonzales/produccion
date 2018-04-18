/*
 * DotacionAsignada.java
 *
 * Created on 14 de enero de 2011, 04:19 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.dotacion;

/**
 *
 * @author Ismael Juchazara
 */
public class DotacionAsignada {
    
    private int codigo;
    private int personal;
    private String dotacion;
    private double monto;
    private String gestion;
    private String inicio;
    private double pagado;
    private int meses;
    private int cuotas;
    private double saldo;
    private DotacionFinalizacion finalizacion;
    
    public DotacionAsignada(int codigo, int personal, String dotacion, double monto, String gestion, String inicio, double pagado, int meses, int cuotas, DotacionFinalizacion finalizacion){
        this.personal = personal;
        this.codigo = codigo;
        this.dotacion = dotacion;
        this.monto = monto;
        this.gestion = gestion;
        this.inicio = inicio;
        this.pagado = pagado;
        this.meses = meses;
        this.cuotas = cuotas;
        this.saldo = monto - pagado;
        this.finalizacion = finalizacion;
    }
    
    
    /** Creates a new instance of DotacionAsignada */
    public DotacionAsignada() {
    }
    
    public String getDotacion() {
        return dotacion;
    }
    
    public void setDotacion(String dotacion) {
        this.dotacion = dotacion;
    }
    
    public double getMonto() {
        return monto;
    }
    
    public void setMonto(double monto) {
        this.monto = monto;
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
    
    public double getPagado() {
        return pagado;
    }
    
    public double getPorcentaje() {
        return ((this.pagado/this.monto)*100);
    }
    
    public void setPagado(double pagado) {
        this.pagado = pagado;
    }
    
    public int getMeses() {
        return meses;
    }
    
    public void setMeses(int meses) {
        this.meses = meses;
    }
    
    public int getCuotas() {
        return cuotas;
    }
    
    public void setCuotas(int cuotas) {
        this.cuotas = cuotas;
    }
    
    public double getSaldo() {
        return saldo;
    }
    
    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public int getPersonal() {
        return personal;
    }
    
    public void setPersonal(int personal) {
        this.personal = personal;
    }
    
    public DotacionFinalizacion getFinalizacion() {
        return finalizacion;
    }
    
    public void setFinalizacion(DotacionFinalizacion finalizacion) {
        this.finalizacion = finalizacion;
    }
    
}
