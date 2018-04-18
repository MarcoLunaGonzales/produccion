/*
 * Permiso.java
 *
 * Created on 8 de noviembre de 2010, 02:57 PM
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
public class Permiso {
    
    private int codigo;
    private int personal;
    private Date fecha;
    private String tipo;
    private String hora_inicio;
    private String hora_fin;
    private String observacion;
    private int descuento;
    private int boleta;
    
    /** Creates a new instance of Permiso */
    public Permiso() {
    }
    
    public Permiso(int codigo, int personal, Date fecha, String tipo, String hora_inicio, String hora_fin, String observacion, int modalidad, int boleta){
        this.codigo = codigo;
        this.personal = personal;
        this.fecha = fecha;
        this.tipo = tipo;
        this.hora_inicio = hora_inicio;
        this.hora_fin = hora_fin;
        this.observacion = observacion;
        this.descuento = modalidad;
        this.boleta = boleta;
    }
    
    public String getNombreModalidad(){
        String resultado = "";
        switch(this.descuento){
            case 1:
                resultado = "A REEMPLAZO";
                break;
            case 2:
                resultado = "CON DESCUENTO";
                break;
            case 3:
                resultado = "SIN REEMPLAZO NI DESCUENTO";
                break;
            case 4:
                resultado = "A REEMPLAZO";
                break;
        }
        return resultado;
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
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public String getTipo() {
        return tipo;
    }
    
    public void setTipo(String tipo) {
        this.tipo = tipo;
    }
    
    public String getHora_inicio() {
        return hora_inicio;
    }
    
    public void setHora_inicio(String hora_inicio) {
        this.hora_inicio = hora_inicio;
    }
    
    public String getHora_fin() {
        return hora_fin;
    }
    
    public void setHora_fin(String hora_fin) {
        this.hora_fin = hora_fin;
    }
    
    public String getObservacion() {
        return observacion;
    }
    
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
    
    public int getDescuento() {
        return descuento;
    }
    
    public void setDescuento(int descuento) {
        this.descuento = descuento;
    }

    public int getBoleta() {
        return boleta;
    }

    public void setBoleta(int boleta) {
        this.boleta = boleta;
    }
    
}
