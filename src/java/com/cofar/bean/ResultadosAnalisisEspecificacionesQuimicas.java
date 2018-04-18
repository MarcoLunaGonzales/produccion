/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class ResultadosAnalisisEspecificacionesQuimicas extends AbstractBean {

   
    private double resultadoNumerico=0.0d;
    private TipoResultadoDescriptivo tipoResultadoDescriptivo= new TipoResultadoDescriptivo();
    private ResultadoAnalisis resultadoAnalisis= new ResultadoAnalisis();
    private TipoResultadoDescriptivo resultadoDescriptivoAlternativo=new TipoResultadoDescriptivo();
    private EspecificacionesQuimicasProducto especificacionesQuimicasProducto= new EspecificacionesQuimicasProducto();
    public ResultadosAnalisisEspecificacionesQuimicas() {
    }


    public ResultadoAnalisis getResultadoAnalisis() {
        return resultadoAnalisis;
    }

    public void setResultadoAnalisis(ResultadoAnalisis resultadoAnalisis) {
        this.resultadoAnalisis = resultadoAnalisis;
    }

    public double getResultadoNumerico() {
        return resultadoNumerico;
    }

    public void setResultadoNumerico(double resultadoNumerico) {
        this.resultadoNumerico = resultadoNumerico;
    }

    public TipoResultadoDescriptivo getTipoResultadoDescriptivo() {
        return tipoResultadoDescriptivo;
    }

    public void setTipoResultadoDescriptivo(TipoResultadoDescriptivo tipoResultadoDescriptivo) {
        this.tipoResultadoDescriptivo = tipoResultadoDescriptivo;
    }

    public EspecificacionesQuimicasProducto getEspecificacionesQuimicasProducto() {
        return especificacionesQuimicasProducto;
    }

    public void setEspecificacionesQuimicasProducto(EspecificacionesQuimicasProducto especificacionesQuimicasProducto) {
        this.especificacionesQuimicasProducto = especificacionesQuimicasProducto;
    }

    public TipoResultadoDescriptivo getResultadoDescriptivoAlternativo() {
        return resultadoDescriptivoAlternativo;
    }

    public void setResultadoDescriptivoAlternativo(TipoResultadoDescriptivo resultadoDescriptivoAlternativo) {
        this.resultadoDescriptivoAlternativo = resultadoDescriptivoAlternativo;
    }

    
    

}
