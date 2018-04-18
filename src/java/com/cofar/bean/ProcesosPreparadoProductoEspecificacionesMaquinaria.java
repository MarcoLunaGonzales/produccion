/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class ProcesosPreparadoProductoEspecificacionesMaquinaria extends AbstractBean
{
    private int codProcesoPreparadoProductoEspecificacionesMaquinaria=0;
    private EspecificacionesProcesos especificacionesProcesos=new EspecificacionesProcesos();
    private Double valorExacto=0d;
    private Double valorMinimo=0d;
    private Double valorMaximo=0d;
    private String valorTexto="";
    private TiposDescripcion tiposDescripcion=new TiposDescripcion();
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private Double porcientoTolerancia=0d;
    private boolean resultadoEsperadoLote=false;

    public ProcesosPreparadoProductoEspecificacionesMaquinaria() 
    {
    }

    public int getCodProcesoPreparadoProductoEspecificacionesMaquinaria() 
    {
        return codProcesoPreparadoProductoEspecificacionesMaquinaria;
    }

    public void setCodProcesoPreparadoProductoEspecificacionesMaquinaria(int codProcesoPreparadoProductoEspecificacionesMaquinaria) {
        this.codProcesoPreparadoProductoEspecificacionesMaquinaria = codProcesoPreparadoProductoEspecificacionesMaquinaria;
    }

    public EspecificacionesProcesos getEspecificacionesProcesos() {
        return especificacionesProcesos;
    }

    public void setEspecificacionesProcesos(EspecificacionesProcesos especificacionesProcesos) {
        this.especificacionesProcesos = especificacionesProcesos;
    }

    public Double getValorExacto() {
        return valorExacto;
    }

    public void setValorExacto(Double valorExacto) {
        this.valorExacto = valorExacto;
    }

    public Double getValorMinimo() {
        return valorMinimo;
    }

    public void setValorMinimo(Double valorMinimo) {
        this.valorMinimo = valorMinimo;
    }

    public Double getValorMaximo() {
        return valorMaximo;
    }

    public void setValorMaximo(Double valorMaximo) {
        this.valorMaximo = valorMaximo;
    }

    public String getValorTexto() {
        return valorTexto;
    }

    public void setValorTexto(String valorTexto) {
        this.valorTexto = valorTexto;
    }

    public TiposDescripcion getTiposDescripcion() {
        return tiposDescripcion;
    }

    public void setTiposDescripcion(TiposDescripcion tiposDescripcion) {
        this.tiposDescripcion = tiposDescripcion;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) 
    {
        this.unidadesMedida = unidadesMedida;
    }

    public Double getPorcientoTolerancia() {
        return porcientoTolerancia;
    }

    public void setPorcientoTolerancia(Double porcientoTolerancia) {
        this.porcientoTolerancia = porcientoTolerancia;
    }

    public boolean isResultadoEsperadoLote() {
        return resultadoEsperadoLote;
    }

    public void setResultadoEsperadoLote(boolean resultadoEsperadoLote) {
        this.resultadoEsperadoLote = resultadoEsperadoLote;
    }
    
    
}
