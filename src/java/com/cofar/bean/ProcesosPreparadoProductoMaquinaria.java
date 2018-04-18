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
public class ProcesosPreparadoProductoMaquinaria extends AbstractBean
{
    //null por default para no sobrecargar java
    private ProcesosPreparadoProducto procesosPreparadoProducto=null;
    private int codProcesoPreparadProductoMaquinaria=0;
    private Maquinaria maquinaria=new Maquinaria();
    private List<ProcesosPreparadoProductoEspecificacionesMaquinaria> procesosPreparadoProductoEspecificacionesMaquinariaList;
    private boolean activoAntesDeEdicion=false;

    public int getCodProcesoPreparadProductoMaquinaria() {
        return codProcesoPreparadProductoMaquinaria;
    }

    public void setCodProcesoPreparadProductoMaquinaria(int codProcesoPreparadProductoMaquinaria) {
        this.codProcesoPreparadProductoMaquinaria = codProcesoPreparadProductoMaquinaria;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public List<ProcesosPreparadoProductoEspecificacionesMaquinaria> getProcesosPreparadoProductoEspecificacionesMaquinariaList() {
        return procesosPreparadoProductoEspecificacionesMaquinariaList;
    }

    public void setProcesosPreparadoProductoEspecificacionesMaquinariaList(List<ProcesosPreparadoProductoEspecificacionesMaquinaria> procesosPreparadoProductoEspecificacionesMaquinariaList) {
        this.procesosPreparadoProductoEspecificacionesMaquinariaList = procesosPreparadoProductoEspecificacionesMaquinariaList;
    }

    public boolean isActivoAntesDeEdicion() {
        return activoAntesDeEdicion;
    }

    public void setActivoAntesDeEdicion(boolean activoAntesDeEdicion) {
        this.activoAntesDeEdicion = activoAntesDeEdicion;
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProducto() {
        return procesosPreparadoProducto;
    }

    public void setProcesosPreparadoProducto(ProcesosPreparadoProducto procesosPreparadoProducto) {
        this.procesosPreparadoProducto = procesosPreparadoProducto;
    }

    
    
    
}
