/*
 * Afp.java
 *
 * Created on 7 de marzo de 2008, 16:32
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Gabriela Quelali
 * @company COFAR
 */
public class Quinquenios extends AbstractBean{
    
    private int codigo;
    private String nombre;
    private Date fechaCumpleQuinquenio;
    private Date fechaPagoQuinquenio;
    private double montoPagoQuinquenio;
    private String obsQuinquenio;
    
    public Quinquenios(int codigo, String nombre, Date fechaCumpleQuinquenio, Date fechaPagoQuinquenio, double monto, String observacion ){
        this.codigo = codigo;
        this.nombre = nombre;
        this.fechaCumpleQuinquenio = fechaCumpleQuinquenio;
        this.fechaPagoQuinquenio = fechaPagoQuinquenio;
        this.montoPagoQuinquenio = monto;
        this.obsQuinquenio = observacion;
    }
        
    public Quinquenios() {
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Date getFechaCumpleQuinquenio() {
        return fechaCumpleQuinquenio;
    }

    public void setFechaCumpleQuinquenio(Date fechaCumpleQuinquenio) {
        this.fechaCumpleQuinquenio = fechaCumpleQuinquenio;
    }

    public Date getFechaPagoQuinquenio() {
        return fechaPagoQuinquenio;
    }

    public void setFechaPagoQuinquenio(Date fechaPagoQuinquenio) {
        this.fechaPagoQuinquenio = fechaPagoQuinquenio;
    }

    public double getMontoPagoQuinquenio() {
        return montoPagoQuinquenio;
    }

    public void setMontoPagoQuinquenio(double montoPagoQuinquenio) {
        this.montoPagoQuinquenio = montoPagoQuinquenio;
    }

    public String getObsQuinquenio() {
        return obsQuinquenio;
    }

    public void setObsQuinquenio(String obsQuinquenio) {
        this.obsQuinquenio = obsQuinquenio;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
}
