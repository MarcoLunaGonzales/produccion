/*
 * HorarioPermiso.java
 *
 * Created on 7 de febrero de 2011, 12:02 PM
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
public class HorarioPermiso {
    
    private int codigo;
    private int personal;
    private String nombre;
    private String cargo;
    private Date fecha;
    private String tipo;
    private String hora_inicio;
    private String hora_fin;
    private String observacion;
    private int descuento;
    private int boleta;
    
    /** Creates a new instance of HorarioPermiso */
    public HorarioPermiso(int codigo, int personal, String nombre, String cargo, Date fecha, String tipo, String hora_inicio, String hora_fin, String observacion, int modalidad, int boleta) {
        this.codigo = codigo;
        this.personal = personal;
        this.fecha = fecha;
        this.tipo = tipo;
        this.hora_inicio = hora_inicio;
        this.hora_fin = hora_fin;
        this.observacion = observacion;
        this.descuento = modalidad;
        this.boleta = boleta;
        this.nombre = nombre;
        this.cargo = cargo;
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
