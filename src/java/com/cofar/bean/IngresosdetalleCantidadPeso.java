/*
 * IngresosdetalleCantidadPeso.java
 *
 * Created on 26 de septiembre de 2009, 06:08 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Wilmer
 */
public class IngresosdetalleCantidadPeso {
    
    /** Creates a new instance of IngresosdetalleCantidadPeso */

    private int codIngresoDetalleCantidadPeso=0;
    private int codIngresosVentas;
    private int codPresentacion;
    private float cantidad;
    private float cantidadConfirmada;
    private Double peso;
    private float pesoConfirmado;
    private TiposEnvase tiposEnvase = new TiposEnvase();
    private int codEnvase;
    private String nombreEnvase;
    private int codigo;
    private int nroCintaSeguridad1=0;
    private int nroCintaSeguridad2=0;

    public int getCodIngresoDetalleCantidadPeso() {
        return codIngresoDetalleCantidadPeso;
    }

    public void setCodIngresoDetalleCantidadPeso(int codIngresoDetalleCantidadPeso) {
        this.codIngresoDetalleCantidadPeso = codIngresoDetalleCantidadPeso;
    }
    
    public IngresosdetalleCantidadPeso() {
    }

    public int getCodIngresosVentas() {
        return codIngresosVentas;
    }

    public void setCodIngresosVentas(int codIngresosVentas) {
        this.codIngresosVentas = codIngresosVentas;
    }

    public int getCodPresentacion() {
        return codPresentacion;
    }

    public void setCodPresentacion(int codPresentacion) {
        this.codPresentacion = codPresentacion;
    }

    public Double getPeso() {
        return peso;
    }

    public void setPeso(Double peso) {
        this.peso = peso;
    }


    

    public float getPesoConfirmado() {
        return pesoConfirmado;
    }

    public void setPesoConfirmado(float pesoConfirmado) {
        this.pesoConfirmado = pesoConfirmado;
    }

    public int getCodEnvase() {
        return codEnvase;
    }

    public void setCodEnvase(int codEnvase) {
        this.codEnvase = codEnvase;
    }

    public String getNombreEnvase() {
        return nombreEnvase;
    }

    public void setNombreEnvase(String nombreEnvase) {
        this.nombreEnvase = nombreEnvase;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public float getCantidad() {
        return cantidad;
    }

    public void setCantidad(float cantidad) {
        this.cantidad = cantidad;
    }

    public float getCantidadConfirmada() {
        return cantidadConfirmada;
    }

    public void setCantidadConfirmada(float cantidadConfirmada) {
        this.cantidadConfirmada = cantidadConfirmada;
    }

    public TiposEnvase getTiposEnvase() {
        return tiposEnvase;
    }

    public void setTiposEnvase(TiposEnvase tiposEnvase) {
        this.tiposEnvase = tiposEnvase;
    }

    public int getNroCintaSeguridad1() {
        return nroCintaSeguridad1;
    }

    public void setNroCintaSeguridad1(int nroCintaSeguridad1) {
        this.nroCintaSeguridad1 = nroCintaSeguridad1;
    }

    public int getNroCintaSeguridad2() {
        return nroCintaSeguridad2;
    }

    public void setNroCintaSeguridad2(int nroCintaSeguridad2) {
        this.nroCintaSeguridad2 = nroCintaSeguridad2;
    }

   
    
}
