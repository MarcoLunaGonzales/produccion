/*
 * PermisoFecha.java
 *
 * Created on 29 de noviembre de 2010, 10:16 AM
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
public class PermisoFecha {
    
    private int codigo;
    private int boleta;
    private int personal;
    private Date inicio;
    private Date fin;
    private String tipo;
    private int modalidad;
    private String observacion;
    
    
    public PermisoFecha(int codigo, int personal, Date inicio, Date fin, String observacion, String tipo, int modalidad, int boleta){
        this.codigo = codigo;
        this.personal = personal;
        this.inicio = inicio;
        this.fin = fin;
        this.tipo = tipo;
        this.observacion = observacion;
        this.boleta = boleta;
        this.modalidad = modalidad;
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
    
    /** Creates a new instance of PermisoFecha */
    public PermisoFecha() {
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
    
    public Date getInicio() {
        return inicio;
    }
    
    public void setInicio(Date inicio) {
        this.inicio = inicio;
    }
    
    public Date getFin() {
        return fin;
    }
    
    public void setFin(Date fin) {
        this.fin = fin;
    }
    
    public String getTipo() {
        return tipo;
    }
    
    public void setTipo(String tipo) {
        this.tipo = tipo;
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
    
}
