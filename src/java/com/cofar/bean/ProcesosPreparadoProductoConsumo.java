/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class ProcesosPreparadoProductoConsumo extends AbstractBean{
    
    private int codProcesoPreparadoProductoConsumo=0;
    private ProcesosPreparadoProducto procesosPreparadoProducto=new ProcesosPreparadoProducto();
    private Boolean materialTransitorio=false;
    private int ordenAdicion=0;
    private ProcesosPreparadoConsumoMaterialFm procesosPreparadoConsumoMaterialFm;
    private ProcesosPreparadoProductoConsumoProceso procesosPreparadoProductoConsumoProceso;
    
    public ProcesosPreparadoProductoConsumo() {
    }

    public int getCodProcesoPreparadoProductoConsumo() {
        return codProcesoPreparadoProductoConsumo;
    }

    public void setCodProcesoPreparadoProductoConsumo(int codProcesoPreparadoProductoConsumo) {
        this.codProcesoPreparadoProductoConsumo = codProcesoPreparadoProductoConsumo;
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProducto() {
        return procesosPreparadoProducto;
    }

    public void setProcesosPreparadoProducto(ProcesosPreparadoProducto procesosPreparadoProducto) {
        this.procesosPreparadoProducto = procesosPreparadoProducto;
    }

    public Boolean getMaterialTransitorio() {
        return materialTransitorio;
    }

    public void setMaterialTransitorio(Boolean materialTransitorio) {
        this.materialTransitorio = materialTransitorio;
    }

    public int getOrdenAdicion() {
        return ordenAdicion;
    }

    public void setOrdenAdicion(int ordenAdicion) {
        this.ordenAdicion = ordenAdicion;
    }

    public ProcesosPreparadoConsumoMaterialFm getProcesosPreparadoConsumoMaterialFm() {
        return procesosPreparadoConsumoMaterialFm;
    }

    public void setProcesosPreparadoConsumoMaterialFm(ProcesosPreparadoConsumoMaterialFm procesosPreparadoConsumoMaterialFm) {
        this.procesosPreparadoConsumoMaterialFm = procesosPreparadoConsumoMaterialFm;
    }

    public ProcesosPreparadoProductoConsumoProceso getProcesosPreparadoProductoConsumoProceso() {
        return procesosPreparadoProductoConsumoProceso;
    }

    public void setProcesosPreparadoProductoConsumoProceso(ProcesosPreparadoProductoConsumoProceso procesosPreparadoProductoConsumoProceso) {
        this.procesosPreparadoProductoConsumoProceso = procesosPreparadoProductoConsumoProceso;
    }
    
    
    
}
