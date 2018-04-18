/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author aquispe
 */
public class ProgramaProduccionControlCalidadAnalisis extends AbstractBean {

    private Date fechaAnalisis=new Date();
    private int tiempoEstudio=0;
    private int procede=0;
    private int cantidadTestDisolucion=0;
    private int cantidadTestValoracion=0;
    private TiposMaterialReactivo tipoMaterialReactivo=new TiposMaterialReactivo();
    private String Observacion="";
    private int codControlCalidadAnalisis=0;
    private ProgramaProduccionControlCalidad programaProduccionControlCalidad=new ProgramaProduccionControlCalidad();
    private List materialesList = new ArrayList();
    private String codTipoResultadoEstabilidad = "";
    
    public ProgramaProduccionControlCalidadAnalisis() {
    }

    public String getObservacion() {
        return Observacion;
    }

    public void setObservacion(String Observacion) {
        this.Observacion = Observacion;
    }

    public Date getFechaAnalisis() {
        return fechaAnalisis;
    }

    public void setFechaAnalisis(Date fechaAnalisis) {
        this.fechaAnalisis = fechaAnalisis;
    }

    public int getProcede() {
        return procede;
    }

    public void setProcede(int procede) {
        this.procede = procede;
    }

    public int getTiempoEstudio() {
        return tiempoEstudio;
    }

    public void setTiempoEstudio(int tiempoEstudio) {
        this.tiempoEstudio = tiempoEstudio;
    }

    public TiposMaterialReactivo getTipoMaterialReactivo() {
        return tipoMaterialReactivo;
    }

    public void setTipoMaterialReactivo(TiposMaterialReactivo tipoMaterialReactivo) {
        this.tipoMaterialReactivo = tipoMaterialReactivo;
    }

    public int getCantidadTestDisolucion() {
        return cantidadTestDisolucion;
    }

    public void setCantidadTestDisolucion(int cantidadTestDisolucion) {
        this.cantidadTestDisolucion = cantidadTestDisolucion;
    }

    public int getCantidadTestValoracion() {
        return cantidadTestValoracion;
    }

    public void setCantidadTestValoracion(int cantidadTestValoracion) {
        this.cantidadTestValoracion = cantidadTestValoracion;
    }

    public int getCodControlCalidadAnalisis() {
        return codControlCalidadAnalisis;
    }

    public void setCodControlCalidadAnalisis(int codControlCalidadAnalisis) {
        this.codControlCalidadAnalisis = codControlCalidadAnalisis;
    }

    public ProgramaProduccionControlCalidad getProgramaProduccionControlCalidad() {
        return programaProduccionControlCalidad;
    }

    public void setProgramaProduccionControlCalidad(ProgramaProduccionControlCalidad programaProduccionControlCalidad) {
        this.programaProduccionControlCalidad = programaProduccionControlCalidad;
    }

    public List getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List materialesList) {
        this.materialesList = materialesList;
    }

    public String getCodTipoResultadoEstabilidad() {
        return codTipoResultadoEstabilidad;
    }

    public void setCodTipoResultadoEstabilidad(String codTipoResultadoEstabilidad) {
        this.codTipoResultadoEstabilidad = codTipoResultadoEstabilidad;
    }

    


    
}
