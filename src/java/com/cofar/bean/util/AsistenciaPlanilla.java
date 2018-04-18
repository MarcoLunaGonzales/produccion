/*
 * AsistenciaPlanilla.java
 *
 * Created on 19 de noviembre de 2010, 02:47 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import com.cofar.util.StyleFunction;
import com.cofar.util.TimeFunction;
import java.util.Date;
import org.joda.time.DateTime;
import org.joda.time.Minutes;

/**
 *
 * @author Ismael Juchazara
 */
public class AsistenciaPlanilla {
    private String empleado;
    private String area;
    private String cargo;
    private Date fecha;
    private DateTime primerIngreso;
    private DateTime primerSalida;
    private DateTime segundoIngreso;
    private DateTime segundoSalida;
    private int minutosTrabajado;
    private int minutosLaboral;
    private int minutosComputable;
    private int minutosPrimerTurno;
    private int minutosSegundoTurno;
    private int minutosExtra;
    private int minutosFaltante;
    private int minutosDescuento;
    private int tipo;
    private int marcados;
    
    /** Creates a new instance of AsistenciaPlanilla */
    public AsistenciaPlanilla(String empleado, String cargo, String area, Date fecha, int trabajado, int laborable, int computable, int primerTurno, int segundoTurno, int extra, int faltante, DateTime pIngreso, DateTime pSalida, DateTime sIngreso, DateTime sSalida, int sexo, int division, int descuento) {
        this.empleado = empleado;
        this.area = area;
        this.cargo = cargo;
        this.fecha = fecha;
        this.primerIngreso = pIngreso;
        this.primerSalida = pSalida;
        this.segundoIngreso = sIngreso;
        this.segundoSalida = sSalida;
        this.marcados = 0;
        this.minutosTrabajado = trabajado;
        this.minutosLaboral = laborable;
        this.minutosComputable = computable;
        this.minutosPrimerTurno = primerTurno;
        this.minutosSegundoTurno = segundoTurno;
        this.minutosExtra = extra;
        this.minutosFaltante = faltante;
        this.minutosDescuento = descuento;
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public int getMinutosTrabajado() {
        return minutosTrabajado;
    }
    
    public String getTotalTiempoTrabajado(){
        return TimeFunction.convierteHorasMinutos(this.minutosTrabajado);
    }
    
    public void setMinutosTrabajado(int minutosTrabajado) {
        this.minutosTrabajado = minutosTrabajado;
    }
    
    public int getMinutosLaboral() {
        return minutosLaboral;
    }
    
    public String getTotalTiempoLaboral(){
        return TimeFunction.convierteHorasMinutos(this.minutosLaboral);
    }
    
    public void setMinutosLaboral(int minutosLaboral) {
        this.minutosLaboral = minutosLaboral;
    }
    
    public int getMinutosComputable() {
        return minutosComputable;
    }
    
    public String getTotalTiempoComputable(){
        return TimeFunction.convierteHorasMinutos(this.minutosComputable);
    }
    
    
    public void setMinutosComputable(int minutosComputable) {
        this.minutosComputable = minutosComputable;
    }
    
    public int getMinutosPrimerTurno() {
        return minutosPrimerTurno;
    }
    
    public String getTotalTiempoPrimerTurno(){
        return TimeFunction.convierteHorasMinutos(this.minutosPrimerTurno);
    }
    
    
    public void setMinutosPrimerTurno(int minutosPrimerTurno) {
        this.minutosPrimerTurno = minutosPrimerTurno;
    }
    
    public int getMinutosSegundoTurno() {
        return minutosSegundoTurno;
    }
    
    public String getTotalTiempoSegundoTurno(){
        return TimeFunction.convierteHorasMinutos(this.minutosSegundoTurno);
    }
    
    
    public void setMinutosSegundoTurno(int minutosSegundoTurno) {
        this.minutosSegundoTurno = minutosSegundoTurno;
    }
    
    public int getMinutosExtra() {
        return minutosExtra;
    }
    
    public String getTotalTiempoExtra(){
        return TimeFunction.convierteHorasMinutos(this.minutosExtra);
    }
    
    
    public void setMinutosExtra(int minutosExtra) {
        this.minutosExtra = minutosExtra;
    }
    
    public int getMinutosFaltante() {
        return minutosFaltante;
    }
    
    public String getTotalTiempoFaltante(){
        return TimeFunction.convierteHorasMinutos(this.minutosFaltante);
    }
    
    
    public void setMinutosFaltante(int minutosFaltante) {
        this.minutosFaltante = minutosFaltante;
    }
    
    public DateTime getPrimerIngreso() {
        return primerIngreso;
    }
    
    public Date getPrimerIngresoDate() {
        return (primerIngreso!=null? primerIngreso.toDate(): null);
    }
    
    public void setPrimerIngreso(DateTime primerIngreso) {
        this.primerIngreso = primerIngreso;
    }
    
    public DateTime getPrimerSalida() {
        return primerSalida;
    }
    
    public Date getPrimerSalidaDate() {
        return (primerSalida!=null? primerSalida.toDate(): null);
    }
    
    public void setPrimerSalida(DateTime primerSalida) {
        this.primerSalida = primerSalida;
    }
    
    public DateTime getSegundoIngreso() {
        return segundoIngreso;
    }
    
    public Date getSegundoIngresoDate() {
        return (segundoIngreso!=null? segundoIngreso.toDate(): null);
    }
    
    public void setSegundoIngreso(DateTime segundoIngreso) {
        this.segundoIngreso = segundoIngreso;
    }
    
    public DateTime getSegundoSalida() {
        return segundoSalida;
    }
    
    public Date getSegundoSalidaDate() {
        return (segundoSalida!=null? segundoSalida.toDate(): null);
    }
    
    public void setSegundoSalida(DateTime segundoSalida) {
        this.segundoSalida = segundoSalida;
    }
    
    public String getColor() {
        return (StyleFunction.estiloProblema(this.tipo));
    }
    
    public String getNombreTipo(){
        String resultado = "";
        switch(this.tipo){
            case 1:
                resultado = "+4";
                break;
            case 2:
                resultado = "0";
                break;
            case 3:
                resultado = "2";
                break;
            case 4:
                resultado = "2";
                break;
        }
        return resultado;
    }
    
    public String getEmpleado() {
        return empleado;
    }
    
    public void setEmpleado(String empleado) {
        this.empleado = empleado;
    }
    
    public String getCargo() {
        return cargo;
    }
    
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }
    
    public int getMinutosDescuento() {
        return minutosDescuento;
    }
    
    public void setMinutosDescuento(int minutosDescuento) {
        this.minutosDescuento = minutosDescuento;
    }
    
    public String getArea() {
        return area;
    }
    
    public void setArea(String area) {
        this.area = area;
    }
    
    public int getTipo() {
        return tipo;
    }
    
    public void setTipo(int tipo) {
        this.tipo = tipo;
    }
    
    public int getMarcados() {
        return marcados;
    }
    
    public void setMarcados(int marcados) {
        this.marcados = marcados;
    }
}
