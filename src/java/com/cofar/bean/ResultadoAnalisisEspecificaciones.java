/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class ResultadoAnalisisEspecificaciones extends AbstractBean{

    private EspecificacionesFisicasProducto especificacionesFisicasProducto= new EspecificacionesFisicasProducto();
    private EspecificacionesMicrobiologiaProducto especificacionesMicrobiologiaProducto= new EspecificacionesMicrobiologiaProducto();
    private double resultadoNumerico=0.0d;
    private ResultadoAnalisis resultadoAnalisis= new ResultadoAnalisis();
    private TipoResultadoDescriptivo tipoResultadoDescriptivo= new TipoResultadoDescriptivo();
    private TipoAnalisis tipoAnalisis= new TipoAnalisis();
    private TipoResultadoDescriptivo resultadoDescriptivoAlternativo=new TipoResultadoDescriptivo();

    public ResultadoAnalisisEspecificaciones() {
    }


    public EspecificacionesFisicasProducto getEspecificacionesFisicasProducto() {
        return especificacionesFisicasProducto;
    }

    public void setEspecificacionesFisicasProducto(EspecificacionesFisicasProducto especificacionesFisicasProducto) {
        this.especificacionesFisicasProducto = especificacionesFisicasProducto;
    }

    public EspecificacionesMicrobiologiaProducto getEspecificacionesMicrobiologiaProducto() {
        return especificacionesMicrobiologiaProducto;
    }

    public void setEspecificacionesMicrobiologiaProducto(EspecificacionesMicrobiologiaProducto especificacionesMicrobiologiaProducto) {
        this.especificacionesMicrobiologiaProducto = especificacionesMicrobiologiaProducto;
    }

    public ResultadoAnalisis getResultadoAnalisis() {
        return resultadoAnalisis;
    }

    public void setResultadoAnalisis(ResultadoAnalisis resultadoAnalisis) {
        this.resultadoAnalisis = resultadoAnalisis;
    }


    public TipoAnalisis getTipoAnalisis() {
        return tipoAnalisis;
    }

    public void setTipoAnalisis(TipoAnalisis tipoAnalisis) {
        this.tipoAnalisis = tipoAnalisis;
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

    public TipoResultadoDescriptivo getResultadoDescriptivoAlternativo() {
        return resultadoDescriptivoAlternativo;
    }

    public void setResultadoDescriptivoAlternativo(TipoResultadoDescriptivo resultadoDescriptivoAlternativo) {
        this.resultadoDescriptivoAlternativo = resultadoDescriptivoAlternativo;
    }
    
    
}
