/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca
 */
public class SeguimientoProgramaProduccion extends AbstractBean{
    
    /** Creates a new instance of LineaMKT */
    
    private String codSeguimientoPrograma="";
    private double horasMaquina=0;
    private double horasHombre=0;
    private Date fechaInicio=new Date();
    private Date fechaFinal=new Date();
    private String horaInicio="";
    private String horaFinal="";
    private Boolean checked=new Boolean(false);
    private ProgramaProduccion programaProduccion=new ProgramaProduccion();
    private ActividadesProduccion actividadesProduccion=new ActividadesProduccion();
    private EstadoReferencial estadoReferencial=new EstadoReferencial();
    private Maquinaria maquinaria = new Maquinaria();
    private ActividadesFormulaMaestra actividadesFormulaMaestra = new ActividadesFormulaMaestra();
    private List maquinariaList = new ArrayList();
    private Boolean checkedMaquinaria = new Boolean(false);
    MaquinariaActividadesFormula maquinariaActividadesFormula = new MaquinariaActividadesFormula();
    List seguimientoProgramaProduccionPersonalList = new ArrayList();
    boolean habilitado = true;
    
    public String getCodSeguimientoPrograma() {
        return codSeguimientoPrograma;
    }
    
    public void setCodSeguimientoPrograma(String codSeguimientoPrograma) {
        this.codSeguimientoPrograma = codSeguimientoPrograma;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public double getHorasHombre() {
        return horasHombre;
    }

    public void setHorasHombre(double horasHombre) {
        this.horasHombre = horasHombre;
    }

    public double getHorasMaquina() {
        return horasMaquina;
    }

    public void setHorasMaquina(double horasMaquina) {
        this.horasMaquina = horasMaquina;
    }
    
    
    public Boolean getChecked() {
        return checked;
    }
    
    public void setChecked(Boolean checked) {
        this.checked = checked;
    }
    
    
    
    public ActividadesProduccion getActividadesProduccion() {
        return actividadesProduccion;
    }
    
    public void setActividadesProduccion(ActividadesProduccion actividadesProduccion) {
        this.actividadesProduccion = actividadesProduccion;
    }
    
    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }
    
    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
    
    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }
    
    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public String getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    public String getHoraFinal() {
        return horaFinal;
    }

    public void setHoraFinal(String horaFinal) {
        this.horaFinal = horaFinal;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestra() {
        return actividadesFormulaMaestra;
    }

    public void setActividadesFormulaMaestra(ActividadesFormulaMaestra actividadesFormulaMaestra) {
        this.actividadesFormulaMaestra = actividadesFormulaMaestra;
    }

    public List getMaquinariaList() {
        return maquinariaList;
    }

    public void setMaquinariaList(List maquinariaList) {
        this.maquinariaList = maquinariaList;
    }

    public Boolean getCheckedMaquinaria() {
        return checkedMaquinaria;
    }

    public void setCheckedMaquinaria(Boolean checkedMaquinaria) {
        this.checkedMaquinaria = checkedMaquinaria;
    }

    public MaquinariaActividadesFormula getMaquinariaActividadesFormula() {
        return maquinariaActividadesFormula;
    }

    public void setMaquinariaActividadesFormula(MaquinariaActividadesFormula maquinariaActividadesFormula) {
        this.maquinariaActividadesFormula = maquinariaActividadesFormula;
    }

    public List getSeguimientoProgramaProduccionPersonalList() {
        return seguimientoProgramaProduccionPersonalList;
    }

    public void setSeguimientoProgramaProduccionPersonalList(List seguimientoProgramaProduccionPersonalList) {
        this.seguimientoProgramaProduccionPersonalList = seguimientoProgramaProduccionPersonalList;
    }

    public boolean isHabilitado() {
        return habilitado;
    }

    public void setHabilitado(boolean habilitado) {
        this.habilitado = habilitado;
    }

    
}
