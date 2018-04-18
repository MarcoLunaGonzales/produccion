/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class ProgramaProduccionControlCalidad extends AbstractBean{
    
    ProgramaProduccionPeriodo programaProduccionPeriodo = new ProgramaProduccionPeriodo();
    ProgramaProduccionPeriodo programaProduccionPeriodoLoteProduccion = new ProgramaProduccionPeriodo();
    ComponentesProd componentesProd = new ComponentesProd();
    FormulaMaestra formulaMaestra = new FormulaMaestra();
    EstadoProgramaProduccion estadoProgramaProduccion = new EstadoProgramaProduccion();
    String codLoteProduccion = "";
    double cantLoteProduccion = 0;
    int cantidadMuestras = 0;
    int tiempoEstudio = 0;
    private int codProgramaProdControlCalidad=0;
    private AlmacenesMuestra almacenesMuestra=new AlmacenesMuestra();
    private TiposEstudioEstabilidad tiposEstudioEstabilidad=new TiposEstudioEstabilidad();
    private List<ProgramaProduccionControlCalidadAnalisis> programaProduccionControlCalidadAnalisisList=null;
    private TiposProgramaProduccion tiposProgramaProduccion=new TiposProgramaProduccion();
    public int getCantidadEstudios()
    {
        return this.programaProduccionControlCalidadAnalisisList.size();
    }
    public double getCantLoteProduccion() {
        return cantLoteProduccion;
    }

    public void setCantLoteProduccion(double cantLoteProduccion) {
        this.cantLoteProduccion = cantLoteProduccion;
    }

    

    public int getCantidadMuestras() {
        return cantidadMuestras;
    }

    public void setCantidadMuestras(int cantidadMuestras) {
        this.cantidadMuestras = cantidadMuestras;
    }

    public String getCodLoteProduccion() {
        return codLoteProduccion;
    }

    public void setCodLoteProduccion(String codLoteProduccion) {
        this.codLoteProduccion = codLoteProduccion;
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public EstadoProgramaProduccion getEstadoProgramaProduccion() {
        return estadoProgramaProduccion;
    }

    public void setEstadoProgramaProduccion(EstadoProgramaProduccion estadoProgramaProduccion) {
        this.estadoProgramaProduccion = estadoProgramaProduccion;
    }

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }

    public int getTiempoEstudio() {
        return tiempoEstudio;
    }

    public void setTiempoEstudio(int tiempoEstudio) {
        this.tiempoEstudio = tiempoEstudio;
    }

   
    public int getCodProgramaProdControlCalidad() {
        return codProgramaProdControlCalidad;
    }

    public void setCodProgramaProdControlCalidad(int codProgramaProdControlCalidad) {
        this.codProgramaProdControlCalidad = codProgramaProdControlCalidad;
    }

    public AlmacenesMuestra getAlmacenesMuestra() {
        return almacenesMuestra;
    }

    public void setAlmacenesMuestra(AlmacenesMuestra almacenesMuestra) {
        this.almacenesMuestra = almacenesMuestra;
    }

    public TiposEstudioEstabilidad getTiposEstudioEstabilidad() {
        return tiposEstudioEstabilidad;
    }

    public void setTiposEstudioEstabilidad(TiposEstudioEstabilidad tiposEstudioEstabilidad) {
        this.tiposEstudioEstabilidad = tiposEstudioEstabilidad;
    }

    public List<ProgramaProduccionControlCalidadAnalisis> getProgramaProduccionControlCalidadAnalisisList() {
        return programaProduccionControlCalidadAnalisisList;
    }

    public void setProgramaProduccionControlCalidadAnalisisList(List<ProgramaProduccionControlCalidadAnalisis> programaProduccionControlCalidadAnalisisList) {
        this.programaProduccionControlCalidadAnalisisList = programaProduccionControlCalidadAnalisisList;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoLoteProduccion() {
        return programaProduccionPeriodoLoteProduccion;
    }

    public void setProgramaProduccionPeriodoLoteProduccion(ProgramaProduccionPeriodo programaProduccionPeriodoLoteProduccion) {
        this.programaProduccionPeriodoLoteProduccion = programaProduccionPeriodoLoteProduccion;
    }

    public TiposProgramaProduccion getTiposProgramaProduccion() {
        return tiposProgramaProduccion;
    }

    public void setTiposProgramaProduccion(TiposProgramaProduccion tiposProgramaProduccion) {
        this.tiposProgramaProduccion = tiposProgramaProduccion;
    }

    
    
}
