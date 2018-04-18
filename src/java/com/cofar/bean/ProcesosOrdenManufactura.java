/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author aquispe
 */
public class ProcesosOrdenManufactura extends AbstractBean{

    private int codProcesoOrdenManufactura=0;
    private String nombreProcesoOrdenManufactura="";
    private List<ComponentesProdVersionMaquinariaProceso> componentesProdVersionMaquinariaProcesoList;
    private List<ComponentesProdVersionEspecificacionProceso> componentesProdVersionEspecificacionProcesoList;
    private List<IndicacionProceso> indicacionProcesoList;
    private boolean aplicaTipoEspecificacion = false;
    
    
    public ProcesosOrdenManufactura() {
    }

    public int getCodProcesoOrdenManufactura() {
        return codProcesoOrdenManufactura;
    }

    public void setCodProcesoOrdenManufactura(int codProcesoOrdenManufactura) {
        this.codProcesoOrdenManufactura = codProcesoOrdenManufactura;
    }

    public String getNombreProcesoOrdenManufactura() {
        return nombreProcesoOrdenManufactura;
    }

    public void setNombreProcesoOrdenManufactura(String nombreProcesoOrdenManufactura) {
        this.nombreProcesoOrdenManufactura = nombreProcesoOrdenManufactura;
    }

    public List<ComponentesProdVersionMaquinariaProceso> getComponentesProdVersionMaquinariaProcesoList() {
        return componentesProdVersionMaquinariaProcesoList;
    }

    public void setComponentesProdVersionMaquinariaProcesoList(List<ComponentesProdVersionMaquinariaProceso> componentesProdVersionMaquinariaProcesoList) {
        this.componentesProdVersionMaquinariaProcesoList = componentesProdVersionMaquinariaProcesoList;
    }

    public List<ComponentesProdVersionEspecificacionProceso> getComponentesProdVersionEspecificacionProcesoList() {
        return componentesProdVersionEspecificacionProcesoList;
    }

    public void setComponentesProdVersionEspecificacionProcesoList(List<ComponentesProdVersionEspecificacionProceso> componentesProdVersionEspecificacionProcesoList) {
        this.componentesProdVersionEspecificacionProcesoList = componentesProdVersionEspecificacionProcesoList;
    }
    
    public int getComponentesProdVersionEspecificacionProcesoListSize()
    {
        return (this.componentesProdVersionEspecificacionProcesoList !=null?this.componentesProdVersionEspecificacionProcesoList.size():0);
    }

    public List<IndicacionProceso> getIndicacionProcesoList() {
        return indicacionProcesoList;
    }

    public void setIndicacionProcesoList(List<IndicacionProceso> indicacionProcesoList) {
        this.indicacionProcesoList = indicacionProcesoList;
    }
    public int getIndicacionProcesoListSize()
    {
        return (this.indicacionProcesoList!=null?this.indicacionProcesoList.size():0);
    }

    public boolean isAplicaTipoEspecificacion() {
        return aplicaTipoEspecificacion;
    }

    public void setAplicaTipoEspecificacion(boolean aplicaTipoEspecificacion) {
        this.aplicaTipoEspecificacion = aplicaTipoEspecificacion;
    }
    
    
    
}
