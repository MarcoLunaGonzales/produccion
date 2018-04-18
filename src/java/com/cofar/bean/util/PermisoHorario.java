/*
 * PermisoHorario.java
 *
 * Created on 26 de noviembre de 2010, 11:28 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import com.cofar.util.StyleFunction;
import com.cofar.util.TimeFunction;
import java.text.SimpleDateFormat;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class PermisoHorario {
    
    private DateTime inicio;
    private DateTime fin;
    private int tipo;
    
    /** Creates a new instance of PermisoHorario */
    public PermisoHorario() {
    }
    
    public PermisoHorario(DateTime inicio, DateTime fin, int tipo){
        this.inicio = inicio;
        this.fin = fin;
        this.tipo = tipo;
    }
    
    public int getMinutos(){
        if((this.inicio!=null)&&(this.fin!=null)){
            return (TimeFunction.diferenciaTiempo(this.inicio, this.fin));
        }else{
            return 0;
        }
    }
    
    public String getNombreTipo(){
        return (StyleFunction.estiloJustificacion(this.tipo));
    }
    
    public String getInicio() {
        SimpleDateFormat formateo = new SimpleDateFormat("HH:mm");
        return formateo.format(inicio.toDate());
    }
    
    public DateTime getDateInicio(){
        return this.inicio;
    }
    
    public DateTime getDateFin(){
        return this.fin;
    }
    
    public void setInicio(DateTime inicio) {
        this.inicio = inicio;
    }
    
    public String getFin() {
        SimpleDateFormat formateo = new SimpleDateFormat("HH:mm");
        return formateo.format(fin.toDate());
    }
    
    public void setFin(DateTime fin) {
        this.fin = fin;
    }
    
    public int getTipo() {
        return tipo;
    }
    
    public void setTipo(int tipo) {
        this.tipo = tipo;
    }
    
}
