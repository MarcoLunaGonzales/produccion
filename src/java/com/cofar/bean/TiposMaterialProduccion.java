/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class TiposMaterialProduccion extends AbstractBean
{
    private List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPList;
    int codTipoMaterialProduccion = 0;
    String nombreTipoMaterialProduccion = "";

    public int getCodTipoMaterialProduccion() {
        return codTipoMaterialProduccion;
    }

    public void setCodTipoMaterialProduccion(int codTipoMaterialProduccion) {
        this.codTipoMaterialProduccion = codTipoMaterialProduccion;
    }

    public String getNombreTipoMaterialProduccion() {
        return nombreTipoMaterialProduccion;
    }

    public void setNombreTipoMaterialProduccion(String nombreTipoMaterialProduccion) {
        this.nombreTipoMaterialProduccion = nombreTipoMaterialProduccion;
    }

    public List<FormulaMaestraDetalleMP> getFormulaMaestraDetalleMPList() {
        return formulaMaestraDetalleMPList;
    }

    public void setFormulaMaestraDetalleMPList(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPList) {
        this.formulaMaestraDetalleMPList = formulaMaestraDetalleMPList;
    }
    public int getFormulaMaestraDetalleMPListSize()
    {
        return (formulaMaestraDetalleMPList != null ? formulaMaestraDetalleMPList.size() : 0);
    }
            
    
    public Double getCantidadUnitariaMaterialTotal()
    {
        Double cantidadUnitaria=0d;
        if(formulaMaestraDetalleMPList!=null)
        {
            for(FormulaMaestraDetalleMP bean:formulaMaestraDetalleMPList)
            {
                if(!bean.isMaterialExcepcionSumaTotal())
                    cantidadUnitaria+=bean.getCantidadUnitariaGramos();
            }
        }
        return cantidadUnitaria;
    }
    public Double getCantidadMaterialTotal()
    {
        Double cantidadTotal=0d;
        if(formulaMaestraDetalleMPList!=null)
        {
            for(FormulaMaestraDetalleMP bean:formulaMaestraDetalleMPList)
            {
                if(!bean.isMaterialExcepcionSumaTotal())
                    cantidadTotal+=bean.getCantidadTotalGramos();
            }
        }
        return cantidadTotal;
    }

}
