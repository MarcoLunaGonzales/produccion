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
public class DesviacionFormulaMaestraDetalleMp extends AbstractBean
{
    private List<DesviacionFormulaMaestraDetalleMpFracciones> desviacionFormulaMaestraDetalleMpFraccionesList;
    private Desviacion desviacion=null;
    private Materiales materiales=new Materiales();
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private Double cantidadUnitariaGramos=0d;
    private Double cantidadTotalGramos=0d;
    private Double densidadMaterial=0d;
    private Double cantidadTotalMaterial=0d;
    private Double cantidadMaximaMaterialPorFraccion=0d;
    

    public Desviacion getDesviacion() {
        return desviacion;
    }

    public void setDesviacion(Desviacion desviacion) {
        this.desviacion = desviacion;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }


    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public List<DesviacionFormulaMaestraDetalleMpFracciones> getDesviacionFormulaMaestraDetalleMpFraccionesList() {
        return desviacionFormulaMaestraDetalleMpFraccionesList;
    }

    public void setDesviacionFormulaMaestraDetalleMpFraccionesList(List<DesviacionFormulaMaestraDetalleMpFracciones> desviacionFormulaMaestraDetalleMpFraccionesList) {
        this.desviacionFormulaMaestraDetalleMpFraccionesList = desviacionFormulaMaestraDetalleMpFraccionesList;
    }

    public int getDesviacionFormulaMaestraDetalleMpFraccionesListSize()
    {
        return (this.desviacionFormulaMaestraDetalleMpFraccionesList!=null?this.desviacionFormulaMaestraDetalleMpFraccionesList.size():0);
    }
   
    public void calcularCantidadTotalFraccion()
    {
        cantidadTotalGramos=0d;
        for(DesviacionFormulaMaestraDetalleMpFracciones bean:desviacionFormulaMaestraDetalleMpFraccionesList)
        {
            cantidadTotalGramos+=bean.getCantidad();
        }
    }

    public Double getCantidadUnitariaGramos() {
        return cantidadUnitariaGramos;
    }

    public void setCantidadUnitariaGramos(Double cantidadUnitariaGramos) {
        this.cantidadUnitariaGramos = cantidadUnitariaGramos;
    }

    public Double getCantidadTotalGramos() {
        return cantidadTotalGramos;
    }

    public void setCantidadTotalGramos(Double cantidadTotalGramos) {
        this.cantidadTotalGramos = cantidadTotalGramos;
    }

    public Double getDensidadMaterial() {
        return densidadMaterial;
    }

    public void setDensidadMaterial(Double densidadMaterial) {
        this.densidadMaterial = densidadMaterial;
    }

    public Double getCantidadTotalMaterial() {
        return cantidadTotalMaterial;
    }

    public void setCantidadTotalMaterial(Double cantidadTotalMaterial) {
        this.cantidadTotalMaterial = cantidadTotalMaterial;
    }

   

    public Double getCantidadMaximaMaterialPorFraccion() {
        return cantidadMaximaMaterialPorFraccion;
    }

    public void setCantidadMaximaMaterialPorFraccion(Double cantidadMaximaMaterialPorFraccion) {
        this.cantidadMaximaMaterialPorFraccion = cantidadMaximaMaterialPorFraccion;
    }
    
}
