/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author USER
 */
public class ResultadoFisicoEstabilidad {
    ProgramaProduccionControlCalidadAnalisis programaProduccionControlCalidadAnalisis = new ProgramaProduccionControlCalidadAnalisis();
    EspecificacionesFisicasProducto especificacionesFisicasProducto = new EspecificacionesFisicasProducto();
    EspecificacionesFisicasCc especificacionesFisicasCc = new EspecificacionesFisicasCc();
    Double cantidad = 0.0;
    int codTipoResultadoDescriptivo = 0;
    Double resultadoNumerico = 0.0;
    



    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public EspecificacionesFisicasCc getEspecificacionesFisicasCc() {
        return especificacionesFisicasCc;
    }

    public void setEspecificacionesFisicasCc(EspecificacionesFisicasCc especificacionesFisicasCc) {
        this.especificacionesFisicasCc = especificacionesFisicasCc;
    }

    public EspecificacionesFisicasProducto getEspecificacionesFisicasProducto() {
        return especificacionesFisicasProducto;
    }

    public void setEspecificacionesFisicasProducto(EspecificacionesFisicasProducto especificacionesFisicasProducto) {
        this.especificacionesFisicasProducto = especificacionesFisicasProducto;
    }

    public ProgramaProduccionControlCalidadAnalisis getProgramaProduccionControlCalidadAnalisis() {
        return programaProduccionControlCalidadAnalisis;
    }

    public void setProgramaProduccionControlCalidadAnalisis(ProgramaProduccionControlCalidadAnalisis programaProduccionControlCalidadAnalisis) {
        this.programaProduccionControlCalidadAnalisis = programaProduccionControlCalidadAnalisis;
    }

    public int getCodTipoResultadoDescriptivo() {
        return codTipoResultadoDescriptivo;
    }

    public void setCodTipoResultadoDescriptivo(int codTipoResultadoDescriptivo) {
        this.codTipoResultadoDescriptivo = codTipoResultadoDescriptivo;
    }

    public Double getResultadoNumerico() {
        return resultadoNumerico;
    }

    public void setResultadoNumerico(Double resultadoNumerico) {
        this.resultadoNumerico = resultadoNumerico;
    }

    


    


}
