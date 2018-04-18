/*
 * ControlAsistencia.java
 *
 * Created on 27 de octubre de 2010, 03:34 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import java.util.Date;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class ControlAsistencia {
    
    private int codigoPersonal;
    private Date fecha;
    private DateTime primerIngreso;
    private DateTime primerSalida;
    private DateTime segundoIngreso;
    private DateTime segundoSalida;
    private int tipoVacacion;
    
    /** Creates a new instance of ControlAsistencia */
    public ControlAsistencia(int codigo, Date fecha, DateTime pIngreso, DateTime pSalida, DateTime sIngreso, DateTime sSalida, int vacacion) {
        this.codigoPersonal = codigo;
        this.fecha = fecha;
        this.primerIngreso = pIngreso;
        this.primerSalida = pSalida;
        this.segundoIngreso = sIngreso;
        this.segundoSalida = sSalida;
        this.tipoVacacion = vacacion;
    }
    
    public int getCodigoPersonal() {
        return codigoPersonal;
    }
    
    public void setCodigoPersonal(int codigoPersonal) {
        this.codigoPersonal = codigoPersonal;
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public DateTime getPrimerIngreso() {
        return primerIngreso;
    }
    
    public void setPrimerIngreso(DateTime primerIngreso) {
        this.primerIngreso = primerIngreso;
    }
    
    public DateTime getPrimerSalida() {
        return primerSalida;
    }
    
    public void setPrimerSalida(DateTime primerSalida) {
        this.primerSalida = primerSalida;
    }
    
    public DateTime getSegundoIngreso() {
        return segundoIngreso;
    }
    
    public void setSegundoIngreso(DateTime segundoIngreso) {
        this.segundoIngreso = segundoIngreso;
    }
    
    public DateTime getSegundoSalida() {
        return segundoSalida;
    }
    
    public void setSegundoSalida(DateTime segundoSalida) {
        this.segundoSalida = segundoSalida;
    }
    
    public int getTipoVacacion() {
        return tipoVacacion;
    }
    
    public void setTipoVacacion(int tipoVacacion) {
        this.tipoVacacion = tipoVacacion;
    }
    
}
