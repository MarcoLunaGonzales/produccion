/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class EspecificacionesQuimicasCc extends  AbstractBean{
    private String coeficiente="";
    int codEspecificacion = 0;
    String nombreEspecificacion = "";
    private TiposResultadosAnalisis tipoResultadoAnalisis= new TiposResultadosAnalisis();
    //inicio ale
    List<EspecificacionesQuimicasProducto> listaEspecificacionesQuimicasProducto= new ArrayList<EspecificacionesQuimicasProducto>();
    private List<ResultadosAnalisisEspecificacionesQuimicas> listaResultadoAnalisisEspecificacionesQuimicas= new ArrayList<ResultadosAnalisisEspecificacionesQuimicas>();
    private ResultadoAnalisisEspecificaciones especificacionQuimicaGeneral=new ResultadoAnalisisEspecificaciones();
    private String unidad="";
    //final ale
    public int getCodEspecificacion() {
        return codEspecificacion;
    }

    public void setCodEspecificacion(int codEspecificacion) {
        this.codEspecificacion = codEspecificacion;
    }

    public String getNombreEspecificacion() {
        return nombreEspecificacion;
    }

    public void setNombreEspecificacion(String nombreEspecificacion) {
        this.nombreEspecificacion = nombreEspecificacion;
    }

    public List<EspecificacionesQuimicasProducto> getListaEspecificacionesQuimicasProducto() {
        return listaEspecificacionesQuimicasProducto;
    }

    public void setListaEspecificacionesQuimicasProducto(List<EspecificacionesQuimicasProducto> listaEspecificacionesQuimicasProducto) {
        this.listaEspecificacionesQuimicasProducto = listaEspecificacionesQuimicasProducto;
    }

    public List<ResultadosAnalisisEspecificacionesQuimicas> getListaResultadoAnalisisEspecificacionesQuimicas() {
        return listaResultadoAnalisisEspecificacionesQuimicas;
    }

    public void setListaResultadoAnalisisEspecificacionesQuimicas(List<ResultadosAnalisisEspecificacionesQuimicas> listaResultadoAnalisisEspecificacionesQuimicas) {
        this.listaResultadoAnalisisEspecificacionesQuimicas = listaResultadoAnalisisEspecificacionesQuimicas;
    }

    public TiposResultadosAnalisis getTipoResultadoAnalisis() {
        return tipoResultadoAnalisis;
    }

    public void setTipoResultadoAnalisis(TiposResultadosAnalisis tipoResultadoAnalisis) {
        this.tipoResultadoAnalisis = tipoResultadoAnalisis;
    }

    public String getCoeficiente() {
        return coeficiente;
    }

    public void setCoeficiente(String coeficiente) {
        this.coeficiente = coeficiente;
    }

    public ResultadoAnalisisEspecificaciones getEspecificacionQuimicaGeneral() {
        return especificacionQuimicaGeneral;
    }

    public void setEspecificacionQuimicaGeneral(ResultadoAnalisisEspecificaciones especificacionQuimicaGeneral) {
        this.especificacionQuimicaGeneral = especificacionQuimicaGeneral;
    }

    public String getUnidad() {
        return unidad;
    }

    public void setUnidad(String unidad) {
        this.unidad = unidad;
    }

    public int getListaEspecificacionesQuimicasProductoSize()
    {
        return listaEspecificacionesQuimicasProducto.size();
    }

}
