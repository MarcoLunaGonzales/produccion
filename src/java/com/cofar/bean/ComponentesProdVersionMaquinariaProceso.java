/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.List;

/**
 *
 * @author DASISAQ-
 */
public class ComponentesProdVersionMaquinariaProceso extends AbstractBean
{
    private ComponentesProdVersion componentesProdVersion = new ComponentesProdVersion();
    private Maquinaria maquinaria=new Maquinaria();
    private ProcesosOrdenManufactura procesosOrdenManufactura=new ProcesosOrdenManufactura();
    private List<EspecificacionesProcesosProductoMaquinaria> especificacionesProcesosProductoMaquinariaList;
    private int codCompprodVesionMaquinariaProceso=0;
    public ComponentesProdVersionMaquinariaProceso() {
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufactura() {
        return procesosOrdenManufactura;
    }

    public void setProcesosOrdenManufactura(ProcesosOrdenManufactura procesosOrdenManufactura) {
        this.procesosOrdenManufactura = procesosOrdenManufactura;
    }

    public List<EspecificacionesProcesosProductoMaquinaria> getEspecificacionesProcesosProductoMaquinariaList() {
        return especificacionesProcesosProductoMaquinariaList;
    }

    public void setEspecificacionesProcesosProductoMaquinariaList(List<EspecificacionesProcesosProductoMaquinaria> especificacionesProcesosProductoMaquinariaList) {
        this.especificacionesProcesosProductoMaquinariaList = especificacionesProcesosProductoMaquinariaList;
    }
    public int getEspecificacionesProcesosProductoMaquinariaListSize()
    {
        return (this.especificacionesProcesosProductoMaquinariaList!=null?this.especificacionesProcesosProductoMaquinariaList.size():0);
    }

    public int getCodCompprodVesionMaquinariaProceso() {
        return codCompprodVesionMaquinariaProceso;
    }

    public void setCodCompprodVesionMaquinariaProceso(int codCompprodVesionMaquinariaProceso) {
        this.codCompprodVesionMaquinariaProceso = codCompprodVesionMaquinariaProceso;
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }
    
    
    
    
    
    
}
