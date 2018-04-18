/*
 * PermisoTurno.java
 *
 * Created on 11 de noviembre de 2010, 02:50 PM
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
public class PermisoTurno {
    
    private int codigo;
    private int boleta;
    private int personal;
    private Date fecha;
    private String tipo;
    private int turno;
    private int modalidad;
    private String observacion;
    
    
    public PermisoTurno(int codigo, int boleta, int personal, Date fecha, String tipo, int turno, String observacion, int modalidad){
        this.codigo = codigo;
        this.personal = personal;
        this.fecha = fecha;
        this.tipo = tipo;
        this.turno = turno;
        this.observacion = observacion;
        this.boleta = boleta;
        this.setModalidad(modalidad);
    }
    
    public String getNombreTurno(){
        String resultado = "";
        switch(turno){
            case 1:
                resultado = "PRIMERA MEDIA JORNADA";
                break;
            case 2:
                resultado = "SEGUNDA MEDIA JORNADA";
                break;
            case 3:
                resultado = "JORNADA COMPLETA";
                break;
        }
        return resultado;
    }
    
    public String getNombreModalidad(){
        String resultado = "";
        switch(this.modalidad){
            case 1:
                resultado = "A REEMPLAZO";
                break;
            case 2:
                resultado = "CON DESCUENTO";
                break;
            case 3:
                resultado = "SIN REEMPLAZO NI DESCUENTO";
                break;
        }
        return resultado;
    }
    
    /** Creates a new instance of PermisoTurno */
    public PermisoTurno() {
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
    
    public int getTurno() {
        return turno;
    }
    
    public void setTurno(int turno) {
        this.turno = turno;
    }
    
    public String getObservacion() {
        return observacion;
    }
    
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
    
    public int getModalidad() {
        return modalidad;
    }
    
    public void setModalidad(int modalidad) {
        this.modalidad = modalidad;
    }
    
    public int getBoleta() {
        return boleta;
    }
    
    public void setBoleta(int boleta) {
        this.boleta = boleta;
    }
    
}
