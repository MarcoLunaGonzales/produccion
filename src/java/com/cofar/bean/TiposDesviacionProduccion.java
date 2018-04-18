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
public class TiposDesviacionProduccion extends AbstractBean 
{
    private int codTipoDesviacionProduccion=0;
    private String nombreTipoDesviacionProduccion="";

    public TiposDesviacionProduccion() {
    }

    public int getCodTipoDesviacionProduccion() {
        return codTipoDesviacionProduccion;
    }

    public void setCodTipoDesviacionProduccion(int codTipoDesviacionProduccion) {
        this.codTipoDesviacionProduccion = codTipoDesviacionProduccion;
    }

    public String getNombreTipoDesviacionProduccion() {
        return nombreTipoDesviacionProduccion;
    }

    public void setNombreTipoDesviacionProduccion(String nombreTipoDesviacionProduccion) {
        this.nombreTipoDesviacionProduccion = nombreTipoDesviacionProduccion;
    }
    
    
}
