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
public class FuentesDesviacionProduccion extends AbstractBean
{
    private int codFuenteDesviacionProduccion=0;
    private String nombreFuenteDesviacionProduccion="";

    public FuentesDesviacionProduccion() {
    }

    public int getCodFuenteDesviacionProduccion() {
        return codFuenteDesviacionProduccion;
    }

    public void setCodFuenteDesviacionProduccion(int codFuenteDesviacionProduccion) {
        this.codFuenteDesviacionProduccion = codFuenteDesviacionProduccion;
    }

    public String getNombreFuenteDesviacionProduccion() {
        return nombreFuenteDesviacionProduccion;
    }

    public void setNombreFuenteDesviacionProduccion(String nombreFuenteDesviacionProduccion) {
        this.nombreFuenteDesviacionProduccion = nombreFuenteDesviacionProduccion;
    }

    
    
}
