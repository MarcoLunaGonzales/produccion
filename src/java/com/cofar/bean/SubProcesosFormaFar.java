/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author aquispe
 */
public class SubProcesosFormaFar extends AbstractBean{
    private ActividadesPreparado actividadesPreparado=new ActividadesPreparado();
    private int codSubProcesoFormaFar=0;
    private int nroPaso=0;
    private Maquinaria maquinaria=new Maquinaria();
    private String descripcion="";
    private int  necesitaMateriales=0;
    private List<Maquinaria> maquinariaList=new ArrayList<Maquinaria>();
    public SubProcesosFormaFar() {
    }

    public ActividadesPreparado getActividadesPreparado() {
        return actividadesPreparado;
    }

    public void setActividadesPreparado(ActividadesPreparado actividadesPreparado) {
        this.actividadesPreparado = actividadesPreparado;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public int getNecesitaMateriales() {
        return necesitaMateriales;
    }

    public void setNecesitaMateriales(int necesitaMateriales) {
        this.necesitaMateriales = necesitaMateriales;
    }


    
    public int getNroPaso() {
        return nroPaso;
    }

    public void setNroPaso(int nroPaso) {
        this.nroPaso = nroPaso;
    }

    public int getCodSubProcesoFormaFar() {
        return codSubProcesoFormaFar;
    }

    public void setCodSubProcesoFormaFar(int codSubProcesoFormaFar) {
        this.codSubProcesoFormaFar = codSubProcesoFormaFar;
    }


    public List<Maquinaria> getMaquinariaList() {
        return maquinariaList;
    }

    public void setMaquinariaList(List<Maquinaria> maquinariaList) {
        this.maquinariaList = maquinariaList;
    }
    
    
}
