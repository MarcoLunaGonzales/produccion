/*
 * Marcado.java
 *
 * Created on 4 de noviembre de 2010, 11:53 AM
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
public class Marcado {
    
    private Date fecha;
    private String hora;
    private int estado;
    private int codigo;
    
    public Marcado(int codigo, Date fecha, String hora, int estado){
        this.setCodigo(codigo);
        this.fecha = fecha;
        this.hora = hora;
        this.estado = estado;
    }
    /** Creates a new instance of Marcado */
    public Marcado() {
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public String getHora() {
        return hora;
    }
    
    public void setHora(String hora) {
        this.hora = hora;
    }
    
    public int getEstado() {
        return estado;
    }
    
    public void setEstado(int estado) {
        this.estado = estado;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public String getNumeroCodigo(){
        return "" + this.codigo;
    }
    
}
