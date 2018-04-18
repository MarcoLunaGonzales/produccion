/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class EspecificacionesProcesos extends AbstractBean
{
   private TiposDescripcion tiposDescripcion=new TiposDescripcion();
   //private FormasFarmaceuticas formaFarmaceutica=new FormasFarmaceuticas();
   private int codEspecificacionProceso=0;
   private String nombreEspecificacionProceso="";
   private UnidadesMedida unidadMedida=new UnidadesMedida();
   private Double valorExacto=0d;
   private Double valorMinimo=0d;
   private Double valorMaximo=0d;
   private String valorTexto="";
   private boolean resultadoNumerico=false;
   private boolean especificacionStandarForma=false;
   private int orden=0;
   private double porcientoTolerancia=0d;
   private TiposEspecificacionesProcesos tiposEspecificacionesProcesos=new TiposEspecificacionesProcesos();
   private ProcesosOrdenManufactura procesosOrdenManufactura=new ProcesosOrdenManufactura();
   private boolean resultadoEsperadoLote=false;
   
    public EspecificacionesProcesos() {
    }

    public int getCodEspecificacionProceso() {
        return codEspecificacionProceso;
    }

    public void setCodEspecificacionProceso(int codEspecificacionProceso) {
        this.codEspecificacionProceso = codEspecificacionProceso;
    }

    public boolean isEspecificacionStandarForma() {
        return especificacionStandarForma;
    }

    public void setEspecificacionStandarForma(boolean especificacionStandarForma) {
        this.especificacionStandarForma = especificacionStandarForma;
    }


    public String getNombreEspecificacionProceso() {
        return nombreEspecificacionProceso;
    }

    public void setNombreEspecificacionProceso(String nombreEspecificacionProceso) {
        this.nombreEspecificacionProceso = nombreEspecificacionProceso;
    }

    public boolean isResultadoNumerico() {
        return resultadoNumerico;
    }

    public void setResultadoNumerico(boolean resultadoNumerico) {
        this.resultadoNumerico = resultadoNumerico;
    }

    public UnidadesMedida getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(UnidadesMedida unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    public Double getValorExacto() {
        return valorExacto;
    }

    public void setValorExacto(Double valorExacto) {
        this.valorExacto = valorExacto;
    }

    public String getValorTexto() {
        return valorTexto;
    }

    public void setValorTexto(String valorTexto) {
        this.valorTexto = valorTexto;
    }

    public double getPorcientoTolerancia() {
        return porcientoTolerancia;
    }

    public void setPorcientoTolerancia(double porcientoTolerancia) {
        this.porcientoTolerancia = porcientoTolerancia;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public TiposEspecificacionesProcesos getTiposEspecificacionesProcesos() {
        return tiposEspecificacionesProcesos;
    }

    public void setTiposEspecificacionesProcesos(TiposEspecificacionesProcesos tiposEspecificacionesProcesos) {
        this.tiposEspecificacionesProcesos = tiposEspecificacionesProcesos;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufactura() {
        return procesosOrdenManufactura;
    }

    public void setProcesosOrdenManufactura(ProcesosOrdenManufactura procesosOrdenManufactura) {
        this.procesosOrdenManufactura = procesosOrdenManufactura;
    }

    public boolean isResultadoEsperadoLote() {
        return resultadoEsperadoLote;
    }

    public void setResultadoEsperadoLote(boolean resultadoEsperadoLote) {
        this.resultadoEsperadoLote = resultadoEsperadoLote;
    }

    

    public TiposDescripcion getTiposDescripcion() {
        return tiposDescripcion;
    }

    public void setTiposDescripcion(TiposDescripcion tiposDescripcion) {
        this.tiposDescripcion = tiposDescripcion;
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

    
    
}
