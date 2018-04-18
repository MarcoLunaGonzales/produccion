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
public class ComponentesProdVersionLimpiezaMaquinaria extends AbstractBean
{
    private ComponentesProdVersion componentesProdVersion = new ComponentesProdVersion();
    private AreasEmpresa areasEmpresa = new AreasEmpresa();
    private int codComponentesProdVersionLimpiezaMaquinaria = 0;
    private Maquinaria maquinaria=new Maquinaria();

    public ComponentesProdVersionLimpiezaMaquinaria() {
    }

    public int getCodComponentesProdVersionLimpiezaMaquinaria() {
        return codComponentesProdVersionLimpiezaMaquinaria;
    }

    public void setCodComponentesProdVersionLimpiezaMaquinaria(int codComponentesProdVersionLimpiezaMaquinaria) {
        this.codComponentesProdVersionLimpiezaMaquinaria = codComponentesProdVersionLimpiezaMaquinaria;
    }

   

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
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
