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
public class ProcesosPreparadoProducto extends AbstractBean
{
    private ComponentesProdVersion componentesProdVersion = new ComponentesProdVersion();
    private ProcesosOrdenManufactura procesosOrdenManufactura = new ProcesosOrdenManufactura();
    private int codProcesoPreparadoProducto=0;
    private ActividadesPreparado actividadesPreparado=new ActividadesPreparado();
    private int nroPaso=0;
    private String descripcion="";
    private Double tiempoProceso=0d;
    private Double toleranciaTiempo=0d;
    private boolean operarioTiempoCompleto=false;
    private List<ProcesosPreparadoProductoMaquinaria> procesosPreparadoProductoMaquinariaList;
    private ProcesosPreparadoProducto procesosPreparadoProductoPadre;
    private ProcesosPreparadoProducto procesosPreparadoProductoDestino;//=new ProcesosPreparadoProducto();
    private List<ProcesosPreparadoProducto> subProcesosPreparadoProductoList;
    private List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoList;
    private String sustanciaResultante="";
    private boolean procesoSecuencial = false;

    public ProcesosPreparadoProducto() {
    }
    

    public int getCodProcesoPreparadoProducto() {
        return codProcesoPreparadoProducto;
    }

    public void setCodProcesoPreparadoProducto(int codProcesoPreparadoProducto) {
        this.codProcesoPreparadoProducto = codProcesoPreparadoProducto;
    }

    public ActividadesPreparado getActividadesPreparado() {
        return actividadesPreparado;
    }

    public void setActividadesPreparado(ActividadesPreparado actividadesPreparado) {
        this.actividadesPreparado = actividadesPreparado;
    }

    public int getNroPaso() {
        return nroPaso;
    }

    public void setNroPaso(int nroPaso) {
        this.nroPaso = nroPaso;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Double getTiempoProceso() {
        return tiempoProceso;
    }

    public void setTiempoProceso(Double tiempoProceso) {
        this.tiempoProceso = tiempoProceso;
    }

    public Double getToleranciaTiempo() {
        return toleranciaTiempo;
    }

    public void setToleranciaTiempo(Double toleranciaTiempo) {
        this.toleranciaTiempo = toleranciaTiempo;
    }

    public boolean isOperarioTiempoCompleto() {
        return operarioTiempoCompleto;
    }

    public void setOperarioTiempoCompleto(boolean operarioTiempoCompleto) {
        this.operarioTiempoCompleto = operarioTiempoCompleto;
    }

    public List<ProcesosPreparadoProductoMaquinaria> getProcesosPreparadoProductoMaquinariaList() {
        return procesosPreparadoProductoMaquinariaList;
    }

    public void setProcesosPreparadoProductoMaquinariaList(List<ProcesosPreparadoProductoMaquinaria> procesosPreparadoProductoMaquinariaList) {
        this.procesosPreparadoProductoMaquinariaList = procesosPreparadoProductoMaquinariaList;
    }
    
    public int getProcesosPreparadoProductoMaquinariaListSize()
    {
        return (this.procesosPreparadoProductoMaquinariaList!=null?this.procesosPreparadoProductoMaquinariaList.size():0);
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProductoPadre() {
        return procesosPreparadoProductoPadre;
    }

    public void setProcesosPreparadoProductoPadre(ProcesosPreparadoProducto procesosPreparadoProductoPadre) {
        this.procesosPreparadoProductoPadre = procesosPreparadoProductoPadre;
    }

    public List<ProcesosPreparadoProducto> getSubProcesosPreparadoProductoList() {
        return subProcesosPreparadoProductoList;
    }

    public void setSubProcesosPreparadoProductoList(List<ProcesosPreparadoProducto> subProcesosPreparadoProductoList) {
        this.subProcesosPreparadoProductoList = subProcesosPreparadoProductoList;
    }
    public int getSubProcesosPreparadoProductoListSize()
    {
        return (this.subProcesosPreparadoProductoList!=null?subProcesosPreparadoProductoList.size():0);
    }
    

    public ProcesosPreparadoProducto getProcesosPreparadoProductoDestino() {
        return procesosPreparadoProductoDestino;
    }

    public void setProcesosPreparadoProductoDestino(ProcesosPreparadoProducto procesosPreparadoProductoDestino) {
        this.procesosPreparadoProductoDestino = procesosPreparadoProductoDestino;
    }

    public String getSustanciaResultante() {
        return sustanciaResultante;
    }

    public void setSustanciaResultante(String sustanciaResultante) {
        this.sustanciaResultante = sustanciaResultante;
    }

    public boolean isProcesoSecuencial() {
        return procesoSecuencial;
    }

    public void setProcesoSecuencial(boolean procesoSecuencial) {
        this.procesoSecuencial = procesoSecuencial;
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufactura() {
        return procesosOrdenManufactura;
    }

    public void setProcesosOrdenManufactura(ProcesosOrdenManufactura procesosOrdenManufactura) {
        this.procesosOrdenManufactura = procesosOrdenManufactura;
    }

    public List<ProcesosPreparadoProductoConsumo> getProcesosPreparadoProductoConsumoList() {
        return procesosPreparadoProductoConsumoList;
    }

    public void setProcesosPreparadoProductoConsumoList(List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoList) {
        this.procesosPreparadoProductoConsumoList = procesosPreparadoProductoConsumoList;
    }
    
    
}
