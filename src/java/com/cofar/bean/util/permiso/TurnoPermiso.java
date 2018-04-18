/*
 * TurnoPermiso.java
 *
 * Created on 7 de febrero de 2011, 02:52 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.permiso;

import java.util.Date;

/**
 *
 * @author Ismael Juchazara
 */
public class TurnoPermiso {
    private int codigo;
    private int boleta;
    private int personal;
    private Date fecha;
    private String tipo;
    private int turno;
    private int modalidad;
    private String observacion;
    private String nombre;
    
    /** Creates a new instance of TurnoPermiso */
    public TurnoPermiso(int codigo, int boleta, int personal, String nombre, Date fecha, String tipo, int turno, String observacion, int modalidad){
        this.codigo = codigo;
        this.personal = personal;
        this.fecha = fecha;
        this.tipo = tipo;
        this.turno = turno;
        this.observacion = observacion;
        this.boleta = boleta;
        this.modalidad = modalidad;
        this.nombre = nombre;
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
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public int getBoleta() {
        return boleta;
    }
    
    public void setBoleta(int boleta) {
        this.boleta = boleta;
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
    
    public int getModalidad() {
        return modalidad;
    }
    
    public void setModalidad(int modalidad) {
        this.modalidad = modalidad;
    }
    
    public String getObservacion() {
        return observacion;
    }
    
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
}
