/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author USER
 */
public class ResultadoQuimicoEstabilidad {
    ProgramaProduccionControlCalidadAnalisis programaProduccionControlCalidadAnalisis = new ProgramaProduccionControlCalidadAnalisis();
    
    EspecificacionesQuimicasProducto especificacionesQuimicasProducto = new EspecificacionesQuimicasProducto();
    EspecificacionesFisicasCc especificacionesFisicasCc = new EspecificacionesFisicasCc();
    Double cantidad = 0.0;
    int codTipoResultadoDescriptivo = 0;
    Double resultadoNumerico = 0.0;
    Materiales materiales = new Materiales();

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public int getCodTipoResultadoDescriptivo() {
        return codTipoResultadoDescriptivo;
    }

    public void setCodTipoResultadoDescriptivo(int codTipoResultadoDescriptivo) {
        this.codTipoResultadoDescriptivo = codTipoResultadoDescriptivo;
    }

    public EspecificacionesFisicasCc getEspecificacionesFisicasCc() {
        return especificacionesFisicasCc;
    }

    public void setEspecificacionesFisicasCc(EspecificacionesFisicasCc especificacionesFisicasCc) {
        this.especificacionesFisicasCc = especificacionesFisicasCc;
    }

    public EspecificacionesQuimicasProducto getEspecificacionesQuimicasProducto() {
        return especificacionesQuimicasProducto;
    }

    public void setEspecificacionesQuimicasProducto(EspecificacionesQuimicasProducto especificacionesQuimicasProducto) {
        this.especificacionesQuimicasProducto = especificacionesQuimicasProducto;
    }

    

    public ProgramaProduccionControlCalidadAnalisis getProgramaProduccionControlCalidadAnalisis() {
        return programaProduccionControlCalidadAnalisis;
    }

    public void setProgramaProduccionControlCalidadAnalisis(ProgramaProduccionControlCalidadAnalisis programaProduccionControlCalidadAnalisis) {
        this.programaProduccionControlCalidadAnalisis = programaProduccionControlCalidadAnalisis;
    }

    public Double getResultadoNumerico() {
        return resultadoNumerico;
    }

    public void setResultadoNumerico(Double resultadoNumerico) {
        this.resultadoNumerico = resultadoNumerico;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }
    


    

}
