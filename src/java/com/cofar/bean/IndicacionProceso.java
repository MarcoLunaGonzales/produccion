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
public class IndicacionProceso extends AbstractBean
{
    private int codIndicacionProceso=0;
    private TiposIndicacionProceso tiposIndicacionProceso=new TiposIndicacionProceso();
    private String indicacionProceso="";
    private ComponentesProdVersion componentesProdVersion = new ComponentesProdVersion();
    private ProcesosOrdenManufactura procesosOrdenManufactura=new ProcesosOrdenManufactura();

    public IndicacionProceso() {
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

    public int getCodIndicacionProceso() {
        return codIndicacionProceso;
    }

    public void setCodIndicacionProceso(int codIndicacionProceso) {
        this.codIndicacionProceso = codIndicacionProceso;
    }

    public String getIndicacionProceso() {
        return indicacionProceso;
    }

    public void setIndicacionProceso(String indicacionProceso) {
        this.indicacionProceso = indicacionProceso;
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }
    
    
    
    
}
