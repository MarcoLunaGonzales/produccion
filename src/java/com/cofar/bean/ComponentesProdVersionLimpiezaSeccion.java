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
public class ComponentesProdVersionLimpiezaSeccion extends AbstractBean
{
    private int codComponentesProdVersionLimpiezaSeccion=0;
    private ComponentesProdVersion componentesProdVersion = new ComponentesProdVersion();
    private AreasEmpresa areasEmpresa = new AreasEmpresa();
    private SeccionesOrdenManufactura seccionesOrdenManufactura=new SeccionesOrdenManufactura();
    private List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaMaquinariaList;
    
    public ComponentesProdVersionLimpiezaSeccion() {
    }

    public int getCodComponentesProdVersionLimpiezaSeccion() {
        return codComponentesProdVersionLimpiezaSeccion;
    }

    public void setCodComponentesProdVersionLimpiezaSeccion(int codComponentesProdVersionLimpiezaSeccion) {
        this.codComponentesProdVersionLimpiezaSeccion = codComponentesProdVersionLimpiezaSeccion;
    }

    public SeccionesOrdenManufactura getSeccionesOrdenManufactura() {
        return seccionesOrdenManufactura;
    }

    public void setSeccionesOrdenManufactura(SeccionesOrdenManufactura seccionesOrdenManufactura) {
        this.seccionesOrdenManufactura = seccionesOrdenManufactura;
    }

    public List<ComponentesProdVersionLimpiezaMaquinaria> getComponentesProdVersionLimpiezaMaquinariaList() {
        return componentesProdVersionLimpiezaMaquinariaList;
    }

    public void setComponentesProdVersionLimpiezaMaquinariaList(List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaMaquinariaList) {
        this.componentesProdVersionLimpiezaMaquinariaList = componentesProdVersionLimpiezaMaquinariaList;
    }
    
    public int getComponentesProdVersionLimpiezaMaquinariaListSize()
    {
        return (this.componentesProdVersionLimpiezaMaquinariaList!=null?componentesProdVersionLimpiezaMaquinariaList.size():0);
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }
    
    
   
}
