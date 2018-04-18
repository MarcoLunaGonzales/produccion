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
public class FormasFarmaceuticasIndicaciones extends AbstractBean
{
    private FormasFarmaceuticas formasFarmaceuticas=new FormasFarmaceuticas();
    private String indicacionesForma="";
    private TiposIndicacionProceso tiposIndicacionProceso=new TiposIndicacionProceso();
    private ProcesosOrdenManufactura procesosOrdenManufactura=new ProcesosOrdenManufactura();

    public FormasFarmaceuticasIndicaciones() {
    }

    public FormasFarmaceuticas getFormasFarmaceuticas() 
    {
        return formasFarmaceuticas;
    }

    public void setFormasFarmaceuticas(FormasFarmaceuticas formasFarmaceuticas) {
        this.formasFarmaceuticas = formasFarmaceuticas;
    }

    public String getIndicacionesForma() {
        return indicacionesForma;
    }

    public void setIndicacionesForma(String indicacionesForma) {
        this.indicacionesForma = indicacionesForma;
    }

    public TiposIndicacionProceso getTiposIndicacionProceso() {
        return tiposIndicacionProceso;
    }

    public void setTiposIndicacionProceso(TiposIndicacionProceso tiposIndicacionProceso) {
        this.tiposIndicacionProceso = tiposIndicacionProceso;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufactura() {
        return procesosOrdenManufactura;
    }

    public void setProcesosOrdenManufactura(ProcesosOrdenManufactura procesosOrdenManufactura) {
        this.procesosOrdenManufactura = procesosOrdenManufactura;
    }
    
    
    
}
