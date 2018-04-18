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
public class FormasFarmaceuticasProcesoOrdenManufactura extends AbstractBean
{
    private int codFormaFarmaceuticaProcesoOrdenManufactura=0;
    private ProcesosOrdenManufactura procesosOrdenManufactura=new ProcesosOrdenManufactura();
    private boolean aplicaFlujograma=false;
    private boolean aplicaEspecificacionesMaquinaria=false;
    private boolean aplicaEspecificacionesProceso=false;
    private int orden=0;
    private boolean aplicaTipoEspecificacionProceso=false;

    public FormasFarmaceuticasProcesoOrdenManufactura() {
    }

    public int getCodFormaFarmaceuticaProcesoOrdenManufactura() {
        return codFormaFarmaceuticaProcesoOrdenManufactura;
    }

    public void setCodFormaFarmaceuticaProcesoOrdenManufactura(int codFormaFarmaceuticaProcesoOrdenManufactura) {
        this.codFormaFarmaceuticaProcesoOrdenManufactura = codFormaFarmaceuticaProcesoOrdenManufactura;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufactura() {
        return procesosOrdenManufactura;
    }

    public void setProcesosOrdenManufactura(ProcesosOrdenManufactura procesosOrdenManufactura) {
        this.procesosOrdenManufactura = procesosOrdenManufactura;
    }

    public boolean isAplicaFlujograma() {
        return aplicaFlujograma;
    }

    public void setAplicaFlujograma(boolean aplicaFlujograma) {
        this.aplicaFlujograma = aplicaFlujograma;
    }

    public boolean isAplicaEspecificacionesMaquinaria() {
        return aplicaEspecificacionesMaquinaria;
    }

    public void setAplicaEspecificacionesMaquinaria(boolean aplicaEspecificacionesMaquinaria) {
        this.aplicaEspecificacionesMaquinaria = aplicaEspecificacionesMaquinaria;
    }

    public boolean isAplicaEspecificacionesProceso() {
        return aplicaEspecificacionesProceso;
    }

    public void setAplicaEspecificacionesProceso(boolean aplicaEspecificacionesProceso) {
        this.aplicaEspecificacionesProceso = aplicaEspecificacionesProceso;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public boolean isAplicaTipoEspecificacionProceso() {
        return aplicaTipoEspecificacionProceso;
    }

    public void setAplicaTipoEspecificacionProceso(boolean aplicaTipoEspecificacionProceso) {
        this.aplicaTipoEspecificacionProceso = aplicaTipoEspecificacionProceso;
    }
    
    
}
