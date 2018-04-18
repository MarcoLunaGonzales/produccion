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
public class ComponentesProdVersionFiltroProduccion extends AbstractBean
{
    private int codComponentesProdVersionFiltroProduccion=0;
    private FiltrosProduccion filtrosProduccion=new FiltrosProduccion();

    public ComponentesProdVersionFiltroProduccion() {
    }

    public int getCodComponentesProdVersionFiltroProduccion() {
        return codComponentesProdVersionFiltroProduccion;
    }

    public void setCodComponentesProdVersionFiltroProduccion(int codComponentesProdVersionFiltroProduccion) {
        this.codComponentesProdVersionFiltroProduccion = codComponentesProdVersionFiltroProduccion;
    }

    public FiltrosProduccion getFiltrosProduccion() {
        return filtrosProduccion;
    }

    public void setFiltrosProduccion(FiltrosProduccion filtrosProduccion) {
        this.filtrosProduccion = filtrosProduccion;
    }
    
    
}
