/*
 * PersonalPlanilla.java
 *
 * Created on 19 de noviembre de 2010, 04:02 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import com.cofar.util.TimeFunction;
import java.util.List;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalPlanilla {
    
    private int codigo;
    private String nombreCompleto;
    private String cargo;
    private String nombreArea;
    private List<AsistenciaPlanilla> asistencia;
    private int sexo;
    private int division;
    private boolean extras;
    private boolean confianza;
    private int minutosTrabajado;
    private int minutosLaboral;
    private int minutosPagable;
    private int minutosNocturno1;
    private int minutosNocturno2;
    private int minutosExtra;
    private int minutosFaltante;
    private int minutosSabado;
    private int minutosDomingo;
    private int minutosDescuento;
    
    
    /** Creates a new instance of PersonalPlanilla */
    public PersonalPlanilla(int codigo, String nombreCompleto, String cargo, String nombreArea, int sexo, int division, int extras, int confianza) {
        this.codigo = codigo;
        this.nombreCompleto = nombreCompleto;
        this.cargo = cargo;
        this.nombreArea = nombreArea;
        this.sexo = sexo;
        this.division = division;
        this.extras = (extras==0? false: true);
        this.confianza = (confianza==1? true: false);
    }
    
    public PersonalPlanilla(int codigo, String nombreCompleto, String cargo, String nombreArea, int sexo, int division, boolean extras, boolean confianza, List<AsistenciaPlanilla> asistencia) {
        this.codigo = codigo;
        this.nombreCompleto = nombreCompleto;
        this.cargo = cargo;
        this.nombreArea = nombreArea;
        this.asistencia = asistencia;
        this.sexo = sexo;
        this.division = division;
        this.extras = extras;
        this.confianza = confianza;
        this.asistencia = asistencia;
        if(this.asistencia!=null){
            int trabajado = 0;
            int pagable = 0;
            int laboral = 0;
            int nocturno1 = 0;
            int nocturno2 = 0;
            int minutos_sabado = 0;
            int minutos_domingo = 0;
            int minutos_descuento = 0;
            if(this.asistencia!=null){
                for(AsistenciaPlanilla a: this.asistencia){
                    laboral += a.getMinutosLaboral();
                    trabajado += a.getMinutosTrabajado();
                    pagable += a.getMinutosComputable();
                    minutos_descuento += a.getMinutosDescuento();
                    nocturno1 = nocturno1 + (a.getMinutosPrimerTurno() - a.getMinutosPrimerTurno()% 30);
                    nocturno2 = nocturno2 + (a.getMinutosSegundoTurno() - a.getMinutosSegundoTurno() % 30);
                    DateTime temp_fecha = new DateTime(a.getFecha());
                    if(temp_fecha.getDayOfWeek()==6){
                        minutos_sabado += 180;
                    }
                    if(temp_fecha.getDayOfWeek()==7){
                        minutos_domingo = minutos_domingo + (a.getMinutosTrabajado() - (a.getMinutosTrabajado() % 30));
                    }
                }
            }
            this.minutosTrabajado = trabajado;
            this.minutosLaboral = laboral;
            this.minutosPagable = pagable;
            this.minutosNocturno1 = nocturno1;
            this.minutosNocturno2 = nocturno2;
            this.minutosSabado = minutos_sabado;
            this.minutosDomingo = minutos_domingo;
            this.minutosDescuento = minutos_descuento;
        }
    }
    
    public void setAsistencia(List<AsistenciaPlanilla> asistencia) {
        this.asistencia = asistencia;
    }
    
    public void actualizarDatos() {
        
    }
    
    public int totalMinutosTrabajados(){
        return this.minutosTrabajado;
    }
    
    public int totalMinutosLaboral(){
        return this.minutosLaboral;
    }
    
    public int totalMinutosPagable(){
        return this.minutosPagable;
    }
    
    public int totalMinutosExtra(){
        if(this.extras||!(this.confianza)){
            int diferencia = this.minutosPagable - this.minutosLaboral;
            if((this.division<3)&&(this.sexo==1)){
                diferencia = diferencia - this.minutosSabado;
            }
            return (diferencia>0? diferencia: 0);
        }else{
            return 0;
        }
    }
    
    public int totalMinutosPrimerNocturno(){
        if(this.extras){
            return this.minutosNocturno1;
        }else{
            return 0;
        }
        
    }
    
    public int totalMinutosSegundoNocturno(){
        if(this.extras){
            return this.minutosNocturno2;
        }else{
            return 0;
        }
    }
    
    public int totalMinutosFaltante(){
        int diferencia = 0;
        if(!this.confianza){
            diferencia = this.minutosLaboral - this.minutosTrabajado;
        }
        return (diferencia>0? diferencia: 0);
    }
    
    public String getTotalTiempoExtra(){
        return (TimeFunction.convierteHorasMinutos(this.totalMinutosExtra()));
    }
    
    public String getTotalTiempoTrabajado(){
        return (TimeFunction.convierteHorasMinutos(this.totalMinutosTrabajados()));
    }
    
    public String getTotalTiempoPagable(){
        return (TimeFunction.convierteHorasMinutos(this.totalMinutosPagable()));
    }
    
    public String getTotalTiempoLaboral(){
        return (TimeFunction.convierteHorasMinutos(this.totalMinutosLaboral()));
    }
    
    public String getTotalTiempoFaltante(){
        return (TimeFunction.convierteHorasMinutos(this.totalMinutosFaltante()));
    }
    
    public String getTotalTiempoPrimerTurno(){
        return (TimeFunction.convierteHorasMinutos(this.totalMinutosPrimerNocturno()));
    }
    
    public String getTotalTiempoSegundoTurno(){
        return (TimeFunction.convierteHorasMinutos(this.totalMinutosSegundoNocturno()));
    }
    
    public String getTotalTiempoDomingos(){
        return (TimeFunction.convierteHorasMinutos(this.minutosDomingo));
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public String getNombreCompleto() {
        return nombreCompleto;
    }
    
    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }
    
    public String getCargo() {
        return cargo;
    }
    
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }
    
    public String getNombreArea() {
        return nombreArea;
    }
    
    public void setNombreArea(String nombreArea) {
        this.nombreArea = nombreArea;
    }
    
    public List<AsistenciaPlanilla> getAsistencia() {
        return asistencia;
    }
    
    public int getSexo() {
        return sexo;
    }
    
    public void setSexo(int sexo) {
        this.sexo = sexo;
    }
    
    public int getDivision() {
        return division;
    }
    
    public void setDivision(int division) {
        this.division = division;
    }
    
    public boolean getExtras() {
        return extras;
    }
    
    public void setExtras(boolean extras) {
        this.extras = extras;
    }
    
    public int getMinutosTrabajado() {
        return minutosTrabajado;
    }
    
    public void setMinutosTrabajado(int minutosTrabajado) {
        this.minutosTrabajado = minutosTrabajado;
    }
    
    public int getMinutosLaboral() {
        return minutosLaboral;
    }
    
    public void setMinutosLaboral(int minutosLaboral) {
        this.minutosLaboral = minutosLaboral;
    }
    
    public int getMinutosPagable() {
        return minutosPagable;
    }
    
    public void setMinutosPagable(int minutosPagable) {
        this.minutosPagable = minutosPagable;
    }
    
    public int getMinutosNocturno1() {
        return minutosNocturno1;
    }
    
    public void setMinutosNocturno1(int minutosNocturno1) {
        this.minutosNocturno1 = minutosNocturno1;
    }
    
    public int getMinutosNocturno2() {
        return minutosNocturno2;
    }
    
    public void setMinutosNocturno2(int minutosNocturno2) {
        this.minutosNocturno2 = minutosNocturno2;
    }
    
    public int getMinutosExtra() {
        return minutosExtra;
    }
    
    public void setMinutosExtra(int minutosExtra) {
        this.minutosExtra = minutosExtra;
    }
    
    public int getMinutosFaltante() {
        return minutosFaltante;
    }
    
    public void setMinutosFaltante(int minutosFaltante) {
        this.minutosFaltante = minutosFaltante;
    }
    
    public int getMinutosDomingo() {
        return minutosDomingo;
    }
    
    public void setMinutosDomingo(int minutosDomingo) {
        this.minutosDomingo = minutosDomingo;
    }
    
    public boolean isConfianza() {
        return confianza;
    }
    
    public void setConfianza(boolean confianza) {
        this.confianza = confianza;
    }
    
    public int getMinutosDescuento() {
        return minutosDescuento;
    }
    
    public void setMinutosDescuento(int minutosDescuento) {
        this.minutosDescuento = minutosDescuento;
    }
    
    
}
