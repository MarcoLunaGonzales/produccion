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
public class FormasFarmaceuticasActividadesPreparado extends AbstractBean
{
    private int codFormaFarmaceuticaActividadPreparado=0;
    private String descripcion="";
    private int nroPaso=0;
    private ActividadesPreparado actividadesPreparado=new ActividadesPreparado();
    private boolean necesitaMateriales=false;
    private ProcesosOrdenManufactura procesosOrdenManufactura=new ProcesosOrdenManufactura();
    private List<Maquinaria> maquinariasList;
    private List<EspecificacionesProcesos> especificacionesProcesosList;
    private List<FormasFarmaceuticasActividadesPreparado> subFormasFarmaceuticasActividadesPreparadoList;

    public FormasFarmaceuticasActividadesPreparado() {
    }

    
    public int getCodFormaFarmaceuticaActividadPreparado() {
        return codFormaFarmaceuticaActividadPreparado;
    }

    public void setCodFormaFarmaceuticaActividadPreparado(int codFormaFarmaceuticaActividadPreparado) {
        this.codFormaFarmaceuticaActividadPreparado = codFormaFarmaceuticaActividadPreparado;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getNroPaso() {
        return nroPaso;
    }

    public void setNroPaso(int nroPaso) {
        this.nroPaso = nroPaso;
    }

    public ActividadesPreparado getActividadesPreparado() {
        return actividadesPreparado;
    }

    public void setActividadesPreparado(ActividadesPreparado actividadesPreparado) {
        this.actividadesPreparado = actividadesPreparado;
    }

    public boolean isNecesitaMateriales() {
        return necesitaMateriales;
    }

    public void setNecesitaMateriales(boolean necesitaMateriales) {
        this.necesitaMateriales = necesitaMateriales;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufactura() 
    {
        return procesosOrdenManufactura;
    }

    public void setProcesosOrdenManufactura(ProcesosOrdenManufactura procesosOrdenManufactura) {
        this.procesosOrdenManufactura = procesosOrdenManufactura;
    }

    public List<Maquinaria> getMaquinariasList() {
        return maquinariasList;
    }

    public void setMaquinariasList(List<Maquinaria> maquinariasList) {
        this.maquinariasList = maquinariasList;
    }
    public int getMaquinariasListSize() {
        return (maquinariasList!=null?maquinariasList.size():0);
    }

    public List<EspecificacionesProcesos> getEspecificacionesProcesosList() {
        return especificacionesProcesosList;
    }

    public void setEspecificacionesProcesosList(List<EspecificacionesProcesos> especificacionesProcesosList) {
        this.especificacionesProcesosList = especificacionesProcesosList;
    }

    public List<FormasFarmaceuticasActividadesPreparado> getSubFormasFarmaceuticasActividadesPreparadoList() {
        return subFormasFarmaceuticasActividadesPreparadoList;
    }

    public void setSubFormasFarmaceuticasActividadesPreparadoList(List<FormasFarmaceuticasActividadesPreparado> subFormasFarmaceuticasActividadesPreparadoList) {
        this.subFormasFarmaceuticasActividadesPreparadoList = subFormasFarmaceuticasActividadesPreparadoList;
    }
    
    
}
