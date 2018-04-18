/*
 * ControlMarcado.java
 *
 * Created on 12 de noviembre de 2010, 05:23 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Ismael Juchazara
 */
public class ControlMarcado {
    
    private Date fecha;
    private Marcado primero;
    private Marcado segundo;
    private Marcado tercero;
    private Marcado cuarto;
    private Marcado quinto;
    private Marcado sexto;
    
    /** Creates a new instance of ControlMarcado */
    public ControlMarcado(Date fecha) {
        this.setFecha(fecha);
    }
    
    public ControlMarcado() {
    }
    
    public String getFechaMarcado(){
        SimpleDateFormat formateo=new SimpleDateFormat("yyyy/MM/dd");
        return(formateo.format(this.fecha));
    }
    
    public Marcado getPrimero() {
        return primero;
    }
    
    public void setPrimero(Marcado primero) {
        this.primero = primero;
    }
    
    public Marcado getSegundo() {
        return segundo;
    }
    
    public void setSegundo(Marcado segundo) {
        this.segundo = segundo;
    }
    
    public Marcado getTercero() {
        return tercero;
    }
    
    public void setTercero(Marcado tercero) {
        this.tercero = tercero;
    }
    
    public Marcado getCuarto() {
        return cuarto;
    }
    
    public void setCuarto(Marcado cuarto) {
        this.cuarto = cuarto;
    }
    
    public Marcado getQuinto() {
        return quinto;
    }
    
    public void setQuinto(Marcado quinto) {
        this.quinto = quinto;
    }
    
    public Marcado getSexto() {
        return sexto;
    }
    
    public void setSexto(Marcado sexto) {
        this.sexto = sexto;
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
}
